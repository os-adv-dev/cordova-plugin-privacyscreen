/**
 * PrivacyScreenPlugin.java Cordova Plugin Implementation
 * Created by OutSystems Experts - April 2025.
 * Copyright (c) 2025 OutSystems Experts. All rights reserved.
 * MIT Licensed
 */
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

typedef struct {
  BOOL iPhone;
  BOOL iPad;
  BOOL iPhone4;
  BOOL iPhone5;
  BOOL iPhone6;
  BOOL iPhone6Plus;
  BOOL retina;
  BOOL iPhoneX;
  
} CDV_iOSDevice;

@interface PrivacyScreenPlugin : CDVPlugin

// whether plugin is active
@property (nonatomic, assign) BOOL pluginEnabled;
// whether to use blur effect
@property (nonatomic, assign) BOOL blurEnabled;

/**
 * Enable privacy screen.
 * @param command Cordova command with arguments: [ blur(boolean) ]
 */
- (void)enable:(CDVInvokedUrlCommand*)command;

/**
 * Disable privacy screen.
 * @param command Cordova command
 */
- (void)disable:(CDVInvokedUrlCommand*)command;
@end