# Keyboard

A simple Keybaord helper tools.


## KeyboardObserver

A weak observer for `UIResponder.keyboardWillChangeFrame`.

It's auto release the observer(means you don't have to manually call `NotificationCenter.default.removeObserver()`).

You can use KeyboardObserver to listen keyboard will change frame's notification.

```swift

// No call required `NotificationCenter.default.removeObserver(self)`
// when the self deinit, then the observer auto remove.
KeyboardObserver.observer(self, using: { (notify) in
    // get info from notify
    guard let userInfo = notify.userInfo else { return }
    
    // anlysis keyboard frame info and to do something
    // code
})
```


## KeyboardNotifiable

A simple Tools(Protocol) for UIResponder.

eg:
```swift

// 
class RenameController: UIViewController, KeyboardNotifiable {

    // ... any code
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // active KeyboardNotifiable
        activatingKeyboardNotifiable()
    }
    
    // implement required protocol
    // Choose one of two
    func keyboardWillChangeFrameWithAnimation(_ isVisiable: Bool, _ targetFrame: CGRect) { 
        if isVisiable {
            // code for keyboard will show
        } else {
            // code for keyboard will hide
        }
    }
    
    // or split funcs
    func keyboardWillShow(_ targetFrame: CGRect) { 
        // code for keyboard will show
    }
    func keyboardWillHide(_ targetFrame: CGRect) { 
        // code for keybaord will hide
    }
}
```

## Install

#### Swift Package Manager

```swift
.package("https://github.com/iWECon/Keyboard", from: "2.0.0")
```
