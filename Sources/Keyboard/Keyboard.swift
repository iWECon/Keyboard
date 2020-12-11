import UIKit

public class KeyboardManager: NSObject {
    
    public static let shared = KeyboardManager()
    
    private override init() {
        super.init()
        
        // listen keyboard will change frame notify
    }
    
}


public class KeyboardTarget: NSObject {
    
    public var target: AnyObject?
    public var using: ((_: Notification) -> Void)?
    
    @objc public func doObserver(x: Notification) {
        self.using?(x)
    }
    
    deinit {
        print("the keyboard target released.")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    public class func observer(_ observer: AnyObject, object: Any? = nil, using: ((_: Notification) -> Void)?) -> KeyboardTarget {
        
        let target = KeyboardTarget()
        target.target = observer
        target.using = using
        
        NotificationCenter.default.addObserver(target, selector: #selector(doObserver(x:)), name: UIResponder.keyboardWillChangeFrameNotification, object: object)
        
        return target
    }
}
