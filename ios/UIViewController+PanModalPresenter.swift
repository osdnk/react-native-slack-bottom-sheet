import UIKit

import PanModal

class BetterGestureRecognizerDelegateAdapter: NSObject, UIGestureRecognizerDelegate {
  var grd: UIGestureRecognizerDelegate
  var config: NSObject
  required init(grd: UIGestureRecognizerDelegate, config: NSObject) {
    self.grd = grd
    self.config = config
    super.init()
  }
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return self.grd.gestureRecognizer!(gestureRecognizer, shouldBeRequiredToFailBy: otherGestureRecognizer)
  }

  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return self.grd.gestureRecognizer!(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer)
  }

  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {

    if (String(describing: type(of: otherGestureRecognizer))
      == "UIScrollViewPanGestureRecognizer"
      && (grd as? UIPresentationController)?.presentedViewController is PanModalPresentable && otherGestureRecognizer.view != ((grd as? UIPresentationController)?.presentedViewController as? PanModalPresentable)?.panScrollable) {
      return self.config.value(forKey: "interactsWithOuterScrollView") as! Bool
    }
    return false
  }
}

class PossiblyTouchesPassableUIView: UIView {
  var grdelegate: UIGestureRecognizerDelegate?
  var config: NSObject?
  var topLayoutGuideLength: CGFloat?
  var oldClass: AnyClass?
  var justModifiedClass: NSNumber?


  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let blocksBackgroundTocuhes = self.config?.value(forKey: "blocksBackgroundTouches") as! Bool
    if (blocksBackgroundTocuhes || self.subviews[1].frame.contains(point)) {
      return super.hitTest(point, with: event)
    }
    return nil
  }
  //  // I don't really want to talk about it
  override func layoutSubviews() {
    super.layoutSubviews()
    let outerView = self.config?.value(forKey: "outerView") as? UIView
    if (!(self.config!.value(forKey: "presentGlobally") as! Bool)) {
      removeFromSuperview()
      let helperView: UIView = self.subviews[1].subviews[0]
      let bounds = outerView!.bounds
      let topOffset:CGFloat = (topLayoutGuideLength ?? 0) + CGFloat(truncating: self.config?.value(forKey: "topOffset") as! NSNumber)
      let newBounds = CGRect.init(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height - topOffset)
      helperView.setValue(newBounds, forKeyPath: "specialBounds")
      outerView?.addSubview(self)
    }
    let gr: UIGestureRecognizer = self.gestureRecognizers![0]
    grdelegate = BetterGestureRecognizerDelegateAdapter.init(grd: gr.delegate!, config: config!)
    gr.delegate = grdelegate
    if outerView == nil {
      makeOldClass()
    }
  }

  func makeOldClass() {
    if self.oldClass != nil {
      let oldClassMem: AnyClass = self.oldClass!
      self.oldClass = nil
      object_setClass(self, oldClassMem)
    }
  }

  override func didMoveToWindow() {
    if self.window == nil {
      if (justModifiedClass?.isEqual(to: true))! {
        justModifiedClass = NSNumber.init(value: false)
        super.didMoveToWindow()
        return
      }
      makeOldClass()
    }
    super.didMoveToWindow()
  }
}

var PossiblyTouchesPassableUITransitionView: AnyClass?  = nil;

class PanModalViewController: UIViewController, PanModalPresentable {
  func hide() {
    
  }
  
  func unhackParent() {
    
  }
  
  var config: NSObject?
  var scrollView: UIScrollView?
  convenience init(config: NSObject) {
    self.init()
    self.config = config
  }


  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  func findChildScrollViewDFS(view: UIView)-> UIScrollView? {
    var viewsToTraverse = [view]
    while !viewsToTraverse.isEmpty {
      let last = viewsToTraverse.last!
      viewsToTraverse.removeLast()
      if last is UIScrollView {
        scrollView = (last as! UIScrollView);
        scrollView!.scrollsToTop = self.config?.value(forKey: "scrollsToTop") as! Bool
        return last as? UIScrollView
      }
      last.subviews.forEach { subview in
        viewsToTraverse.append(subview)
      }
    }
    return nil
  }

  @objc func setScrollsToTop(scrollsToTop: NSNumber) {
    scrollView?.scrollsToTop = scrollsToTop.boolValue;
  }

  var panScrollable: UIScrollView? {
    return findChildScrollViewDFS(view: self.view!)
  }

  var shortFormHeight: PanModalHeight {
    let height: CGFloat = CGFloat(truncating: self.config?.value(forKey: "shortFormHeight") as! NSNumber)
    return isShortFormEnabled ? .contentHeight(height) : longFormHeight
  }

  var topOffset: CGFloat {
    let topOffset: CGFloat = CGFloat(truncating: self.config?.value(forKey: "topOffset") as! NSNumber)
    return topLayoutGuide.length + topOffset
  }

