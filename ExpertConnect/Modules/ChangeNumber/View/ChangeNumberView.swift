//
//  ChangeNumberView.swift
//  ExpertConnect
//
//  Created by Redbytes on 31/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
protocol ChangeNumberDelegate {
    func changeNumberSucceded(showAlert:Bool, message: String) -> Void
}

class ChangeNumberView: UIViewController, CustomIOS7AlertViewDelegate, UITextFieldDelegate,CountryCodeSelectionViewControllerDelegate {
    var delegate:ChangeNumberDelegate!
    
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet weak var newMobileNumberTextField: UITextField!
    @IBOutlet var countryCodeTextfield: UITextField!
    
    @IBOutlet weak var verifyButon: UIButton!
    @IBOutlet weak var baseView: UIView!
    let buttons = ["SUBMIT"]
    var text: String?
    var OTPTextfield = UITextField()
    let alertView = CustomIOS7AlertView()
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        OTPTextfield.delegate = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = "ChangeNumber".localized(in: "SettingsView")
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.setExpertConnectRedButtonTheme(button: self.verifyButon)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setExpertConnectShadowTheme(view: baseView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func verifyButtonClicked(_ sender: Any) {
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ChangeNumberView")
            self.displayErrorMessage(message: message)
            return
        }
        if  (self.countryCodeTextfield.text == nil || (self.countryCodeTextfield.text?.characters.count)! == 0){
            let message = "Please Select Country Code".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if  (self.newMobileNumberTextField.text == nil || (self.newMobileNumberTextField.text?.characters.count)! == 0) {
            let message = "Please Enter Valid Mobile No.".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if(!self.userPhoneNumberValidation(string: self.newMobileNumberTextField.text!)) {
            let message = "Please Enter Mobile No. With Minimum 9 Digits".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        
        let message = "Verifying mobile number".localized(in: "ChangeNumberView")
        self.displayProgress(message: message)
        
        let APIDataManager : GetOTPProtocol = GetOTPApiDataManager()
        APIDataManager.getOTP(data: self.newMobileNumberTextField.text!, callback: { (result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onGetOTPFailed(error: error)
            case .Success(let data as OTPOutputDomainModel):
                self.onGetOTPSucceeded(data: data)
            default:
                break
            }
        })
    }
    
    func userPhoneNumberValidation(string: String) -> Bool {
        if string.characters.count >= 9 && string.characters.count <= 10 {
            return true
        }
        return false
    }
    
    // MARK: Get OTP Methods
    func onGetOTPSucceeded(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            alertView.buttonTitles = buttons
            alertView.containerView = createContainerView()
            /** show OTP on textField */
            for subView in alertView.containerView.subviews {
                if subView.isKind(of: UITextField.self) {
                    let OTPTextField = subView as! UITextField
                    OTPTextField.text = data.OTPString
                    break
                }
            }
            /** end - show OTP on textField */
            alertView.delegate = self
            alertView.catchString(withString: "3")
            alertView.show()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onGetOTPFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to verify")
    }
    
    // MARK: textfield delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == OTPTextfield {
            return true
        }
        if textField == countryCodeTextfield {
            let countryCodeSelectionView : CountryCodeSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryCodeSelectionViewController") as UIViewController as! CountryCodeSelectionViewController
            countryCodeSelectionView.countryCodedelegate = self
            let navController = UINavigationController(rootViewController: countryCodeSelectionView)
            self.present(navController, animated: true, completion: nil)
            countryCodeSelectionView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
            return false
        }
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Custom Alert Handle button touches
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        if (buttonIndex==0)
        {
            if (self.OTPTextfield.text == nil || (self.OTPTextfield.text?.characters.count)! == 0){
                let message = "Please Enter OTP".localized(in: "ExpertDetails")
                alertView.close()
                self.displayErrorMessageWithCallback(message: message)
                return
            }
            OTPTextfield.resignFirstResponder()
            alertView.close()
            let message = "Verifying OTP".localized(in: "ChangeNumberView")
            self.displayProgress(message: message)
            let verifyOTPModel = VerifyOTPInputDomainModel.init(OTPString: OTPTextfield.text!, mobile_no: self.newMobileNumberTextField.text!)
            let APIDataManager : VerifyOTPProtocol = VerifyOTPApiDataManager()
            APIDataManager.verifyOTP(data: verifyOTPModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onVerifyOTPFailed(error: error)
                case .Success(let data as OTPOutputDomainModel):
                    self.onVerifyOTPResponce(data: data)
                default:
                    break
                }
            })
        }
    }
    
    // MARK: Verify OTP Methods
    func onVerifyOTPResponce(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            OTPTextfield.resignFirstResponder()
            alertView.close()
            let message = "Updating mobile number".localized(in: "ChangeNumberView")
            self.displayProgress(message: message)
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            
            let changeNumberInputDomainModel = ChangeNumberInputDomainModel.init(userId: self.userId, countryCode: self.countryCodeTextfield.text!,newMobileNumber: self.newMobileNumberTextField.text!)
            let APIDataManager : ChangeNumberProtocol = ChangeNumberApiDataManager()
            APIDataManager.changeNumber(data: changeNumberInputDomainModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onChangeNumberFailed(error: error)
                case .Success(let data as OTPOutputDomainModel):
                    self.onChangeNumberSucceed(data: data)
                default:
                    break
                }
            })
            
        } else {
            self.displayErrorMessage(message: data.message)
            alertView.close()
        }
    }
    
    func onVerifyOTPFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to verify")
    }
    
    // MARK: Verify OTP Methods
    func onChangeNumberSucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            OTPTextfield.resignFirstResponder()
            alertView.close()
            
            self.delegate.changeNumberSucceded(showAlert: true, message: "Your mobile number updated successfully".localized(in: "ChangeNumberView"))
            self.view.endEditing(true)
            _ = self.navigationController?.popViewController(animated: true)
            
        } else {
            self.displayErrorMessage(message: data.message)
            alertView.close()
        }
    }
    
    func onChangeNumberFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to update")
    }
    
    // MARK: Custom Alert view method
    func createContainerView() -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 200))
        let label = UILabel(frame: CGRect(x: 20, y: 35, width: 240, height: 50))
        label.text = "Please enter OTP"
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
        OTPTextfield.delegate = self;
        
        self.setCustomAlertTextFieldTheme(textfield: OTPTextfield)
        OTPTextfield.becomeFirstResponder()
        View.addSubview(OTPTextfield)
        return View;
    }
    
    // MARK: Custom Alert view close button method
    func pressButton(button: UIButton) {
        alertView.close()
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    func displayErrorMessageWithCallback(message: String) {
        self.showErrorMessage(message: message, callback: {
            self.alertView.show()
        })
    }
    
    //MARK: Country Code Delegate
    func didSelectCountry(withCode:String) {
        self.countryCodeTextfield.text = withCode;
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
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
