# React Native Slack Bottom Sheet

React Native binding for [Slack Bottom Sheet](https://github.com/slackhq/PanModal/tree/master/PanModal)

![](preview.gif) 

[Rainbow App](https://github.com/rainbow-me/rainbow). The first consumer of this library.

## TODOs 

 - [ ] Add motivation to README
 - [x] Add gifs to README
 - [x] Add usage example in readme
 - [x] Add callbacks on close / open / transition
 - [x] Describe props
 - [x] Export more options from Slack library
 - [x] Add stub on Android and explanation
 - [x] Add commit name check
 - [x] Squash commits and release
 - [ ] add typings to native component and probably some wrapper 
 - [ ] Navigation bindings and adapter for android bottom-sheet
 
 It's WIP so use it if you're brave enough.
 
 ## Usage
 
 
 ```jsx
import SlackBottomSheet from 'react-native-slack-bottom-sheet';

<SlackBottomSheet
  topOffset={100}
  unmountAnimation={false}
  initialAnimation={false}
  presentGlobally={false}
  backgroundOpacity={0}
  allowsDragToDismiss={false}
  allowsTapToDismiss={false}
  isHapticFeedbackEnabled={false}
  blocksBackgroundTouches={false}
  interactsWithOuterScrollView
>
  <View style={StyleSheet.absoluteFillObject}>
    <ScrollView>
      <Lorem />
    </ScrollView>
  </View>
</SlackBottomSheet>

```
 
 ## Props
 
 none of props but for children are required.
 If prop is experimental it means that setting it might leads to unexpected behavior.
 Probably I'm using most of them so don't be too concerned.
 
 
 | name                         |  default | experimental | description |
 | ---------------------------- | -------- | -------------| ------------|
 | allowsDragToDismiss          | true     |              | A flag to determine if dismissal should be initiated when swiping down on the presented view.
 | allowsTapToDismiss           | true     |              | A flag to determine if dismissal should be initiated when tapping on the dimmed background view.            
 | anchorModalToLongForm        | true     |              | A flag to determine if scrolling should be limited to the longFormHeight. Set false to cap scrolling at .max height
 | backgroundOpacity            | 0.7      |              | The background view color opacity
 | blocksBackgroundTouches      | true     | 💁 💁         | A flag to determine if the content below background should accept touches
 | cornerRadius                 | 8.0      |              | The corner radius used when `shouldRoundTopCorners` is enabled
 | headerHeight                 | 0        |              | The Height of spaces on the top of modal always prioritizing dismissing over scrolling content
 | initialAnimation             | true     | 💁           | A flag to determine of the component should animate on mount    
 | interactsWithOuterScrollView | false    | 💁 💁        | A flag to determine if ScrollView wrapping modal should accept touches. Note: works only with `presentGlobally: false` 
 | isHapticFeedbackEnabled      | true     |              | A flag to determine if haptic feedback should be enabled during presentation.
 | isShortFormEnabled           | true     |              | A flag to determine if the short form of modal should be available
 | isUserInteractionEnabled     | true     |              | A flag to toggle user interactions on the container view. Note: Return false to forward touches to the presentingViewController.       
 | longFormHeight               | maxHeight + offset |    | The height of the pan modal container view when in the longForm presentation state. This value is capped to .max, if provided value exceeds the space available
 | onDidDismiss                 |          |              | Callback on did dismiss
 | onWillDismiss                |          |              | Callback on will dismiss       
 | onWillTransition             |          |              | Callback on will transition     
 | presentGlobally              | true     | 💁 💁 💁      | Bottom Sheet is presented over the whole content by default. If this flag is set to true, sheet could be presented inside another component as well       
 | shortFormHeight              | 300      |              | The height of the pan modal container view when in the shortForm presentation state. This value is capped to .max, if the provided value exceeds the space available     
 | shouldRoundTopCorners        | true     |              | A flag to determine if the top corners should be rounded.                
 | showDragIndicator            | true     |              | A flag to determine if a drag indicator should be shown above the pan modal container view
 | springDamping                | 0.8      |              | The springDamping value used to determine the amount of 'bounce' seen when transitioning to short/long form
 | startFromShortForm           | false    |              | A flag to determine if the component should start from instead of long one
 | topOffset                    | 42       |              | The offset between the top of the screen and the top of the pan modal container view.|
 | transitionDuration           | 0.5      |              | The transitionDuration value is used to set the speed of animation during a transition, including initial presentation
 | unmountAnimation             | true     | 💁           | A flag to determine of the component should animate on unmount        
 | visible                      | true     | 💁           | A flag for hiding or showing modal. Basically works in the same way like mounting and unmounting.
 
## RN Screens
It does not work with modals from RN Screens by default.
If your app's using RN Screens either unmount all bottom sheets before pushing any modals or wrap bottom sheet in `withScreensWrapper` HOC. 


  
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
