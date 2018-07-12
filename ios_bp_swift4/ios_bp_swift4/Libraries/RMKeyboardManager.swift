//
//  TFKeyBoardToolBar.swift
//  TwoFit
//
//  Created by R@M on 10/07/18.
//  Copyright © 2018 2Fit. All rights reserved.
//

import Foundation
import UIKit

class KeyboardAccessoryToolbar: UIToolbar {
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.barStyle = .default
        self.isTranslucent = false
        self.tintColor = UIColor.init(rgb: 0x04202C)
        
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
    
    var enable: Bool {
        didSet {
            if enable == true {
                NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                
                NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                
                NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardChanged(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
                
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldViewChange(notification:)), name: Notification.Name.UITextFieldTextDidBeginEditing, object: nil)
                
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldViewChange(notification:)),  name: Notification.Name.UITextViewTextDidBeginEditing, object: nil)
                
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldViewChange(notification:)), name: Notification.Name.UITextFieldTextDidEndEditing, object: nil)
                
                NotificationCenter.default.addObserver(self, selector: #selector(textFieldViewChange(notification:)),  name: Notification.Name.UITextViewTextDidEndEditing, object: nil)
                
            }else{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
                
                NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextFieldTextDidBeginEditing, object: nil)
                
                NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextViewTextDidBeginEditing, object: nil)
                
                NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextFieldTextDidEndEditing, object: nil)
                
                NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextViewTextDidEndEditing, object: nil)
                
            }
        }
        
    }
    
    var _textFieldView:UIView? = nil
    var _viewFrame:CGRect? = nil
    
    init() {
        self.enable = false
        let accessoryView = KeyboardAccessoryToolbar()
        UITextField.appearance().inputAccessoryView = accessoryView
        UITextView.appearance().inputAccessoryView = accessoryView
    }
    
    @objc func textFieldViewChange(notification: Notification){
        _textFieldView = notification.object as? UIView
        //        _rootViewController = _textFieldView?.parentViewController
        if let viewFrame = _textFieldView?.convert((_textFieldView?.frame)!, to: nil) {
            _viewFrame = viewFrame
        }
    }

    @objc func KeyBoardChanged(notification: Notification) {
        
        guard let keyBoardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        var move = CGFloat.init((keyBoardRect.height))
        if(_viewFrame != nil) {
            if (_viewFrame?.origin.y)! > keyBoardRect.height {
                move = abs((abs((_viewFrame?.origin.y)! - keyBoardRect.height)))
                if move > keyBoardRect.height {
                    move = keyBoardRect.height
                }
            } else {
                if((_viewFrame?.origin.y)! * 2 < keyBoardRect.height) {
                    move = 0
                } else {
                    move = (_viewFrame?.origin.y)!
                }
            }
        }
        switch notification.name {
        case Notification.Name.UIKeyboardWillShow:
            UIApplication.shared.keyWindow?.frame.origin.y = -move
            break
        case Notification.Name.UIKeyboardWillChangeFrame:
            UIApplication.shared.keyWindow?.frame.origin.y = -move
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
