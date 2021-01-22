//
//  Created by iWw on 2021/1/22.
//

import UIKit
import WeakObserver

public class Control: NSObject {
    
    public typealias KeyboardChangeCallback = (_ keyboardFrame: CGRect, _ isShowing: Bool) -> Void
    
    // MARK:- Public properties
    
    /// transition for the frame change, default is true
    /// 视图的 frame 变化时，重新调整位置是否需要动画过渡
    public private(set) var transitionFrameChange: Bool = true
    
    /// aniamte duration of transition, default is 0.24
    /// 视图的 frame 变化时，重新调整位置的动画持续时间
    public private(set) var transitionAnimateDuration: TimeInterval = 0.24
    
    /// animate options of transition, default is [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut]
    /// 视图的 frame 变化时，动画的选项
    public private(set) var transitionAnimateOptions: UIView.AnimationOptions = [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut]
    
    /// 键盘显示/隐藏
    public var isKeyboardShowing: Bool {
        self.keyboardBounds != .zero && self.keyboardBounds.origin.y < getRsdHeight()
    }
    
    /// bounds of keyboard
    /// 键盘的 bounds
    public private(set) var keyboardBounds: CGRect = .zero
    
    /// 是否吸附到键盘上，为false 时，键盘弹起不再调整视图的 frame
    public var isShouldAdsorption = true
    
    /// 键盘出现/消失时的回执
    public func keyboardChange(_ callback: KeyboardChangeCallback?) {
        self.keyboardChangeCallback = callback
    }
    
    // internal handler
    var keyboardChangeCallback: KeyboardChangeCallback?
    
    weak var value: UIView?
    let handler = KVOHandler()
    
    var observer: NotificationWeakObserver?
    var deallocAttachment: DeallocAttachment?
    var valueResponderBounds: CGRect = .zero
    var bottom: CGFloat
    
    required init(value: UIView?, bottom: CGFloat, transition: Bool, duration: TimeInterval, options: UIView.AnimationOptions) {
        self.bottom = bottom
        super.init()
        self.value = value
        self.transitionFrameChange = transition
        self.transitionAnimateDuration = duration
        self.transitionAnimateOptions = options
        
        self.listen()
    }
    
    func listen() {
        guard let value = value else { return }
        
        // listen keybaord observer
        self.observer = NotificationWeakObserver(value, name: UIResponder.keyboardWillChangeFrameNotification) { [weak self] (notify) in
            guard value.superview != nil, value.window != nil, let self = self, self.isShouldAdsorption else { return }
            self.__keyboardWillChangeFrame(notify)
        }
        handler.frameChange = { [weak self] _ in
            guard let self = self else { return }
            if self.transitionFrameChange {
                UIView.animate(withDuration: self.transitionAnimateDuration, delay: 0, options: self.transitionAnimateOptions, animations: {
                    self.layoutValue()
                }, completion: nil)
            } else {
                self.layoutValue()
            }
        }
        value.addObserver(handler, forKeyPath: "frame", options: [.new], context: nil)
        
        // remove observer when the self dealloc
        self.deallocAttachment = DeallocAttachment(observer: self) { [weak self] in
            guard let self = self else { return }
            self.value?.removeObserver(self.handler, forKeyPath: "frame")
        }
    }
    
    func getRsdHeight() -> CGFloat {
        guard let value = value else { return UIScreen.main.bounds.height }
        var rsdBounds: CGRect = .zero
        var rsd: UIResponder? = value.next
        while !(rsd is UIViewController) && rsd != nil {
            rsd = rsd?.next
        }
        rsdBounds = (rsd == nil ? value.window?.frame : (rsd as? UIViewController)?.view.frame) ?? UIScreen.main.bounds
        return rsdBounds.height
    }
    
    private func layoutValue() {
        guard let value = value else { return }
        value.transform = .identity
        
        let rsdHeight = getRsdHeight()
        
        if isKeyboardShowing {
            let maxY = rsdHeight - self.keyboardBounds.height
            if maxY == value.frame.maxY {
                return
            }
            let diff = maxY - value.frame.maxY
            value.transform = .init(translationX: 0, y: diff)
        } else {
            value.transform = .identity
            
            guard bottom > -1 else { return }
            value.frame.origin.y = rsdHeight - value.frame.size.height - max(0, bottom)
        }
    }
    
    func __keyboardWillChangeFrame(_ notify: Notification) {
        guard let userInfo = notify.userInfo else { return }
        
        guard let keyboardBounds = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        self.keyboardBounds = keyboardBounds
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            self.layoutValue()
            self.keyboardChangeCallback?(keyboardBounds, self.isKeyboardShowing)
        }, completion: nil)
    }
}
