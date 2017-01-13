//
//  UIViewController+AlertController.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 20/10/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    /**
     This method show an iOS styled Alert View for successful actions
     - parameters:
     - message: The message to be displayed in the alert view
     */
    func showSuccessMessage(message: String) {
        
        let title = NSLocalizedString("Success", comment : "Success")
        let action = NSLocalizedString("Ok", comment : "Ok")
        
        // Warn the user
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertMessage.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    /**
     This method show an iOS styled Alert View for successful actions with action handler
     - parameters:
     - message: The message to be displayed in the alert view
     - callback: The function to be called by the handler
     */
    func showSuccessMessage(message: String, callback: @escaping () -> Void) {
        
        let title = NSLocalizedString("Success", comment : "Success")
        let action = NSLocalizedString("Ok", comment : "Ok")
        
        // Warn the user
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: action, style: .default) { (action) in
            DispatchQueue.main.async {
                // Call callback
                callback()
            }
        }
        
        alertMessage.addAction(confirmAction)
        
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    func showErrorMessage(message: String, callback: @escaping () -> Void) {
        
        let title = NSLocalizedString("Error", comment : "Error")
        let action = NSLocalizedString("Ok", comment : "Ok")
        
        // Warn the user
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: action, style: .default) { (action) in
            DispatchQueue.main.async {
                // Call callback
                callback()
            }
        }
        
        alertMessage.addAction(confirmAction)
        
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    func showStylishSuccessMessage(message: String) {
        let progressHUD: MBProgressHUD? = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD!.label.text = message
        progressHUD!.label.tintColor = UIColor.white
        progressHUD!.bezelView.color = UIColor.mezukaSuccessGreen
        progressHUD!.mode = .text
        progressHUD?.hide(animated: true, afterDelay: 2.0)
    }
    
    /**
     This method show an iOS styled Alert View for failed actions
     - parameters:
     - message: The message to be displayed in the alert view
     */
    func showErrorMessage(message: String) {
        let title = NSLocalizedString("Error", comment : "Error")
        let action = NSLocalizedString("Ok", comment : "Ok")
        
        // Warn the user
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertMessage.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    func showStylishErrorMessage(message: String) {
        let progressHUD: MBProgressHUD? = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD!.label.text = message
        progressHUD!.label.tintColor = UIColor.white
        progressHUD!.bezelView.color = UIColor.mezukaErrorRed
        progressHUD!.mode = .text
        progressHUD?.hide(animated: true, afterDelay: 2.0)
    }
    
    func displayProgress(message: String) {
        let progressHUD: MBProgressHUD? = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD!.label.text = message
    }
    
    func dismissProgress() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func setExpertConnectRedButtonTheme(button:UIButton) {
        button.layer.cornerRadius=3
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.ExpertConnectRed.cgColor
        button.layer.borderWidth = 1.0;
        button.backgroundColor = UIColor.ExpertConnectRed

        button.setTitleColor(UIColor.white, for:.normal);
        button.isEnabled = true

    }
    
    func setExpertConnectGrayButtonTheme(button:UIButton) {
        button.layer.cornerRadius=3
        button.layer.masksToBounds = true;
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = UIColor.gray
        button.setTitleColor(UIColor.white, for:.normal);
        button.isEnabled = false
    }
    
    func setExpertConnectWhiteButtonTheme(button:UIButton) {
        button.layer.cornerRadius=3;
        button.layer.masksToBounds = true;
        button.layer.borderColor = UIColor.ExpertConnectRed.cgColor
        button.layer.borderWidth = 1.0;
        button.setTitleColor(UIColor.ExpertConnectRed, for:.normal);
        button.backgroundColor=UIColor.clear
    }
    
    func setExpertConnectTextFieldTheme(textfield:UITextField) {
        textfield.layer.cornerRadius=3;
        textfield.layer.masksToBounds = true;
        textfield.layer.borderColor = UIColor.ExpertConnectBlack.cgColor
        textfield.layer.borderWidth = 1.0;
        textfield.backgroundColor=UIColor.clear
    }
    
    func setCustomAlertTextFieldTheme(textfield:UITextField) {
        textfield.layer.cornerRadius=3;
        textfield.layer.masksToBounds = true;
        textfield.layer.borderColor = UIColor.ExpertConnectRed.cgColor
        textfield.layer.borderWidth = 1.0;
        textfield.backgroundColor=UIColor.clear
    }
    
    func setExpertConnectShadowTheme(view: AnyObject) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 0.3
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 3).cgPath
        view.layer.cornerRadius = 3
    }
   
    func setECTableViewCellShadowTheme(view: AnyObject) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 0.3
        view.layer.cornerRadius = 3
    }

    func setExpertConnectSeacrhBarTheme(searchBar: UISearchBar) {
        var textField : UITextField
        for subview in searchBar.subviews {
            if (subview.isKind(of:UIView.self)) {
                for subviewOfSubview in subview.subviews {
                    if (subviewOfSubview.isKind(of:UITextField.self)) {
                        textField = subviewOfSubview as! UITextField
                        textField.borderStyle = .none
                        textField.layer.borderWidth = 0.2
                        textField.layer.borderColor = UIColor.lightGray.cgColor
                        textField.background = nil;
                        textField.backgroundColor = UIColor.white
                        textField.layer.shadowColor = UIColor.black.cgColor
                        textField.layer.shadowOffset = CGSize(width: 0, height: 1.0)
                        textField.layer.shadowOpacity = 0.4
                        textField.layer.shadowRadius = 0.3
                        textField.layer.cornerRadius = 3
                        textField.font = UIFont(name: "Raleway-Light", size: 17)
                        textField.textColor = UIColor.ExpertConnectBlack

//                        let image:UIImage = UIImage(named: "search_icon")!
//                        let imageView:UIImageView = UIImageView.init(image: image)
//                        textField.placeholder = "Search"
//                        textField.rightView = nil
//                        textField.leftView = imageView
//                        textField.leftViewMode = UITextFieldViewMode.always

                        if let glassIconView = textField.leftView as? UIImageView {
                            glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                            glassIconView.tintColor = UIColor.ExpertConnectRed
                        }
                    }
                }
            }
        }
    }
}
