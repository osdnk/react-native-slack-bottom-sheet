import { requireNativeComponent, Platform } from 'react-native';
import React from 'react';

export default Platform.select({
  ios: requireNativeComponent('ModalView'),
  get default() {
    console.warn(
      `BottomSheet is available only on iOS. Consider using 'cesardeazevedo/react-native-bottom-sheet-behavior' on Android or reanimated-bottom-sheet on web`
    );
    return () => null;
  },
});

export function withScreensWrapper(Component: any) {
  const RNS = require('react-native-screens');
  return function ScreensWrapper(props: object) {
    return (
      <RNS.ScreenContainer>
        <RNS.Screen active={true}>
          <Component {...props} />
        </RNS.Screen>
      </RNS.ScreenContainer>
    );
  };
}
