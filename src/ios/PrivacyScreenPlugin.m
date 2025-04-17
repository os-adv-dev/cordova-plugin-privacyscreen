/**
 * PrivacyScreenPlugin.java Cordova Plugin Implementation
 * Created by OutSystems Experts - April 2025.
 * Copyright (c) 2025 OutSystems Experts. All rights reserved.
 * MIT Licensed
 */
#import "PrivacyScreenPlugin.h"

static UIImageView *imageView;
static UIView *privacyView;

@implementation PrivacyScreenPlugin

- (void)pluginInitialize
{
  // initialize plugin state (disabled by default)
  self.pluginEnabled = NO;
  self.blurEnabled = NO;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:)
                                               name:UIApplicationDidBecomeActiveNotification object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:)
                                               name:UIApplicationWillResignActiveNotification object:nil];
}




- (void)onAppDidBecomeActive:(UIApplication *)application {
    [privacyView removeFromSuperview];
    privacyView = nil;
    
    if (imageView == NULL) {
      self.viewController.view.window.hidden = NO;
    } else {
      [imageView removeFromSuperview];
    }
}


- (void)onAppWillResignActive:(UIApplication *)application
{
    // only show privacy when enabled
    if (!self.pluginEnabled) {
        return;
    }
    // no blur: hide window entirely
    if (!self.blurEnabled) {
        self.viewController.view.window.hidden = YES;
        return;
    }
    if (privacyView == nil) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = UIScreen.mainScreen.bounds;
        privacyView = blurView;
    }
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    if (window && privacyView) {
        [window addSubview:privacyView];
    }
    
  /*CDVViewController *vc = (CDVViewController*)self.viewController;
  NSString *imgName = [self getImageName:self.viewController.interfaceOrientation delegate:(id<CDVScreenOrientationDelegate>)vc device:[self getCurrentDevice]];
  UIImage *splash = [UIImage imageNamed:imgName];
  if (splash == NULL) {
    imageView = NULL;
    self.viewController.view.window.hidden = YES;
  } else {
    imageView = [[UIImageView alloc]initWithFrame:[self.viewController.view bounds]];
    [imageView setImage:splash];
    
    #ifdef __CORDOVA_4_0_0
        [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    #else
        [self.viewController.view addSubview:imageView];
    #endif
  }*/
}

