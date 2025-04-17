/**
 * PrivacyScreenPlugin.java Cordova Plugin Implementation
 * Created by OutSystems Experts - April 2025.
 * Copyright (c) 2025 OutSystems Experts. All rights reserved.
 * MIT Licensed
 */
package com.outsystems.experts.privacyscreen;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import android.app.Activity;
import android.os.Build;
import android.view.WindowManager;

import org.json.JSONArray;
import org.json.JSONException;


/**
 * This class sets the FLAG_SECURE flag on the window to make the app
 *  private when shown in the task switcher
 */
public class PrivacyScreenPlugin extends CordovaPlugin {

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    // initial state: plugin disabled until enable() is called
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if ("enable".equals(action)) {
      // args: [ blurIgnored, allowScreenshot ]
      boolean allowScreenshot = args.optBoolean(1, false);
      enable(allowScreenshot);
      callbackContext.success();
      return true;
    } else if ("disable".equals(action)) {
      disable();
      callbackContext.success();
      return true;
    }
    return false;
  }

  /**
   * Enable privacy screen.
   * @param allowScreenshot flag to prevent or allow the user to take screenshots
   */
  private void enable(final boolean allowScreenshot) {
    final Activity activity = this.cordova.getActivity();
    activity.runOnUiThread(new Runnable() {
      @Override
      public void run() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
          activity.setRecentsScreenshotEnabled(false);
          if (!allowScreenshot){
            activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
          }
        } else {
          activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
        }
      }
    });
  }

  private void disable() {
    final Activity activity = this.cordova.getActivity();
    activity.runOnUiThread(new Runnable() {
      @Override
      public void run() {
        // allow screenshots and recent previews
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
          activity.setRecentsScreenshotEnabled(true);
        }
        activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
      }
    });
  }
}