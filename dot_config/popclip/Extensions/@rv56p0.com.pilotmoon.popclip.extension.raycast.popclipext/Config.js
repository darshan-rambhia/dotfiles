// #popclip extension snippet to send text to Raycast
// name: Raycast
// identifier: com.pilotmoon.popclip.extension.raycast
// popclip version: 4151
// description: Activate Raycast with the selected text.
// icon: iconify:simple-icons:raycast
// app: { name: Raycast, link: https://www.raycast.com/ }
// language: javascript
popclip.performCommand("copy");
popclip.openUrl("raycast://");
await sleep(100);
popclip.pressKey("command V");