//
//  SignUpVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import GooglePlacePicker
import GoogleMaps
import GooglePlaces

class SignUpVC: UIViewController, CustomIOS7AlertViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CountryCodeSelectionViewControllerDelegate, CLLocationManagerDelegate {
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    
    var gender : String = "Female"
    
    var cell = SignupDateCell()
    var date = String()
    var month = String()
    var year = String()
    
    var pickerview = UIPickerView()
    var datePickerArray = NSMutableArray()
    var monthPickerArray = NSMutableArray()
    var yearPickerArray = NSMutableArray()
    
    var text: String?
    var OTPTextfield = UITextField()
    let alertView = CustomIOS7AlertView()
    
    var userId: String = ""
    var userType: String = ""
    var lattitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var facebookOutputDomainModel: FacebookOutputDomainModel = FacebookOutputDomainModel()
    var signUpInputDomainModel: SignUpInputDomainModel!
    var socialID : String = ""
    var cityName : String = ""

    // The buttons that will appear in the alertView
    let buttons = ["SUBMIT"]
    @IBOutlet var scrollview: TPKeyboardAvoidingScrollView!
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var firstNameTextfield: UITextField!
    @IBOutlet var lastNameTextfield: UITextField!
    @IBOutlet var EmailTextfield: UITextField!
    
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var countryCodeTextfield: UITextField!
    
    @IBOutlet var mobileNoTextfield: UITextField!
    @IBOutlet var countryCodeButton: UIButton!
    @IBOutlet var DOBTextfield: UITextField!
    @IBOutlet var locationTextfield: UITextField!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet weak var leadingSpaceFemaleButton: NSLayoutConstraint!
    @IBOutlet weak var trailingSpaceMaleButton: NSLayoutConstraint!
    
    let radioButtonDeselected = UIImage(named:"radio_unselected_btn")
    let radioButtonSelected = UIImage(named:"radio_selected_btn")
    
    let locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    // MARK: Alert enum for UIAlertController
    enum UIAlertControllerStyle : Int {
        case ActionSheet
        case Alert
    }
    
    // MARK: view life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        imagePicker.delegate = self
        OTPTextfield.delegate = self
        
        self.countryCodeTextfield.delegate = self
        self.DOBTextfield.delegate = self
        self.EmailTextfield.delegate = self
        self.mobileNoTextfield.delegate = self
        self.locationTextfield.delegate = self
        self.scrollview.delegate = self
        
        date = NSString(format:"%@", "01") as String
        month = NSString(format:"%@", "01") as String as String
        year = NSString(format:"%@", "1950") as String
        
        self.femaleButton.setImage(radioButtonDeselected, for: UIControlState.normal)
        self.maleButton.setImage(radioButtonDeselected, for: UIControlState.normal)
        
        // Setup data from FB
        if (self.isUserSignupFromFB()) {
            self.setupFBUserData()
        } else {
            self.firstNameTextfield.isUserInteractionEnabled = true
            self.lastNameTextfield.isUserInteractionEnabled = true
            self.EmailTextfield.isUserInteractionEnabled = true
            self.editProfileButton.isEnabled = true
            self.femaleButton.isUserInteractionEnabled = true
            self.maleButton.isUserInteractionEnabled = true
        }
        
