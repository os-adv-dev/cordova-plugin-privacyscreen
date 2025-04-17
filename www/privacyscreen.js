var exec = require('cordova/exec');

/**
 * PrivacyScreen plugin interface
 */
var PrivacyScreen = {
  /**
   * Enable privacy screen functionality.
   * @param {boolean} blur If true, apply blur effect (iOS only); false hides view without blur.
   * @param {boolean} recents If true, allow recents screenshots (Android only); false blocks them.
   * @param {function} [success] Optional success callback.
   * @param {function} [error] Optional error callback.
   */
  enable: function(blur, recents, success, error) {
    var args;
    var scb, ecb;
    // If recents is actually the success callback, shift arguments (no recents flag provided)
    if (typeof recents === 'function') {
      scb = recents;
      ecb = success;
      args = [!!blur, false];
    } else {
      scb = success;
      ecb = error;
      args = [!!blur, !!recents];
    }
    return exec(scb || function() {}, ecb || function() {}, 'PrivacyScreen', 'enable', args);
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