// Cordova command handlers
- (void)enable:(CDVInvokedUrlCommand*)command
{
    BOOL blur = [[command.arguments objectAtIndex:0] boolValue];
    self.pluginEnabled = YES;
    self.blurEnabled = blur;
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)disable:(CDVInvokedUrlCommand*)command
{
    self.pluginEnabled = NO;
    [privacyView removeFromSuperview]; privacyView = nil;
    self.viewController.view.window.hidden = NO;
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
// Code below borrowed from the CDV splashscreen plugin @ https://github.com/apache/cordova-plugin-splashscreen
// Made some adjustments though, becuase landscape splashscreens are not available for iphone < 6 plus
- (CDV_iOSDevice) getCurrentDevice
{
  CDV_iOSDevice device;
  
  UIScreen* mainScreen = [UIScreen mainScreen];
  CGFloat mainScreenHeight = mainScreen.bounds.size.height;
  CGFloat mainScreenWidth = mainScreen.bounds.size.width;
  
  int limit = MAX(mainScreenHeight,mainScreenWidth);
  
  device.iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
  device.iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
  device.retina = ([mainScreen scale] == 2.0);
  device.iPhone4 = (device.iPhone && limit == 480.0);
  device.iPhone5 = (device.iPhone && limit == 568.0);
  // note these below is not a true device detect, for example if you are on an
  // iPhone 6/6+ but the app is scaled it will prob set iPhone5 as true, but
  // this is appropriate for detecting the runtime screen environment
  device.iPhone6 = (device.iPhone && limit == 667.0);
  device.iPhone6Plus = (device.iPhone && limit == 736.0);
  device.iPhoneX  = (device.iPhone && limit == 812.0);
  
  return device;
}

- (BOOL) isUsingCDVLaunchScreen {
    NSString* launchStoryboardName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UILaunchStoryboardName"];
    if (launchStoryboardName) {
        return ([launchStoryboardName isEqualToString:@"CDVLaunchScreen"]);
    } else {
        return NO;
    }
}

- (NSString*)getImageName:(UIInterfaceOrientation)currentOrientation delegate:(id<CDVScreenOrientationDelegate>)orientationDelegate device:(CDV_iOSDevice)device
{
    // Use UILaunchImageFile if specified in plist.  Otherwise, use Default.
    NSString* imageName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UILaunchImageFile"];

    // detect if we are using CB-9762 Launch Storyboard; if so, return the associated image instead
    if ([self isUsingCDVLaunchScreen]) {
        imageName = @"LaunchStoryboard";
        return imageName;
    }

    NSUInteger supportedOrientations = [orientationDelegate supportedInterfaceOrientations];

    // Checks to see if the developer has locked the orientation to use only one of Portrait or Landscape
    BOOL supportsLandscape = (supportedOrientations & UIInterfaceOrientationMaskLandscape);
    BOOL supportsPortrait = (supportedOrientations & UIInterfaceOrientationMaskPortrait || supportedOrientations & UIInterfaceOrientationMaskPortraitUpsideDown);
    // this means there are no mixed orientations in there
    BOOL isOrientationLocked = !(supportsPortrait && supportsLandscape);

    if (imageName)
    {
        imageName = [imageName stringByDeletingPathExtension];
    }
    else
    {
        imageName = @"Default";
    }

    // Add Asset Catalog specific prefixes
    if ([imageName isEqualToString:@"LaunchImage"])
    {
        if (device.iPhone4 || device.iPhone5 || device.iPad) {
            imageName = [imageName stringByAppendingString:@"-700"];
        } else if(device.iPhone6) {
            imageName = [imageName stringByAppendingString:@"-800"];
        } else if(device.iPhone6Plus || device.iPhoneX ) {
            if(device.iPhone6Plus) {
                imageName = [imageName stringByAppendingString:@"-800"];
            } else {
                imageName = [imageName stringByAppendingString:@"-1100"];
            }
            if (currentOrientation == UIInterfaceOrientationPortrait || currentOrientation == UIInterfaceOrientationPortraitUpsideDown)
            {
                imageName = [imageName stringByAppendingString:@"-Portrait"];
            }
        }
    }

    if (device.iPhone5)
    { // does not support landscape
        imageName = [imageName stringByAppendingString:@"-568h"];
    }
    else if (device.iPhone6)
    { // does not support landscape
        imageName = [imageName stringByAppendingString:@"-667h"];
    }
    else if (device.iPhone6Plus || device.iPhoneX)
    { // supports landscape
        if (isOrientationLocked)
        {
            imageName = [imageName stringByAppendingString:(supportsLandscape ? @"-Landscape" : @"")];
        }
        else
        {
            switch (currentOrientation)
            {
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                        imageName = [imageName stringByAppendingString:@"-Landscape"];
                    break;
                default:
                    break;
            }
        }
        if (device.iPhoneX) {
            imageName = [imageName stringByAppendingString:@"-2436h"];
        } else {
            imageName = [imageName stringByAppendingString:@"-736h"];
        }
    }
    else if (device.iPad)
    {   // supports landscape
        if (isOrientationLocked)
        {
            imageName = [imageName stringByAppendingString:(supportsLandscape ? @"-Landscape" : @"-Portrait")];
        }
        else
        {
            switch (currentOrientation)
            {
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    imageName = [imageName stringByAppendingString:@"-Landscape"];
                    break;

                case UIInterfaceOrientationPortrait:
                case UIInterfaceOrientationPortraitUpsideDown:
                default:
                    imageName = [imageName stringByAppendingString:@"-Portrait"];
                    break;
            }
        }
    }

    return imageName;
}


@end
