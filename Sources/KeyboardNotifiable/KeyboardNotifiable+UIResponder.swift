//
//  File.swift
//  
//
//  Created by iWw on 2020/12/11.
//

import UIKit
import Keyboard

private extension KeyboardNotifiable where Self: UIResponder {
    
    var __keyboardObserver: KeyboardObserver? {
        get {
            objc_getAssociatedObject(self, &KeyboardKeys.targetKey) as? KeyboardObserver
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
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(UIView.AnimationCurve.init(rawValue: curve)!)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        self.keyboardFrame = keyboardBounds
        keyboardWillChangeFrameWithAnimation(isKeyboardShowing, keyboardBounds)
        
        if isKeyboardShowing {
            keyboardWillShow(keyboardBounds)
        } else {
            keyboardWillHide(keyboardBounds)
        }
        
        UIView.commitAnimations()
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
    
    func activatingKeyboardNotifiable() {
        self.__keyboardObserver = KeyboardObserver.observer(self, using: { [weak self] (notify) in
            guard var self = self else { return }
            if let keyboardBounds = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.keyboardFrame = keyboardBounds
            }
            self.__keyboardWillChangeFrame(notify)
        })
    }
}

