//
//  File.swift
//  
//
//  Created by iWw on 2020/12/10.
//

import UIKit
import Keyboard

public protocol KeyboardNotifiable {
    
    /// 激活键盘出现/消失的监听，一般用在 viewDidLoad 中即可
    func activatingKeyboardNotifiable()
    
    /// 键盘 frame 发生改变时，实现内容已包含在动画块中
    /// - Parameters:
    ///   - isVisiable: true：键盘将要出现，false 键盘将要消失
    ///   - targetFrame: 出现/消失时键盘的 frame
    func keyboardWillChangeFrameWithAnimation(_ isVisiable: Bool, _ targetFrame: CGRect)
    
    /// 键盘将要显示，实现内容已包含在动画块中
    /// - Parameter targetFrame: 键盘目标 frame
    func keyboardWillShow(_ targetFrame: CGRect)
    
    /// 键盘将要隐藏，实现内容已包含在动画块中
    /// - Parameter targetFrame: 键盘目标 frame
    func keyboardWillHide(_ targetFrame: CGRect)
}

public extension KeyboardNotifiable {
    func keyboardWillShow(_ targetFrame: CGRect) { }
    func keyboardWillHide(_ targetFrame: CGRect) { }
}

private var __keyboardNotificationTargetKey = "KeyboardNotifiable.__keyboardNotificationTargetKey"

public extension KeyboardNotifiable where Self: UIResponder {
    
    private var __keyboardNotificationTarget: KeyboardTarget? {
        get {
            objc_getAssociatedObject(self, &__keyboardNotificationTargetKey) as? KeyboardTarget
        }
        set {
            objc_setAssociatedObject(self, &__keyboardNotificationTargetKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func activatingKeyboardNotifiable() {
        // active keyboard will change frame notification
        let _ = KeyboardManager.shared
        
        // listen
        self.__keyboardNotificationTarget = KeyboardTarget.observer(self) { [weak self] (x) in
            self?.keyboardWillChangeFrame(x)
        }
    }
    
    private func keyboardWillChangeFrame(_ notify: Notification) {
        print("keyboard will change frame")
    }
    
}

