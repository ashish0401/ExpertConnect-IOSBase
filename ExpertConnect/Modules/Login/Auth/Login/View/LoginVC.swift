//
//  LoginVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 08/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

final class LoginVC: UIViewController, CustomIOS7AlertViewDelegate, LoginViewProtocol, UITextFieldDelegate {
    var presenter: LoginPresenterProtocol?
    var objAppDelegate = AppDelegate()
    let alertView = CustomIOS7AlertView()
    var alertActionType = String()
    var OTPTextfield = UITextField()
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    var facebookOutputDomainModel: FacebookOutputDomainModel = FacebookOutputDomainModel()

    /**
     This member shows this field is required or not
     */
    var isRequired = false
    let buttons: [String] = ["AS A STUDENT","AS A TEACHER"]
    let buttonsForForgotPassword = ["SEND EMAIL"]
    
    var userDataDictFB : [String : AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_1")
        self.view.insertSubview(backgroundImage, at: 0)
        self.hideKeyboardWhenTappedAround()
        self.emailTextfield.delegate = self
        //self.emailTextfield.text = "Genius@gmail.com"
       // self.passwordTextfield.text = "123456"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setExpertConnectRedButtonTheme(button: self.loginButton)
        self.setExpertConnectWhiteButtonTheme(button: self.signUpButton)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Actions
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "Login")
            self.displayErrorMessage(message: message)
            return
        }
        if(!self.isValid()) {
            let message = "Please Enter Valid Email".localized(in: "Login")
            self.displayErrorMessage(message: message)
            return
        }
        if(!self.userPasswordValidation(string: self.passwordTextfield.text!)) {
            let message = "Please Enter Password".localized(in: "Login")
            self.displayErrorMessage(message: message)
            return
        }
        presenter?.notifyLoginButtonTapped()
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        self.setupSignupOptionView()
        UserDefaults.standard.set(false, forKey: "UserSignupFromFB")
    }
    
    func setupSignupOptionView() {
        self.emailTextfield.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()
        // Create a new AlertView instance
        alertActionType = "signupAction"
        // Set the button titles array
        alertView.buttonTitles = buttons
        // Set a custom container view
        alertView.containerView = createContainerView()
        // Set self as the delegate
        alertView.delegate = self
        // Or, use a closure
//        alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
//            print("CLOSURE: Button '\(self.buttons[buttonIndex])' touched")
//        }
        // Show time!
        alertView.catchString(withString: "2")
        alertView.show()
    }
    
    @IBAction func forgotPasswordButtonClicked(_ sender: UIButton) {
        self.emailTextfield.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()

        //        self.view.endEditing(true)
        alertActionType = "forgotPasswordAction"
        alertView.buttonTitles = buttonsForForgotPassword
        // Set a custom container view
        alertView.containerView = createContainerViewForForgotPassword()
        // Set self as the delegate
        alertView.delegate = self
        // Or, use a closure
//        alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
//            print("CLOSURE: Button '\(self.buttons[buttonIndex])' touched")
//        }
        
        // Show time!
        alertView.catchString(withString: "3")
        alertView.show()
    }
    
    // MARK: Facebook Login
    @IBAction func facebookButtonClicked(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "UserSignupFromFB")
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "Login")
            self.displayErrorMessage(message: message)
            return
        }
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.userDataDictFB = result as! [String : AnyObject]
                    print(self.userDataDictFB)
                    let apiConverter = LoginApiModelConverter()
                    self.facebookOutputDomainModel = apiConverter.fromJsonOfFacebook(json: self.userDataDictFB) as FacebookOutputDomainModel
                    self.presenter?.notifyFacebookLoginButtonTapped()
                }
            })
        }
    }
    
    func showHomeController() -> Void {
        NSLog("%@", "hi")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController()
    }
    
    // MARK: Custom Alert Delegates
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
      //  print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        if alertActionType == "signupAction"  {
            
            let signupView : SignUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as UIViewController as! SignUpVC
            if (buttonIndex==1)
            {
                //
                let str = NSString(format:"%@", "3")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "teacherStudentValue")
                alertView.close()

            } else if(buttonIndex == 0) {
                //
                let str = NSString(format:"%@", "2")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "teacherStudentValue")
                alertView.close()
            }

            if(UserDefaults.standard.bool(forKey: "UserSignupFromFB"))
            {
                signupView.facebookOutputDomainModel = self.facebookOutputDomainModel
            }
            self.navigationController!.pushViewController(signupView, animated: true)

        } else if alertActionType == "forgotPasswordAction" {
            
            if (self.OTPTextfield.text == nil || (self.OTPTextfield.text?.characters.count)! == 0){
                let message = "Please Enter Valid Email".localized(in: "Login")
                alertView.close()
                self.displayErrorMessageWithCallback(message: message)
                return
            }

            presenter?.notifyForgotPasswordButtonTapped()
            print("send email code")
            alertView.close()
        }
    }
    
    func createContainerView() -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 20))
        let label = UILabel(frame: CGRect(x: 0, y: 30, width: 290, height: 20))
        label.text = "SIGNUP AS"
        label.font =  UIFont(name: "Raleway-Light", size: 18)
        label.textColor = UIColor.ExpertConnectBlack
        label.textAlignment = NSTextAlignment.center
        View.addSubview(label)
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 246, y: 0, width: 44, height: 44)
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        View.addSubview(closeButton)
        return View;
    }
    
    func createContainerViewForForgotPassword() -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 200))
        let label = UILabel(frame: CGRect(x: 20, y: 35, width: 240, height: 50))
        label.text = "Please enter your registered Email"
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center;

        label.font =  UIFont(name: "Raleway-Light", size: 18)
        label.textColor = UIColor.ExpertConnectBlack
        label.textAlignment = NSTextAlignment.center
        View.addSubview(label)
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 246, y: 0, width: 44, height: 44)
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        View.addSubview(closeButton)
        OTPTextfield = UITextField(frame: CGRect(x: 20, y: 95, width: 250.00, height: 40.00))
        OTPTextfield.textAlignment = NSTextAlignment.center;
        OTPTextfield.borderStyle = UITextBorderStyle.roundedRect
        OTPTextfield.keyboardType = UIKeyboardType.emailAddress
        OTPTextfield.backgroundColor = UIColor.white
        OTPTextfield.textColor = UIColor.black
        OTPTextfield.layer.borderColor=UIColor.ExpertConnectRed.cgColor
        OTPTextfield.layer.borderWidth = 1.0;
        OTPTextfield.delegate=self;
        
        self.setCustomAlertTextFieldTheme(textfield: OTPTextfield)
        OTPTextfield.becomeFirstResponder()
        View.addSubview(OTPTextfield)
        return View;
    }
    
    func pressButton(button: UIButton) {
        // Do whatever you need when the button is pressed
        alertView.close()
    }
    
    // MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Display Progress
    override func displayProgress(message: String) {
        super.displayProgress(message: message)
    }
    
    override func dismissProgress() {
        super.dismissProgress()
    }
    
    // MARK: Get LoginView Model
    func getLoginViewModel() -> LoginViewModel {
        let deviceToken = UserDefaults.standard.value(forKey: "com.ExpertConnect.devicetoken") as! String
        return LoginViewModel(
            email: self.emailTextfield.text!,
            password: self.passwordTextfield.text!,
            deviceToken: deviceToken,
            operatingSysType:"iOS"
        )
    }
    
    func getLoginWithFacebookModel() -> LoginWithFacebookModel {
        let deviceToken = UserDefaults.standard.value(forKey: "com.ExpertConnect.devicetoken") as! String
        return LoginWithFacebookModel(
            regType: "2",
            socialId: self.userDataDictFB["id"] as! String,
            deviceToken: deviceToken,
            operatingSysType:"iOS"
        )
    }
    
    // MARK: Display Alert
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displayErrorMessageWithCallback(message: String) {
        self.showErrorMessage(message: message, callback: {
            self.alertView.show()
        })
    }

    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
    
    // MARK: LoginView Delegates
    func navigateBackToViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController()
    }
    
    func navigateToSignup() {
        self.setupSignupOptionView()
    }

    /**
     Validates the given text according to input type which can be Phone, Email or Default, if input text is empty returns valid(true)
     - returns: returns whether it is valid(true) or not(false)
     */
    func isValid() -> Bool {
        if getText().isEmpty { return false }
        let factory = ValidatorFactory()
        let validator = factory.create(type: EInputType.EMAIL)
        return validator.isValid(text: getText())
    }
    
    func userPasswordValidation(string: String) -> Bool {
        if string.characters.count>=6 {
            return true
        }
        return false
    }

    
//    /**
//     Checks the given text is empty or not if it is required
//     - returns: returns whether it is empty(true) or not(false)
//     */
//    func isEmpty() -> Bool {
//        if self.isRequired && self.getText().isEmpty {
//            return true
//        } else {
//            return false
//        }
//    }
    
    /**
     Get text of the MapiaTextField
     - returns: returns text of the MapiaTextField
     */
    func getText() -> String! {
        if let _ = self.emailTextfield.text {
            return self.emailTextfield.text
        } else {
            return ""
        }
    }
    
    func getForgotPasswordModel() -> FPDomainModel {
        let model = FPDomainModel.init(email: self.OTPTextfield.text!)
        return model
    }

}
