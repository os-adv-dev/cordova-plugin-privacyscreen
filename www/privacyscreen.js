var exec = require('cordova/exec');

/**
 * PrivacyScreen plugin interface
 */
var PrivacyScreen = {
  /**
   * Enable privacy screen functionality.
   * @param {boolean} blur If true, apply blur effect (iOS only); false hides view.
   * @param {boolean} allowScreenshot If true, allow screenshots (Android only); false blocks them.
   * @param {function} [success] Optional success callback.
   * @param {function} [error] Optional error callback.
   */
  enable: function(blur, allowScreenshot, success, error) {
    return exec(
      success || function() {},
      error   || function() {},
      'PrivacyScreen',
      'enable',
      [ !!blur, !!allowScreenshot ]
    );
  },

  /**
   * Disable privacy screen functionality.
   * @param {function} [success] Optional success callback.
   * @param {function} [error] Optional error callback.
   */
  disable: function(success, error) {
    return exec(success || function() {}, error || function() {}, 'PrivacyScreen', 'disable', []);
  }
};

module.exports = PrivacyScreen;