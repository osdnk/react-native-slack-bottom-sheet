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
  __weak RCTBridge *_bridge;
}

- (void)displayLayer:(CALayer*) layer {
  // shrug
}
- (void)setBridge:(RCTBridge *)bridge {
  _bridge = bridge;
}

- (void)setSpecialBounds:(CGRect)bounds {
  [self setBounds:bounds];
  [[_bridge uiManager] setSize:bounds.size forView:self];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [[_bridge uiManager] setSize:self.frame.size forView:self];
}
@end

@interface InvisibleView: RCTView
@property (nonatomic, nonnull) NSNumber *topOffset;
@property (nonatomic) BOOL isShortFormEnabled;
@property (nonatomic, nullable) NSNumber *longFormHeight;
@property (nonatomic, nonnull) NSNumber *cornerRadius;
@property (nonatomic, nonnull) NSNumber *springDamping;
@property (nonatomic, nonnull) NSNumber *transitionDuration;
@property (nonatomic, nonnull) NSNumber *backgroundOpacity;
@property (nonatomic) BOOL anchorModalToLongForm;
@property (nonatomic) BOOL allowsDragToDismiss;
@property (nonatomic) BOOL allowsTapToDismiss;
@property (nonatomic) BOOL isUserInteractionEnabled;
@property (nonatomic) BOOL isHapticFeedbackEnabled;
@property (nonatomic) BOOL shouldRoundTopCorners;
@property (nonatomic) BOOL showDragIndicator;
@property (nonatomic) BOOL blocksBackgroundTouches;
@property (nonatomic) BOOL interactsWithOuterScrollView;
@property (nonatomic) BOOL presentGlobally;
@property (nonatomic) BOOL initialAnimation;
@property (nonatomic, nonnull) NSNumber *headerHeight;
@property (nonatomic, nonnull) NSNumber *shortFormHeight;
@property (nonatomic) BOOL startFromShortForm;
@property (nonatomic, copy, nullable) RCTBubblingEventBlock onWillTransition;
@property (nonatomic, copy, nullable) RCTBubblingEventBlock onWillDismiss;
@property (nonatomic, copy, nullable) RCTBubblingEventBlock onDidDismiss;
@end

@implementation InvisibleView {
  __weak RCTBridge *_bridge;
  UIView* addedSubview;
  UIView* outerView;
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
    _blocksBackgroundTouches = true;
    _headerHeight = [[NSNumber alloc] initWithInt:0];
    _shortFormHeight = [[NSNumber alloc] initWithInt:300];;
    _startFromShortForm = false;
    _presentGlobally = true;
    _interactsWithOuterScrollView = false;
    _initialAnimation = true;
    _backgroundOpacity = [[NSNumber alloc] initWithDouble:0.7];
  }
  return self;
}

- (void)callWillDismiss {
  _onWillDismiss(@{});
}

- (void)callDidDismiss {
  _onDidDismiss(@{});
}

- (void)callWillTransitionLong {
  _onWillTransition(@{@"type": @"long"});
}

- (void)callWillTransitionShort {
  _onWillTransition(@{@"type": @"short"});
}

- (void)layoutSubviews {
  [self setPresentGlobally:_presentGlobally];
  [super layoutSubviews];
}

- (void)setPresentGlobally:(BOOL)presentGlobally {
  outerView = presentGlobally ? nil : self.reactSuperview;
  _presentGlobally = presentGlobally;
}


- (void)addSubview:(UIView *)view {
  if (addedSubview == nil) {
    addedSubview = view;
    [self setPresentGlobally:_presentGlobally];
    RCTExecuteOnMainQueue(^{
      UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
      object_setClass(self->addedSubview, [HelperView class]);
      [(HelperView *)self->addedSubview setBridge: self->_bridge];
      
      [rootViewController presentPanModalWithView:self->addedSubview config:self];
    });
  }
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
RCT_EXPORT_VIEW_PROPERTY(backgroundOpacity, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(topOffset, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(headerHeight, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(shortFormHeight, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(isShortFormEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(anchorModalToLongForm, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsTapToDismiss, BOOL)
RCT_EXPORT_VIEW_PROPERTY(allowsDragToDismiss, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isUserInteractionEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(blocksBackgroundTouches, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isHapticFeedbackEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(shouldRoundTopCorners, BOOL)
RCT_EXPORT_VIEW_PROPERTY(showDragIndicator, BOOL)
RCT_EXPORT_VIEW_PROPERTY(startFromShortForm, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onWillTransition, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onWillDismiss, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDidDismiss, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(presentGlobally, BOOL)
RCT_EXPORT_VIEW_PROPERTY(interactsWithOuterScrollView, BOOL)
RCT_EXPORT_VIEW_PROPERTY(initialAnimation, BOOL)

- (UIView *)view {
  return [[InvisibleView alloc] initWithBridge:self.bridge];
}

@end
