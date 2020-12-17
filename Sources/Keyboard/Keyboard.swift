//
//  File.swift
//  
//
//  Created by iWw on 2020/12/11.
//

import UIKit
import WeakObserver

// shared instance

public class Keyboard {
    
    public static let WillChangeFrameNotification = Notification.Name("Keyboard.Keyboard.WillChangeFrameNotification")
    
    private var observer: NotificationWeakObserver?
    
    private init() {
        self.observer = NotificationWeakObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil) { (notify) in
            NotificationCenter.default.post(name: Keyboard.WillChangeFrameNotification,
                                            object: notify.object,
                                            userInfo: notify.userInfo)
        }
    }
    
    public static let shared = Keyboard()
}
