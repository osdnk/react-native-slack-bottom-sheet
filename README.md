# react-native-slack-bottom-sheet

React Native Bottom Sheet

## TODO

It's WIP so don't use it now

 - [ ] Add usage example in readme
 - [x] Add callbacks on close / open / transition
 - [x] Describe props
 - [x] Export more options from Slack library
 - [x] Add stub on Android and explanation
 - [x] Add commit name check
 - [x] Squash commits and release
 - [ ] add typings to native component and probably wrapper 
## Installation
1. Change `platform :ios, '9.0'` to `platform :ios, '10.0'` in Podfile
2. Open `ios/YourAppName.xcworkplace` in Xcode
   
   Right-click on Your App Name in the Project Navigator on the left, and click New File…
   
   Create a single empty Swift file to the project (make sure that Your App Name target is selected when adding), and when Xcode asks, press Create Bridging Header and do not remove Swift file then.
   
   (detailed screenshots in `installation` folder)
3. 
```bash
npm install react-native-slack-bottom-sheet
cd ios && pod install && cd ..
```

## License

MIT
