//
//  ResetPasswordView.swift
//  ExpertConnect
//
//  Created by Redbytes on 23/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol ResetPasswordDelegate {
    func resetPasswordSucceded(showAlert:Bool, message: String) -> Void
}

class ResetPasswordView: UIViewController,  UITextFieldDelegate {
    var delegate:ResetPasswordDelegate!
    var userId = String()
    var currentPassword = String()
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var resetPasswordButon: UIButton!
    @IBOutlet weak var baseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.activateBackIcon()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = "PasswordReset".localized(in: "SettingsView")
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.setExpertConnectRedButtonTheme(button: self.resetPasswordButon)
        self.setExpertConnectTextFieldTheme(textfield: self.confirmPasswordTextField)
        self.setExpertConnectTextFieldTheme(textfield: self.newPasswordTextField)
        self.setExpertConnectTextFieldTheme(textfield: self.currentPasswordTextField)
        self.confirmPasswordTextField.setLeftPaddingPoints(10)
        self.newPasswordTextField.setLeftPaddingPoints(10)
        self.currentPasswordTextField.setLeftPaddingPoints(10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scrollview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let size = CGSize(width: self.view.frame.width, height: 100)
        self.scrollview.contentSize = size
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.setExpertConnectShadowTheme(view: baseView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPasswordButtonClicked(_ sender: Any) {
        self.currentPassword = UserDefaults.standard.value(forKey: "CurrentPassword") as! String
        self.view.endEditing(true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ResetPasswordView")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.currentPasswordTextField.text == nil || (self.currentPasswordTextField.text?.characters.count)! == 0){
            let message = "Current password can't be blank".localized(in: "ResetPasswordView")
            self.displayErrorMessage(message: message)
            return
        } else if(self.currentPasswordTextField.text != self.currentPassword) {
            let message = "Current password is invalid".localized(in: "ResetPasswordView")
            self.displayErrorMessage(message: message)
            return
        }
        
        if (self.newPasswordTextField.text == nil || (self.newPasswordTextField.text?.characters.count)! == 0){
            let message = "New password can't be blank".localized(in: "ResetPasswordView")
            self.displayErrorMessage(message: message)
            return
        }
        
        if(!self.userPasswordValidation(string: self.newPasswordTextField.text!)) {
            let message = "Please Enter New Password With Minimum 6 Characters".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        
        if (self.confirmPasswordTextField.text == nil || (self.confirmPasswordTextField.text?.characters.count)! == 0) {
            let message = "Confirm new password can't be blank".localized(in: "ResetPasswordView")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.confirmPasswordTextField.text != self.newPasswordTextField.text) {
            let message = "Password confirmation does't match Password".localized(in: "ResetPasswordView")
            self.displayErrorMessage(message: message)
            return
        }
        
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        let message = "Updating password".localized(in: "ResetPasswordView")
        self.displayProgress(message: message)
        let resetPasswordInputDomainModel = ResetPasswordInputDomainModel.init(userId: self.userId, newPassword: self.newPasswordTextField.text!)
        let APIDataManager : ResetPasswordProtocol = ResetPasswordApiDataManager()
        APIDataManager.resetPassword(data: resetPasswordInputDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onResetPasswordFailed(error: error)
                break
                
            case .Success(let data as OTPOutputDomainModel):
                self.onResetPasswordSucceed(data: data)
                break
                
            default:
                break
            }
        })
    }
    
    func userPasswordValidation(string: String) -> Bool {
        if string.characters.count >= 6 {
            return true
        }
        return false
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
    
    func onResetPasswordSucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            self.delegate.resetPasswordSucceded(showAlert: true, message: "Your password updated successfully".localized(in: "ResetPasswordView"))
            let currentPassword = self.confirmPasswordTextField.text
            UserDefaults.standard.set(currentPassword, forKey: "CurrentPassword")
            
            self.view.endEditing(true)
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onResetPasswordFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to update password")
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    //MARK: TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.currentPasswordTextField { // Switch focus to other text field
            self.newPasswordTextField.becomeFirstResponder()
        }
        if textField == self.newPasswordTextField { // Switch focus to other text field
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
