//
//  DeleteAccountView.swift
//  ExpertConnect
//
//  Created by Redbytes on 31/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
protocol DeleteAccountDelegate {
    func deleteAccountSucceded(showAlert:Bool, message: String) -> Void
}

class DeleteAccountView: UIViewController {
    var delegate:LoginVC = LoginVC()
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var deleteAccountView: UIView!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var deleteInfoTextView: UITextView!
    @IBOutlet var scrollview: UIScrollView!
    var userId: String = ""
    var currentPassword: String = ""
    var userType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = "DeleteAccount".localized(in: "SettingsView")
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.setExpertConnectRedButtonTheme(button: self.deleteAccountButton)
        self.setExpertConnectTextFieldTheme(textfield: self.passwordTextField)
        self.passwordTextField.setLeftPaddingPoints(10)
        self.deleteAccountButton.backgroundColor = UIColor.red
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.setExpertConnectShadowTheme(view: deleteAccountView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteAccountButtonClicked(_ sender: Any) {
        self.currentPassword = UserDefaults.standard.value(forKey: "CurrentPassword") as! String
        self.view.endEditing(true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ResetPasswordView")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.passwordTextField.text == nil || (self.passwordTextField.text?.characters.count)! == 0){
            let message = "Current password can't be blank".localized(in: "ResetPasswordView")
            self.displayErrorMessage(message: message)
            return
        } else if(self.passwordTextField.text != self.currentPassword) {
            let message = "Current password is invalid".localized(in: "ResetPasswordView")
            self.displayErrorMessage(message: message)
            return
        }
        self.askForDeleteAccountIfUserIsSure()
    }
    
    func askForDeleteAccountIfUserIsSure() {
        let message = "Are you sure?".localized(in: "DeleteAccountView")
        let cancel = "Cancel".localized(in: "DeleteAccountView")
        let delete = "Delete".localized(in: "DeleteAccountView")
        let deleteAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        deleteAlert.addAction(UIAlertAction(title: cancel, style: .default, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: delete, style: .default, handler: { (action: UIAlertAction!) in
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
            let message = "Deleting your account".localized(in: "DeleteAccountView")
            self.displayProgress(message: message)
            let deleteAccountViewInputDomainModel = DeleteAccountViewInputDomainModel.init(userId: self.userId, userType: self.userType)
            let APIDataManager : DeleteAccountViewProtocol = DeleteAccountViewApiDataManager()
            APIDataManager.deleteAccount(data: deleteAccountViewInputDomainModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onDeleteAccountFailed(error: error)
                    break
                    
                case .Success(let data as OTPOutputDomainModel):
                    self.onDeleteAccountSucceed(data: data)
                    break
                    
                default:
                    break
                }
            })
        }))
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
    
    func onDeleteAccountSucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            UserDefaults.standard.set(true, forKey: "isAccountDeleted")
            UserDefaults.standard.set(false, forKey: "UserLoggedInStatus")
            self.navigationController!.popToRootViewController(animated: false)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onDeleteAccountFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to delete account")
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    //MARK: TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
