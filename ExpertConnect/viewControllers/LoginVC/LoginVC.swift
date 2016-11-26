//
//  LoginVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 08/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import UIKit

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
    
    /**
     This member shows this field is required or not
     */
    var isRequired = false
    let buttons = ["AS A STUDENT", "AS A TEACHER"]
    let buttonsForForgotPassword = ["SEND EMAIL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_1")
        self.view.insertSubview(backgroundImage, at: 0)
        self.hideKeyboardWhenTappedAround()
        self.emailTextfield.delegate = self
        self.emailTextfield.text = "Email"
        self.passwordTextfield.text = "Password"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loginButton.layer.cornerRadius=3;
        self.loginButton.layer.masksToBounds = true;
        self.loginButton.layer.borderColor = UIColor.ExpertConnectRed.cgColor
        self.loginButton.layer.borderWidth = 1.0;
        
        self.loginButton.setTitleColor(UIColor.ExpertConnectRed, for:.normal);
        self.loginButton.backgroundColor=UIColor.clear
        
        self.signUpButton.layer.cornerRadius=3;
        self.signUpButton.layer.masksToBounds = true;
        self.signUpButton.layer.borderColor = UIColor.ExpertConnectRed.cgColor
        self.signUpButton.layer.borderWidth = 1.0;
        
        self.signUpButton.setTitleColor(UIColor.ExpertConnectRed, for:.normal);
        self.signUpButton.backgroundColor=UIColor.clear
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        presenter?.notifyLoginButtonTapped()
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        // Create a new AlertView instance
        alertActionType = "signupAction"
        // Set the button titles array
        alertView.buttonTitles = buttons
        // Set a custom container view
        alertView.containerView = createContainerView()
        // Set self as the delegate
        alertView.delegate = self
        // Or, use a closure
        alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
            print("CLOSURE: Button '\(self.buttons[buttonIndex])' touched")
        }
        // Show time!
        alertView.catchString(withString: "2")
        alertView.show()
    }
    @IBAction func forgotPasswordButtonClicked(_ sender: UIButton) {
        //        self.view.endEditing(true)
        alertActionType = "forgotPasswordAction"
        alertView.buttonTitles = buttonsForForgotPassword
        // Set a custom container view
        alertView.containerView = createContainerViewForForgotPassword()
        // Set self as the delegate
        alertView.delegate = self
        // Or, use a closure
        alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
            print("CLOSURE: Button '\(self.buttons[buttonIndex])' touched")
        }
        
        // Show time!
        alertView.catchString(withString: "3")
        alertView.show()
    }
    @IBAction func facebookButtonClicked(_ sender: UIButton) {
    }
    
    func showHomeController() -> Void {
        NSLog("%@", "hi")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController()
    }
    // Handle button touches
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        if alertActionType == "signupAction"  {
            if (buttonIndex==1)
            {
                let str = NSString(format:"%@", "1")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "teacherStudentValue")
                alertView.close()

                self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "SignUpVC") as UIViewController, animated: true)
            } else if(buttonIndex == 0) {
                let str = NSString(format:"%@", "0")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "teacherStudentValue")
                alertView.close()
                
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "SignUpVC") as UIViewController, animated: true)
            }
        } else if alertActionType == "forgotPasswordAction" {
            presenter?.notifyForgotPasswordButtonTapped()
            print("send email code")
            alertView.close()
        }
    }
    
    func createContainerView() -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 20))
        let label = UILabel(frame: CGRect(x: 0, y: 30, width: 290, height: 20))
        label.text = "SIGNUP AS"
        label.font = UIFont(name: "Helvetica", size: CGFloat(17))
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.center
        View.addSubview(label)
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 260, y: 0, width: 30, height: 30)
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        View.addSubview(closeButton)
        return View;
    }
    
    func createContainerViewForForgotPassword() -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 220))
        let label = UILabel(frame: CGRect(x: 0, y: 30, width: 290, height: 20))
        label.text = "Please enter your registered Email"
        label.font = UIFont(name: "Helvetica", size: CGFloat(17))
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.center
        View.addSubview(label)
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 260, y: 0, width: 30, height: 30)
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        View.addSubview(closeButton)
        OTPTextfield = UITextField(frame: CGRect(x: 20, y: 75, width: 250.00, height: 35.00))
        OTPTextfield.textAlignment = NSTextAlignment.center;
        OTPTextfield.borderStyle = UITextBorderStyle.roundedRect
        OTPTextfield.keyboardType = UIKeyboardType.emailAddress
        OTPTextfield.backgroundColor = UIColor.white
        OTPTextfield.textColor = UIColor.black
        OTPTextfield.layer.borderColor=UIColor.ExpertConnectRed.cgColor
        OTPTextfield.layer.borderWidth = 1.0;
        OTPTextfield.delegate=self;
        OTPTextfield.becomeFirstResponder()
        View.addSubview(OTPTextfield)
        return View;
    }
    
    func pressButton(button: UIButton) {
        // Do whatever you need when the button is pressed
        alertView.close()
    }
    
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
    
    // The buttons that will appear in the alertView
    override func displayProgress(message: String) {
        super.displayProgress(message: message)
    }
    
    override func dismissProgress() {
        super.dismissProgress()
    }
    
    func getLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            email: self.emailTextfield.text!,
            password: self.passwordTextfield.text!,
            deviceToken: "sdhhfkjshfkhfkh",
            operatingSysType:"iOS"
            
            //rememberMe: self.rememberMeSwitch.isOn
        )
    }
    
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
    
    func navigateBackToViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController()
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
        let model = FPDomainModel.init(email: self.OTPTextfield.text!/*"bhushan@gmail.com"*//*self.OTPTextfield.text!*/)
        return model
    }

}
