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
    
}
