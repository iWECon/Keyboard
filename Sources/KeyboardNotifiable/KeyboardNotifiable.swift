//
//  File.swift
//  
//
//  Created by iWw on 2020/12/10.
//

import UIKit

public protocol KeyboardNotifiable {
    
    /// Whether to respond to events when the keyboard pops up or disappears
    ///
    /// Default is true, when you set it to `false`,
    /// it will no longer trigger events such as `keyboardWillChange` / `keyboardDidChange`
    var isRespondToKeyboard: Bool { get set }
    
    var keyboardFrame: CGRect { get set }
    
    /// Indicates whether the keyboard displays
    var isKeyboardShowing: Bool { get }
    
    /// Activate keyboard pop-up and disappearance listeners
    /// It is usually placed in `viewDidLoad` or `init`
    func activatingKeyboardNotifiable()
    
    /// Agents that pop up or disappear from the keyboard
    /// Included in the animation block
    func keyboardWillChangeFrameWithAnimation(_ isVisiable: Bool, _ targetFrame: CGRect)
    
    // Triggered at the end of the animation where the keyboard appears or disappears
    // without animation
    func keyboardDidChangeFrame(_ isVisiable: Bool, _ targetFrame: CGRect)
    
    // The following separate methods are split up and included in the animation block
    func keyboardWillShow(_ targetFrame: CGRect)
    func keyboardWillHide(_ targetFrame: CGRect)
    
    // Triggered at the end of the animation where the keyboard appears or disappears
    func keyboardDidShow(_ targetedFrame: CGRect)
    func keyboardDidHidden(_ targetedFrame: CGRect)
}

public extension KeyboardNotifiable {
    func keyboardWillChangeFrameWithAnimation(_ isVisiable: Bool, _ targetFrame: CGRect) { }
    func keyboardWillShow(_ targetFrame: CGRect) { }
    func keyboardWillHide(_ targetFrame: CGRect) { }
    
    func keyboardDidChangeFrame(_ isVisiable: Bool, _ targetFrame: CGRect) { }
    func keyboardDidShow(_ targetedFrame: CGRect) { }
    func keyboardDidHidden(_ targetedFrame: CGRect) { }
}