  var isShortFormEnabledInternal = 2
  var isShortFormEnabled: Bool {
    let startFromShortForm = self.config?.value(forKey: "startFromShortForm") as! Bool
    if isShortFormEnabledInternal > 0 && !startFromShortForm {
      isShortFormEnabledInternal -= 1
      return false
    }
    return self.config?.value(forKey: "isShortFormEnabled") as! Bool
  }

  var longFormHeight: PanModalHeight {
    if self.config?.value(forKey: "longFormHeight") == nil {
      return .maxHeight
    }
    return .contentHeight(CGFloat(truncating: self.config?.value(forKey: "longFormHeight") as! NSNumber))
  }

  var cornerRadius: CGFloat {
    return CGFloat(truncating: self.config?.value(forKey: "cornerRadius") as! NSNumber)
  }

  var springDamping: CGFloat {
    return CGFloat(truncating: self.config?.value(forKey: "springDamping") as! NSNumber)
  }

  var isInitialAnimation = 3

  var transitionDuration: Double {
    if isInitialAnimation > 0 && !(self.config?.value(forKey: "initialAnimation") as! Bool)
    {
      isInitialAnimation -= 1
      return 0.0
    }
    return Double(truncating: self.config?.value(forKey: "transitionDuration") as! NSNumber)
  }

  var panModalBackgroundColor: UIColor {
    return UIColor.black.withAlphaComponent(CGFloat(truncating: self.config?.value(forKey: "backgroundOpacity") as! NSNumber))

  }
  var anchorModalToLongForm: Bool {
    return self.config?.value(forKey: "anchorModalToLongForm") as! Bool
  }

  var allowsDragToDismiss: Bool {
    return self.config?.value(forKey: "allowsDragToDismiss") as! Bool
  }

  var allowsTapToDismiss: Bool {
    return self.config?.value(forKey: "allowsTapToDismiss") as! Bool
  }

  var isUserInteractionEnabled: Bool {
    return self.config?.value(forKey: "isUserInteractionEnabled") as! Bool  }

  var isHapticFeedbackEnabled: Bool {
    return self.config?.value(forKey: "isHapticFeedbackEnabled") as! Bool  }

  var shouldRoundTopCorners: Bool {
    let pview = view.superview!.superview!
    if !(pview is PossiblyTouchesPassableUIView) {
      let oldClass: AnyClass = type(of: pview)
      object_setClass(pview, PossiblyTouchesPassableUIView.self)
      (pview as! PossiblyTouchesPassableUIView).config = self.config
      (pview as! PossiblyTouchesPassableUIView).topLayoutGuideLength = self.topLayoutGuide.length
      (pview as! PossiblyTouchesPassableUIView).oldClass = oldClass
      (pview as! PossiblyTouchesPassableUIView).justModifiedClass = NSNumber.init(value: true)
    }
    return self.config?.value(forKey: "shouldRoundTopCorners") as! Bool
  }

  var showDragIndicator: Bool {
    return self.config?.value(forKey: "showDragIndicator") as! Bool
  }

  var scrollIndicatorInsets: UIEdgeInsets {
    let bottomOffset = presentingViewController?.bottomLayoutGuide.length ?? 0
    return UIEdgeInsets(top: 0, left: 0, bottom: bottomOffset, right: 0)
  }


  func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
    let headerHeight: CGFloat = CGFloat(truncating: self.config?.value(forKey: "headerHeight") as! NSNumber)
    let location = panModalGestureRecognizer.location(in: view)
    return location.y < headerHeight
  }

  func willTransition(to state: PanModalPresentationController.PresentationState) {
    if self.config?.value(forKey: "onWillTransition") != nil {
      if state == .longForm {
        self.config?.performSelector(inBackground: Selector.init(("callWillTransitionLong")), with: nil)
      } else {
        self.config?.performSelector(inBackground: Selector.init(("callWillTransitionShort")), with: nil)
      }
    }
  }

  func panModalWillDismiss() {
    if self.config?.value(forKey: "onWillDismiss") != nil {
      self.config?.performSelector(inBackground: Selector.init(("callWillDismiss")), with: nil)
    }
  }

  func panModalDidDismiss() {
    if self.config?.value(forKey: "onDidDismiss") != nil {
      self.config?.performSelector(inBackground: Selector.init(("callDidDismiss")), with: nil)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    let pview = view?.superview?.superview!
    if (pview is PossiblyTouchesPassableUIView) {
      (pview as! PossiblyTouchesPassableUIView).makeOldClass()
    }
    super.viewWillDisappear(animated)
  }
}


extension UIViewController {
  @objc public func presentPanModal(view: UIView, config: UIView) -> UIViewController {

    let viewControllerToPresent: UIViewController & PanModalPresentable = PanModalViewController(config: config)
    viewControllerToPresent.view = view
    let sourceView: UIView? = nil, sourceRect: CGRect = .zero

    self.presentPanModal(viewControllerToPresent, sourceView: sourceView, sourceRect: sourceRect)
    return viewControllerToPresent
  }
}
