//
//  File.swift
//  
//
//  Created by iWw on 2020/12/11.
//

import UIKit
import Keyboard
import WeakObserver

private extension KeyboardNotifiable where Self: UIResponder {
    
    var __keyboardNotifiableObserver: NotificationWeakObserver? {
        get {
            objc_getAssociatedObject(self, &KeyboardKeys.targetKey) as? NotificationWeakObserver
        }
        set {
            objc_setAssociatedObject(self, &KeyboardKeys.targetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func __keyboardWillChangeFrame(_ notify: Notification) {
        guard let userInfo = notify.userInfo else { return }
        
        guard let keyboardBounds = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        
        UIView.animate(withDuration: duration, delay: 0, options: [UIView.AnimationOptions(rawValue: UInt(curve)), .beginFromCurrentState]) {
            self.keyboardFrame = keyboardBounds
            self.keyboardWillChangeFrameWithAnimation(self.isKeyboardShowing, keyboardBounds)
            if self.isKeyboardShowing {
                self.keyboardWillShow(keyboardBounds)
            } else {
                self.keyboardWillHide(keyboardBounds)
            }
        } completion: { _ in
            self.keyboardDidChangeFrame(self.isKeyboardShowing, keyboardBounds)
            
            if self.isKeyboardShowing {
                self.keyboardDidShow(keyboardBounds)
            } else {
                self.keyboardDidHidden(keyboardBounds)
            }
        }
    }
}

public extension KeyboardNotifiable where Self: UIResponder {
    
    var keyboardFrame: CGRect {
        get {
            (objc_getAssociatedObject(self, &KeyboardKeys.frameKey) as? CGRect) ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &KeyboardKeys.frameKey, NSValue(cgRect: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isKeyboardShowing: Bool {
        keyboardFrame != .zero && keyboardFrame.origin.y < UIScreen.main.bounds.height
    }
    
    var isRespondToKeyboard: Bool {
        get {
            if let number = (objc_getAssociatedObject(self, &KeyboardKeys.respond) as? NSNumber) {
                return number.boolValue
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &KeyboardKeys.respond, NSNumber(booleanLiteral: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func activatingKeyboardNotifiable() {
        let _ = Keyboard.shared
        
        self.__keyboardNotifiableObserver = NotificationWeakObserver(self, name: Keyboard.WillChangeFrameNotification, object: nil, using: { [weak self] (notify) in
            guard var self = self else { return }
            guard self.isRespondToKeyboard else { return }
            
            if let keyboardBounds = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.keyboardFrame = keyboardBounds
            }
            self.__keyboardWillChangeFrame(notify)
        })
    }
}

