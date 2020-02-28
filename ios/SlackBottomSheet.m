#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTUIManager.h>
#import <React/RCTUIManagerUtils.h>
#import <React/RCTViewManager.h>
#import <React/RCTShadowView.h>
#import <React/RCTView.h>
#import <objc/runtime.h>
#import "reactnativeslackbottomsheet-Swift.h"

@interface HelperView : UIView
@end

@implementation HelperView {
  __weak UIView *_view;
  __weak RCTBridge *_bridge;
}
- (void) setView: (UIView *) view bridge:(RCTBridge *)bridge {
  _view = view;
  _bridge = bridge;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [[_bridge uiManager] setSize:self.frame.size forView:_view];
}
@end

@interface InvisibleView: UIView
@property (nonatomic, nonnull) NSNumber *topOffset;
@property (nonatomic) BOOL isShortFormEnabled;
@property (nonatomic, nullable) NSNumber *longFormHeight;
@property (nonatomic, nonnull) NSNumber *cornerRadius;
@property (nonatomic, nonnull) NSNumber *springDamping;
@property (nonatomic, nonnull) NSNumber *transitionDuration;
@property (nonatomic) BOOL anchorModalToLongForm;
@property (nonatomic) BOOL allowsDragToDismiss;
@property (nonatomic) BOOL allowsTapToDismiss;
@property (nonatomic) BOOL isUserInteractionEnabled;
@property (nonatomic) BOOL isHapticFeedbackEnabled;
@property (nonatomic) BOOL shouldRoundTopCorners;
@property (nonatomic) BOOL showDragIndicator;
@property (nonatomic, nonnull) NSNumber *headerHeight;
@property (nonatomic, nonnull) NSNumber *shortFormHeight;
@property (nonatomic) BOOL startFromShortForm;
@end

@implementation InvisibleView {
  __weak RCTBridge *_bridge;
  BOOL addedSubview;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge {
  if (self = [super init]) {
    _bridge = bridge;
    _startFromShortForm = false;
    _topOffset = [[NSNumber alloc] initWithInt: 42];
    _isShortFormEnabled = true;
    _longFormHeight = nil;
    _cornerRadius = [[NSNumber alloc] initWithInt: 8.0];
    _springDamping = [[NSNumber alloc] initWithDouble: 0.8];
    _transitionDuration = [[NSNumber alloc] initWithDouble: 0.5];
    _anchorModalToLongForm = true;
    _allowsDragToDismiss = true;
    _allowsTapToDismiss = true;
    _isUserInteractionEnabled = true;
    _isHapticFeedbackEnabled = true;
    _shouldRoundTopCorners = true;
    _showDragIndicator = true;
    _headerHeight = [[NSNumber alloc] initWithInt:0];
    _shortFormHeight = [[NSNumber alloc] initWithInt:300];;
    _startFromShortForm = false;
    
  }
  return self;
}

- (void)addSubview:(UIView *)view {
  RCTExecuteOnMainQueue(^{
    if (self->addedSubview) {
      return;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    object_setClass(view, [HelperView class]);
    [(HelperView *)view setView:view bridge:self->_bridge];
    self->addedSubview = YES;
    
   [rootViewController presentPanModalWithView:view config:self];
  });
  
}

@end

@interface ModalViewManager : RCTViewManager
@end

@implementation ModalViewManager

RCT_EXPORT_MODULE(ModalView)
RCT_EXPORT_VIEW_PROPERTY(longFormHeight, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(cornerRadius, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(springDamping, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(transitionDuration, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(topOffset, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(headerHeight, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(shortFormHeight, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(isShortFormEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(anchorModalToLongForm, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsTapToDismiss, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsDragToDismiss, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isUserInteractionEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isHapticFeedbackEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(shouldRoundTopCorners, BOOL)
RCT_EXPORT_VIEW_PROPERTY(showDragIndicator, BOOL)
RCT_EXPORT_VIEW_PROPERTY(startFromShortForm, BOOL)

- (UIView *)view {
  return [[InvisibleView alloc] initWithBridge:self.bridge];
}

@end
