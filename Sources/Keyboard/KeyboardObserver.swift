//
//  File.swift
//  
//
//  Created by iWw on 2020/12/11.
//

import UIKit

public class KeyboardObserver: NSObject {
    
    weak var target: AnyObject?
    var using: ((_: Notification) -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func doObserver(x: Notification) {
        self.using?(x)
    }
    
    public class func observer(_ observer: AnyObject, object: Any? = nil, using: ((_: Notification) -> Void)?) -> KeyboardObserver {
        
        let target = KeyboardObserver()
        target.target = observer
        target.using = using
        
        NotificationCenter.default.addObserver(target, selector: #selector(doObserver(x:)), name: UIResponder.keyboardWillChangeFrameNotification, object: object)
        
        return target
    }
}