        self.getCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let originalImage = UIImage(named:"location_icon")
        let tintedImage = originalImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        locationButton.setImage(tintedImage, for: .normal)
        locationButton.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        if(screenWidth == 320) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0, animations: {
                self.leadingSpaceFemaleButton.constant = 20
                self.trailingSpaceMaleButton.constant = 20
                self.view.layoutIfNeeded()
            })
        }
        
        self.profileImageview.layer.cornerRadius = self.profileImageview.frame.size.width/2
        self.profileImageview.layer.masksToBounds = true
        self.profileImageview.clipsToBounds = true
        
        let image: UIImage? = selectedImage
        if image != nil {
            self.profileImageview.image = selectedImage
        } else {
            self.profileImageview.image = UIImage(named:"default_profile_pic")!
        }
        
        self.setExpertConnectRedButtonTheme(button: self.locationButton)
        self.setExpertConnectRedButtonTheme(button: self.nextButton)
        self.setExpertConnectTextFieldTheme(textfield: self.locationTextfield)
        self.locationTextfield.layer.borderColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1).cgColor
        if (self.isUserSignupFromFB()) {
            self.setupFBUserImage()
        }
    }
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    // MARK: Setup FB User Data
    func isUserSignupFromFB() -> Bool {
        return UserDefaults.standard.bool(forKey: "UserSignupFromFB")
    }
    
    func setupFBUserData() {
        self.firstNameTextfield.text = self.facebookOutputDomainModel.firstName
        self.lastNameTextfield.text = self.facebookOutputDomainModel.lastName
        self.EmailTextfield.text = self.facebookOutputDomainModel.email
        self.firstNameTextfield.isUserInteractionEnabled = false
        self.lastNameTextfield.isUserInteractionEnabled = false
        self.EmailTextfield.isUserInteractionEnabled = false
        self.editProfileButton.isEnabled = false
        
        if(self.firstNameTextfield.text == nil || (self.firstNameTextfield.text?.characters.count)! == 0) {
            self.firstNameTextfield.isUserInteractionEnabled = true
        }
        if(self.lastNameTextfield.text == nil || (self.lastNameTextfield.text?.characters.count)! == 0) {
            self.lastNameTextfield.isUserInteractionEnabled = true
        }
        if(self.EmailTextfield.text == nil || (self.EmailTextfield.text?.characters.count)! == 0) {
            self.EmailTextfield.isUserInteractionEnabled = true
        }
        
        if(self.facebookOutputDomainModel.gender == "female") {
            self.femaleButton.setImage(radioButtonSelected, for: UIControlState.normal)
            self.gender = "Female"
            self.femaleButton.isUserInteractionEnabled = false
            self.maleButton.isUserInteractionEnabled = false
            
        }
        if(self.facebookOutputDomainModel.gender == "male") {
            self.maleButton.setImage(radioButtonSelected, for: UIControlState.normal)
            self.gender = "Male"
            self.femaleButton.isUserInteractionEnabled = false
            self.maleButton.isUserInteractionEnabled = false
        }
    }
    
    func setupFBUserImage() {
        let url = URL(string: self.facebookOutputDomainModel.profilePicUrl)
        self.profileImageview.kf.setImage(with: url)
    }
    
    // MARK: back button click methods
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: editProfile button click methods
    @IBAction func editProfileButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.alertControllerAction(sender: sender)
    }
    
    // MARK: image picker methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if imagePicker.sourceType == UIImagePickerControllerSourceType.camera {
            dismiss(animated: true, completion: nil)
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.profileImageview.image = selectedImage
        }
        else if imagePicker.sourceType == UIImagePickerControllerSourceType.photoLibrary {
            
            dismiss(animated: true, completion: nil)
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.profileImageview.image = selectedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: alert Controller method
    @IBAction func alertControllerAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Profile Pic (Optional)", message: "", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("Ok Button Pressed")
            
            self.takePhoto()
        })
        let ok1 = UIAlertAction(title: "Choose from Gallery", style: .default, handler: { (action) -> Void in
            print("Ok Button Pressed")
            self.openPhotoGallery()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
        })
        
        alertController.addAction(ok)
        alertController.addAction(ok1)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
        //        else
        //        {
        //
        //            [Constant showAlertWithTitle:@"Warning" message:@"Camera is not available, so try with another source" presentingVC:self];
        //
        //        }
    }
    func openPhotoGallery()  {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: country Code Button method
    @IBAction func countryCodeButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        let countryCodeSelectionView : CountryCodeSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryCodeSelectionViewController") as UIViewController as! CountryCodeSelectionViewController
        countryCodeSelectionView.countryCodedelegate = self
        self.present(countryCodeSelectionView, animated: true, completion: nil)
        countryCodeSelectionView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
    }
    
    // MARK: Choose Gender Button method
    @IBAction func femaleButtonClicked(_ sender: UIButton) {
        if (self.femaleButton.currentImage?.isEqual(radioButtonDeselected))! {
            self.femaleButton.setImage(radioButtonSelected, for: UIControlState.normal)
            self.maleButton.setImage(radioButtonDeselected, for: UIControlState.normal)
            self.gender = "Female"
        } else {
            self.femaleButton.setImage(radioButtonSelected, for: UIControlState.normal)
            self.gender = "Female"
        }
    }
    
    @IBAction func maleButtonClicked(_ sender: UIButton) {
        if (self.maleButton.currentImage?.isEqual(radioButtonDeselected))! {
            self.maleButton.setImage(radioButtonSelected, for: UIControlState.normal)
            self.femaleButton.setImage(radioButtonDeselected, for: UIControlState.normal)
            self.gender = "Male"
        } else {
            self.maleButton.setImage(radioButtonSelected, for: UIControlState.normal)
            self.gender = "Male"
        }
    }
    
    // MARK: location Button method
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        let message = "Processing".localized(in: "SignUp")
        self.displayProgress(message: message)
        self.setCurrentLocationOnPlacePicker()
    }
    
    // MARK: next Button method
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        //        self.view.endEditing(true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        //        if (self.profileImageview.image == nil || self.profileImageview.image == UIImage(named:"default_profile_pic")) {
        //            let message = "Please Select Profile Picture".localized(in: "SignUp")
        //            self.displayErrorMessage(message: message)
        //            return
        //        }
        if !self.userNameValidation(string: self.firstNameTextfield.text!) {
            let message = "Please Enter Valid Firstname".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if !self.userNameValidation(string: self.lastNameTextfield.text!) {
            let message = "Please Enter Valid Lastname".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if(!self.isValidEmail()) {
            let message = "Please Enter Valid Email".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if(!self.userPasswordValidation(string: self.passwordTextfield.text!)) {
            let message = "Please Enter Password With Minimum 6 Characters".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if  (self.countryCodeTextfield.text == nil || (self.countryCodeTextfield.text?.characters.count)! == 0){
            let message = "Please Select Country Code".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if(!self.userPhoneNumberValidation(string: self.mobileNoTextfield.text!)) {
            let message = "Please Enter Mobile No. With Minimum 9 Digits".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if  (self.mobileNoTextfield.text == nil || (self.mobileNoTextfield.text?.characters.count)! == 0) {
            let message = "Please Enter Valid Mobile No.".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if  (self.DOBTextfield.text == nil || (self.DOBTextfield.text?.characters.count)! == 0){
            let message = "Please Enter Date Of Birth".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.femaleButton.image(for: UIControlState.normal) == radioButtonDeselected && self.maleButton.image(for: UIControlState.normal) == radioButtonDeselected) {
            let message = "Please Select Gender".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if  (self.locationTextfield.text == nil || (self.locationTextfield.text?.characters.count)! == 0) {
            let message = "Please Select Location".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        } else {
            print(self.DOBTextfield.text)
            print(gender)
            
            //Set Socil ID
            var regType: String
            
            if (self.isUserSignupFromFB()) {
                self.socialID = self.facebookOutputDomainModel.userId
                selectedImage = self.profileImageview.image
                regType = "2"
            } else {
                regType = "1"
            }
            
            var userPrifilePic: String
            let image: UIImage? = selectedImage
            if image != nil {
                selectedImage = (selectedImage?.fixedOrientation())
                userPrifilePic = (selectedImage?.convertImageToBase64(image: selectedImage!))! as String
            } else {
                userPrifilePic = ""
            }
            
            //let latitudeText = String(format: "%f", self.lattitude)
            let lattitudeString = String(format: "%f", self.lattitude)
            let longitudeString = String(format: "%f", self.longitude)
            
            let defaults = UserDefaults.standard
            let teacherStudentValue = defaults.string(forKey: "teacherStudentValue")
            if teacherStudentValue! == NSString(format:"%@","3") as String {
                self.userType = teacherStudentValue!
            } else if teacherStudentValue! == NSString(format:"%@","2") as String {
                self.userType = teacherStudentValue!
            }
            
            let deviceToken = UserDefaults.standard.value(forKey: "com.ExpertConnect.devicetoken") as! String
            signUpInputDomainModel = SignUpInputDomainModel.init(userType: self.userType,
                                                                 firstName: self.firstNameTextfield.text!,
                                                                 lastName: self.lastNameTextfield.text!,
                                                                 emailId: self.EmailTextfield.text!,
                                                                 password: self.passwordTextfield.text!,
                                                                 countryCode: self.countryCodeTextfield.text!,
                                                                 mobileNo: self.mobileNoTextfield.text!,
                                                                 dob: self.DOBTextfield.text!, gender: gender,
                                                                 profilePic: userPrifilePic,
                                                                 deviceToken: deviceToken,
                                                                 osType: "iOS",
                                                                 latitude: lattitudeString, longitude: longitudeString, location: self.cityName,
                                                                 regType: regType, socialId: self.socialID)
            
            
            let verifyEmailAndMobileNoInput = verifyEmailAndMobileNoInputDomainModel.init(emailId: self.EmailTextfield.text!, mobileNo: self.mobileNoTextfield.text!)
            
            let message = "Procssing".localized(in: "SignUp")
            self.displayProgress(message: message)
            let APIDataManager: verifyEmailAndMobileNoProtocols = verifyEmailAndMobileNoApiDataManager()
            APIDataManager.verifyEmailAndMobileNo(data: verifyEmailAndMobileNoInput, callback: { (result) in
                switch result {
                case .Failure(let error):
                    self.onVerifyEmailAndMobileNoFailed(error: error)
                case .Success(let data as verifyEmailAndMobileNoOutputDomainModel):
                    do {
                        self.onVerifyEmailAndMobileNoSucceeded(data: data)
                    } catch {
                        self.onVerifyEmailAndMobileNoFailed(data: data)
                    }
                default:
                    break
                }
            })
        }
    }
    
    // MARK: Validation method
    func userNameValidation(string: String) -> Bool {
        let emailRegex = "[a-zA-z]+([ '-][a-zA-Z]+)*$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: string)
    }
    //    func mobileNumberValidation(string: NSString) -> Bool {
    //        let phoneRegex = "[0-9]{10}"
    //
    //        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: string)
    //    }
    func isValidateDOB(string: NSString) -> Bool {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        return true
    }
    
    // MARK: Custom Alert Handle button touches
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        //  print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        if (buttonIndex==0)
        {
            if (self.OTPTextfield.text == nil || (self.OTPTextfield.text?.characters.count)! == 0){
                let message = "Please Enter OTP".localized(in: "ExpertDetails")
                alertView.close()
                self.displayErrorMessageWithCallback(message: message)
                return
            }
            
            let message = "Processing".localized(in: "SignUp")
            self.displayProgress(message: message)
            let verifyOTPModel = VerifyOTPInputDomainModel.init(OTPString: OTPTextfield.text!, mobile_no: self.mobileNoTextfield.text!)
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
        OTPTextfield.delegate=self;
        
        self.setCustomAlertTextFieldTheme(textfield: OTPTextfield)
        OTPTextfield.becomeFirstResponder()
        View.addSubview(OTPTextfield)
        return View;
    }
    
    // MARK: Custom Alert view close button method
    func pressButton(button: UIButton) {
        alertView.close()
    }
    
    // MARK: textfield delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.mobileNoTextfield {
            var cell = SignupDateCell()
            cell = Bundle.main.loadNibNamed("SignupDateCell", owner: nil, options: nil)?[0] as! SignupDateCell
            cell.doneButton.addTarget(self, action: #selector(inputAccessoryViewDidFinishForDoneButton(button:)), for: .touchUpInside)
            cell.cancelButton.addTarget(self, action: #selector(inputAccessoryViewDidFinishForCancelButton(button:)), for: .touchUpInside)
            cell.cancelButton.tag = 101
            cell.doneButton.tag = 101
            
            let myToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            cell.frame = myToolbar.frame
            myToolbar.addSubview(cell)
            // textField.inputAccessoryView = myToolbar;
            textField.inputAccessoryView?.backgroundColor=UIColor.darkGray
            return true
        }
        if textField == self.locationTextfield {
            self.view.endEditing(true)
            let message = "Processing".localized(in: "SignUp")
            self.displayProgress(message: message)
            self.setCurrentLocationOnPlacePicker()
            return false
        }
        if textField == OTPTextfield {
            return true
        }
        
        if textField == self.DOBTextfield {
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.year = -112
            let hundredYearAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            dateComponents.year = -12
            let twelveYearAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            
            DatePickerDialog().show("Select Date Of Birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: hundredYearAgo, maximumDate: twelveYearAgo, datePickerMode: .date) { (date) in
                if let FullDateObject = date {
                    let tempDate = "\(FullDateObject)"
                    if (tempDate == "" || tempDate.characters.count == 0 || tempDate == "nil") {
                        self.DOBTextfield.text = ""
                        return
                    }
                    self.DOBTextfield.text = FullDateObject.ToLocalStringWithFormat(dateFormat: "yyyy-MM-dd")
                }
            }
            return false
        } else {
            if textField == countryCodeTextfield {
                let countryCodeSelectionView : CountryCodeSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryCodeSelectionViewController") as UIViewController as! CountryCodeSelectionViewController
                countryCodeSelectionView.countryCodedelegate = self
                self.present(countryCodeSelectionView, animated: true, completion: nil)
                countryCodeSelectionView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
                return false
            }
            textField.inputAccessoryView = nil;
            textField.inputAccessoryView?.backgroundColor=UIColor.clear
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
    
    // MARK: pickerview datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.datePickerArray.count;
        } else if component == 1 {
            return self.monthPickerArray.count;
        }
        return self.yearPickerArray.count;
    }
    
    // MARK: pickerview delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let title = NSString(format:"%@" , self.datePickerArray[row] as! CVarArg )
            return title as String
        } else if component == 1 {
            let title = NSString(format:"%@" , self.monthPickerArray[row] as! CVarArg )
            return title as String
        }
        let title = NSString(format:"%@" , self.yearPickerArray[row] as! CVarArg )
        return title as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            date = String(describing: self.datePickerArray[row])
            //            date = self.datePickerArray[row] as! CVarArg as! String
        } else if (component == 1) {
            month = String(describing: self.monthPickerArray[row])
            //            month = self.monthPickerArray[row] as! CVarArg as! String
        } else if (component == 2) {
            year = String(describing: self.yearPickerArray[row])
        }
    }
    
    // MARK: inputAccessoryViewDidFinish method
    func inputAccessoryViewDidFinishForDoneButton(button : UIButton) {
        self.view.endEditing(true)
        if button.tag == 102 {
            let str = NSString(format:"%@/%@/%@", date ,month,year) as String
            DOBTextfield.text = str
        }
    }
    func inputAccessoryViewDidFinishForCancelButton(button : UIButton) {
        self.view.endEditing(true)
        if button.tag == 101 {
            self.mobileNoTextfield.text = ""
        }
        if button.tag == 102 {
            //self.DOBTextfield.text = ""
        }
    }
    
    // MARK: Alert with Message method
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
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
            //            alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
            //                print("CLOSURE: Button '\(self.buttons[buttonIndex])' touched")
            //            }
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
    
    // MARK: Alert for verify email and mobileNo
    func onVerifyEmailAndMobileNoSucceeded(data: verifyEmailAndMobileNoOutputDomainModel) {
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
        //        UserDefaults.standard.setValue( data.userId, forKey: "UserId")
        
        print("Hey you logged in: \(data.message)")
        self.dismissProgress()
        print("signup data %@",data.message)
        print("signup data %@",data.status)
        if data.status {
            let message = "Processing".localized(in: "SignUp")
            self.displayProgress(message: message)
            
            let APIDataManager : GetOTPProtocol = GetOTPApiDataManager()
            APIDataManager.getOTP(data: self.mobileNoTextfield.text!, callback: { (result) in
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
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onVerifyEmailAndMobileNoFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to register the user")
    }
    
    func onVerifyEmailAndMobileNoFailed(data:verifyEmailAndMobileNoOutputDomainModel) {
        self.dismissProgress()
        self.displayErrorMessage(message: data.message)
    }
    
    // MARK: Verify OTP Methods
    func onVerifyOTPResponce(data:OTPOutputDomainModel) {
        self.dismissProgress()
        
        if data.status == true {
            //            self.showSuccessMessage(message: data.message)
            OTPTextfield.resignFirstResponder()
            alertView.close()
            //push next VC
            let defaults = UserDefaults.standard
            let teacherStudentValue = defaults.string(forKey: "teacherStudentValue")
            
            if teacherStudentValue! == NSString(format:"%@","2") as String {
                let coachingDetailsVC : CoachingDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoachingDetailsVC") as UIViewController as! CoachingDetailsVC
                //coachingDetailsVC.userId = self.userId
                coachingDetailsVC.signUpInputDomainModel = signUpInputDomainModel
                self.navigationController?.pushViewController(coachingDetailsVC, animated: true)
                
            } else if teacherStudentValue! == NSString(format:"%@","3") as String {
                let expertDetailsVC : ExpertDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpertDetailsVC") as UIViewController as! ExpertDetailsVC
                // expertDetailsVC.userId = self.userId
                expertDetailsVC.signUpInputDomainModel = signUpInputDomainModel
                self.navigationController?.pushViewController(expertDetailsVC, animated: true)
            }
        } else {
            self.displayErrorMessage(message: data.message)
            alertView.close()
        }
    }
    
    func onVerifyOTPFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to verify")
    }
    
    func isValidEmail() -> Bool {
        if getEmailText().isEmpty { return false }
        let factory = ValidatorFactory()
        let validator = factory.create(type: EInputType.EMAIL)
        return validator.isValid(text: getEmailText())
    }
    func isValidPhone() -> Bool {
        if getPhoneText().isEmpty { return false }
        let factory = ValidatorFactory()
        let validator = factory.create(type: EInputType.PHONE)
        return validator.isValid(text: getPhoneText())
    }
    func getEmailText() -> String! {
        if let _ = self.EmailTextfield.text {
            return self.EmailTextfield.text
        } else {
            return ""
        }
    }
    func getPhoneText() -> String! {
        if let _ = self.mobileNoTextfield.text {
            return self.mobileNoTextfield.text
        } else {
            return ""
        }
    }
    func userPasswordValidation(string: String) -> Bool {
        if string.characters.count>=6 {
            return true
        }
        return false
    }
    
    func userPhoneNumberValidation(string: String) -> Bool {
        if string.characters.count >= 9 && string.characters.count <= 10 {
            return true
        }
        return false
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        if component == 0 {
            
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.ExpertConnectBlack
            pickerLabel.text = NSString(format:"%@" , self.datePickerArray[row] as! CVarArg ) as String
            pickerLabel.font = UIFont(name: "Raleway-Light", size: 18) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
        else if component == 1
        {
            
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.ExpertConnectBlack
            pickerLabel.text = NSString(format:"%@" , self.monthPickerArray[row] as! CVarArg ) as String
            pickerLabel.font = UIFont(name: "Raleway-Light", size: 18) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
            
        }
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.ExpertConnectBlack
        pickerLabel.text = NSString(format:"%@" , self.yearPickerArray[row] as! CVarArg ) as String
        pickerLabel.font = UIFont(name: "Raleway-Light", size: 18) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    // MARK: PlacePicker Method
    func setCurrentLocationOnPlacePicker() {
        let placesClient = GMSPlacesClient()
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            self.dismissProgress()
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                self.displayErrorMessage(message: "Pick Place error: \(error.localizedDescription)")
                return
            }
            if let placeLikelihoodList = placeLikelihoodList {
                if(placeLikelihoodList.likelihoods.count == 0)
                {
                    self.getDefaultLocation()
                } else {
                    for likelihood in placeLikelihoodList.likelihoods {
                        let place = likelihood.place
                        self.getLocation(place: place)
                        
                        print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                        print("Current Place address \(place.formattedAddress)")
                        print("Current Place attributions \(place.attributions)")
                        print("Current PlaceID \(place.placeID)")
                        break
                    }
                }
            }
        })
    }
    
    func getLocation(place: GMSPlace) {
        let center = place.coordinate
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                self.displayErrorMessage(message: "Pick Place error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.locationTextfield.text = place.name
                let coordinates = place.coordinate
                self.lattitude = place.coordinate.latitude
                self.longitude = place.coordinate.longitude
                self.setUsersClosestCity()
            } else {
                // self.locationTextfield.text = ""
                //self.address.text = ""
            }
        })
    }
    
    func getDefaultLocation() {
        
        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                self.displayErrorMessage(message: "Pick Place error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.locationTextfield.text = place.name
                let coordinates = place.coordinate
                self.lattitude = place.coordinate.latitude
                self.longitude = place.coordinate.longitude
                self.setUsersClosestCity()
            } else {
                // self.locationTextfield.text = ""
                //self.address.text = ""
            }
        })
    }

    func setUsersClosestCity()
    {
        let message = "Processing".localized(in: "SignUp")
        self.displayProgress(message: message)

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.lattitude, longitude: self.longitude)
        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            self.dismissProgress()
            let placeArray = placemarks as [CLPlacemark]!
            if((placeArray?.count)! > 0) {
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                if placeMark.addressDictionary != nil {
                    // Location name
                    if let locationName = placeMark.addressDictionary?["Name"] as? NSString {
                        print(locationName)
                    }
                    // Street address
                    if let street = placeMark.addressDictionary?["Thoroughfare"] as? NSString {
                        print(street)
                    }
                    // City
                    if let city = placeMark.addressDictionary?["City"] as? NSString {
                        print("City Place : \(city)")
                        self.cityName = city as String
                    }
                    // Zip code
                    if let zip = placeMark.addressDictionary?["ZIP"] as? NSString {
                        print(zip)
                    }
                    // Country
                    if let country = placeMark.addressDictionary?["Country"] as? NSString {
                        print(country)
                    }
                }
            }
        }
    }
    
    //MARK: Country Code Delegate
    func didSelectCountry(withCode:String) {
        self.countryCodeTextfield.text = withCode;
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
