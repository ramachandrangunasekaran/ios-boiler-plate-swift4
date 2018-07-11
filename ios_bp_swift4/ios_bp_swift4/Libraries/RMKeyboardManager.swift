//
//  RMKeyboardManager.swift
//  ios_bp_swift4
//
//  Created by R@M on 11/07/18.
//  Copyright © 2018 2Fit. All rights reserved.
//

import Foundation
import UIKit

class KeyboardAccessoryToolbar: UIToolbar {
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.barStyle = .default
        self.isTranslucent = false
        self.tintColor = UIColor.init(rgb: 0x000000)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.items = [spaceButton, doneButton]
        
        self.isUserInteractionEnabled = true
        self.sizeToFit()
    }
    
    
    @objc func done() {
        // Tell the current first responder (the current text input) to resign.
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


class RMKeyboardManager {
    
    static let shared = RMKeyboardManager()
    
    var enable:Bool {
        didSet {
            if enable == true {
                NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                
                NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                
                NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
                
            }else{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
            }
        }
        
    }
    
    
    init() {
        self.enable = false
        let accessoryView = KeyboardAccessoryToolbar()
        UITextField.appearance().inputAccessoryView = accessoryView
        UITextView.appearance().inputAccessoryView = accessoryView
    }
    
    @objc func KeyBoardChanged(notification: Notification){
        
        guard let keyBoardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        switch notification.name {
            
        case Notification.Name.UIKeyboardWillShow:
            UIApplication.shared.keyWindow?.frame.origin.y = -(keyBoardRect.height - 50)
            break
        case Notification.Name.UIKeyboardWillChangeFrame:
            UIApplication.shared.keyWindow?.frame.origin.y = -keyBoardRect.height
            break
        case Notification.Name.UIKeyboardWillHide:
            UIApplication.shared.keyWindow?.frame.origin.y = 0
            break
        default:
            UIApplication.shared.keyWindow?.frame.origin.y = 0
            return
        }
        
    }
    
    
}
