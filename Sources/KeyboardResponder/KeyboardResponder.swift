//
//  Created by iWw on 2021/1/22.
//

import UIKit

@propertyWrapper
public struct KeyboardResponder<T: UIView> {
    
    var value: T
    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    // MARK:- Only read properties
    public private(set) var keyboardBounds: CGRect = .zero
    public var projectedValue: KeyboardResponder<T> { self }
    public let control: Control
    
    public init(wrappedValue: T, bottom: CGFloat = -1,
                transition transitionWhenChange: Bool = true, duration: TimeInterval = 0.24,
                options: UIView.AnimationOptions = [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut]) {
        self.value = wrappedValue
        self.control = Control(value: wrappedValue, bottom: bottom, transition: transitionWhenChange, duration: duration, options: options)
    }
    
}
