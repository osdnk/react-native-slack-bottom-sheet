import { requireNativeComponent, Platform } from 'react-native';

export default Platform.select({
  ios: requireNativeComponent('ModalView'),
  get default() {
    console.warn(
      `BottomSheet is available only on iOS. Consider using 'cesardeazevedo/react-native-bottom-sheet-behavior' on Android or reanimated-bottom-sheet on web`
    );
    return () => null;
  },
});
