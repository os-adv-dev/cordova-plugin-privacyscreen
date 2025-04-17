# cordova-plugin-privacyscreen

Cordova plugin to protect your app's content when it is backgrounded or shown in the recent apps view.
On iOS it adds a blur overlay (or hides the view), and on Android it uses FLAG_SECURE to block screenshots.

## Installation
Install via Cordova CLI:
```bash
cordova plugin add cordova-plugin-privacyscreen
```

Or via npm:
```bash
npm install cordova-plugin-privacyscreen --save
cordova plugin add cordova-plugin-privacyscreen
```

## Platforms
- iOS (>= 10.0)
- Android (>= API 16)

## API
This plugin exposes a global `privacyScreen` object with two methods:

### privacyScreen.enable(blur, [success], [error])
- `blur` (boolean): on iOS, `true` shows a blur overlay when the app resigns active; `false` hides the view entirely.  
  On Android, this parameter is ignored—`enable` always applies FLAG_SECURE to block screenshots.
- `success` (Function, optional): called on success.  
- `error` (Function, optional): called on error.

Example:
```js
// iOS: blur overlay
privacyScreen.enable(true);

// iOS: hide view (no blur)
privacyScreen.enable(false);

// Android: always blocks screenshots, blur param is ignored
privacyScreen.enable(true);  // still blocks screenshots
```

### privacyScreen.disable([success], [error])
Disables the privacy screen, removes blur overlays on iOS and clears FLAG_SECURE on Android to allow screenshots.

```js
privacyScreen.disable(
  () => console.log('privacy disabled'),
  err => console.error('error disabling privacy', err)
);
```

## License
MIT