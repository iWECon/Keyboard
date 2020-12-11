//
//  File.swift
//  
//
//  Created by iWw on 2020/12/10.
//

import UIKit

public protocol KeyboardNotifiable {
    
    /// 键盘 frame
    var keyboardFrame: CGRect { get set }
    
    /// 键盘是否正在显示
    var isKeyboardShowing: Bool { get }
    
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
    func keyboardWillChangeFrameWithAnimation(_ isVisiable: Bool, _ targetFrame: CGRect) { }
    func keyboardWillShow(_ targetFrame: CGRect) { }
    func keyboardWillHide(_ targetFrame: CGRect) { }
}
