import UIKit

import PanModal

class PanModalViewController: UIViewController, PanModalPresentable {
  var config: NSObject?
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
        return last as? UIScrollView
      }
      last.subviews.forEach { subview in
        viewsToTraverse.append(subview)
      }
    }
    return nil
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

  var transitionDuration: Double {
    return Double(truncating: self.config?.value(forKey: "transitionDuration") as! NSNumber)
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

}


extension UIViewController {
  @objc public func presentPanModal(view: UIView, config: UIView) {

    let viewControllerToPresent: UIViewController & PanModalPresentable = PanModalViewController(config: config)
    viewControllerToPresent.view = view
    let sourceView: UIView? = nil, sourceRect: CGRect = .zero

    self.presentPanModal(viewControllerToPresent, sourceView: sourceView, sourceRect: sourceRect)
  }

}
