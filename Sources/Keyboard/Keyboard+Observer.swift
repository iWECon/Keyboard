//
//  File.swift
//  
//
//  Created by iWw on 2020/12/11.
//

import UIKit

public extension Keyboard {
    
    class Observer: NSObject {
        
        weak var target: AnyObject?
        var using: ((_: Notification) -> Void)?
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        
        @objc func doObserver(x: Notification) {
            self.using?(x)
        }
        
        required public init(_ observer: AnyObject, object: Any? = nil, using: ((_: Notification) -> Void)?) {
            super.init()
            self.target = observer
            self.using = using
            
            NotificationCenter.default.addObserver(self, selector: #selector(doObserver(x:)), name: UIResponder.keyboardWillChangeFrameNotification, object: object)
        }
    }
}
