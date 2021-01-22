//
//  Created by iWw on 2021/1/22.
//

import UIKit

class KVOHandler: NSObject {
    
    var previousFrame: CGRect?
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "frame", previousFrame != nil, previousFrame != .zero,
              let newFrame = change?[.newKey] as? CGRect, previousFrame != newFrame
        else {
            // init frame
            self.previousFrame = change?[.newKey] as? CGRect
            return
        }
        self.previousFrame = newFrame
        frameChange?(newFrame)
    }
    
    var frameChange: ((_: CGRect) -> Void)?
}
