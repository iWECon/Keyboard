//
//  ViewController.swift
//  KeyboardResponder
//
//  Created by iWw on 2021/1/22.
//

import UIKit

class ViewController: UIViewController {
    
    var inputFiled = UITextView()
    @KeyboardResponder
    var containerView = UIView()
    
    let button = UIButton()
    let dismiss = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        view.backgroundColor = .white
        
        button.setTitle("Present", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(presentViewController), for: .touchUpInside)
        view.addSubview(button)
        
        dismiss.setTitle("Dismiss", for: .normal)
        dismiss.backgroundColor = .green
        dismiss.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        view.addSubview(dismiss)
        
        inputFiled.backgroundColor = .clear
        containerView.backgroundColor = .red
        containerView.addSubview(inputFiled)
        view.addSubview(containerView)
        
        
        let mainBounds = UIScreen.main.bounds
        containerView.frame = .init(x: 0, y: mainBounds.height - 44 - 34, width: mainBounds.width, height: 44)
        inputFiled.frame = .init(x: 0, y: 0, width: containerView.frame.width, height: 44)
        
        dismiss.frame = .init(x: 30, y: 200, width: 120, height: 44)
        button.frame = .init(x: 30, y: 244, width: 120, height: 44)
        
        _containerView.control.keyboardChange { (frame) in
            print("keyboard frame: ", frame)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(refreshFrame))
        view.addGestureRecognizer(tap)
    }
    
    @objc func refreshFrame() {
        containerView.frame.size.height += 30
    }
    
    @objc func presentViewController() {
        present(ViewController(), animated: true, completion: nil)
    }
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

}

