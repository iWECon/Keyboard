//
//  Created by iWw on 2021/1/22.
//

import UIKit
import WeakObserver

@propertyWrapper
public struct KeyboardResponder<T: UIView> {
    
    weak var value: T?
    public var wrappedValue: T? {
        get { value }
        set { value = newValue }
    }
    
    var observer: NotificationWeakObserver?
    
    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
        // listen keybaord observer
        guard let wrappedValue = wrappedValue else { return }
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
            self.wrappedValue?.transform = .init(translationX: 0, y: -keyboardBounds.height)
        } else {
            self.wrappedValue?.transform = .identity
        }
        UIView.commitAnimations()
    }
}