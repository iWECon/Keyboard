//
//  Created by iWw on 2021/1/22.
//

import UIKit
import WeakObserver

@propertyWrapper
public struct KeyboardResponder<T: UIView> {
    
    var value: T
    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    var observer: NotificationWeakObserver?
    
    public init(wrappedValue: T) {
        self.value = wrappedValue
        // listen keybaord observer
        let self_ = self
        self.observer = NotificationWeakObserver(wrappedValue, name: UIResponder.keyboardWillChangeFrameNotification) { (notify) in
            guard wrappedValue.superview != nil, wrappedValue.window != nil else { return }
            self_.__keyboardWillChangeFrame(notify)
        }
    }
    
    func __keyboardWillChangeFrame(_ notify: Notification) {
        guard let userInfo = notify.userInfo else { return }
        
        guard let keyboardBounds = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(UIView.AnimationCurve.init(rawValue: curve)!)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        let isShow = keyboardBounds != .zero && keyboardBounds.origin.y < UIScreen.main.bounds.height
        if isShow {
            let maxY = UIScreen.main.bounds.height - keyboardBounds.height
            if maxY == value.frame.maxY {
                return
            }
            let diff = maxY - value.frame.maxY
            self.wrappedValue.transform = .init(translationX: 0, y: -diff)
        } else {
            self.wrappedValue.transform = .identity
        }
        UIView.commitAnimations()
    }
}
