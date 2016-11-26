//
//  SignUpVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, CustomIOS7AlertViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    var gender : String = "Male"
    
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

    // The buttons that will appear in the alertView
    let buttons = [
        "SUBMIT"
    ]
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
    @IBOutlet var maleFemaleButton: UIButton!
    @IBOutlet var maleImageview: UIImageView!
    @IBOutlet var femaleImageview: UIImageView!
    
    // MARK: Alert enum for UIAlertController
    enum UIAlertControllerStyle : Int {
        case ActionSheet
        case Alert
    }
    
    // MARK: view life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTPTextfield.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        imagePicker.delegate = self
        
        self.countryCodeTextfield.delegate = self
        self.DOBTextfield.delegate = self
        self.EmailTextfield.delegate = self
        self.mobileNoTextfield.delegate = self
        self.locationTextfield.delegate = self
        
        
        self.pickerview.delegate = self;
        self.pickerview.dataSource = self;
        self.scrollview.delegate = self
        
        self.DOBTextfield.inputView = self.pickerview;
        
        date = NSString(format:"%@", "01") as String
        month = NSString(format:"%@", "01") as String as String
        year = NSString(format:"%@", "1950") as String
        
        self.maleFemaleButton.setImage(UIImage(named:"gender_left_btn"), for: UIControlState.normal)
        //        self.MFSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75);
        
        selectedImage = UIImage(named:"default_profile_pic")!
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print(appDelegate.catchCountryCode)
        self.countryCodeTextfield.text = appDelegate.catchCountryCode;
        
        let originalImage = UIImage(named:"location_icon")
        
        let tintedImage = originalImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        locationButton.setImage(tintedImage, for: .normal)
        locationButton.backgroundColor = UIColor(red: 247/255, green: 67/255, blue: 0/255, alpha: 1)
        locationButton.tintColor = UIColor.white
        
        //        let defaults = UserDefaults.standard
        //        self.countryCodeTextfield.text = defaults.string(forKey: "countryCode")
    }
    override func viewDidAppear(_ animated: Bool) {
        //        profileImageview.layoutIfNeeded()
        self.profileImageview.layer.cornerRadius = self.profileImageview.frame.size.width/2
        self.profileImageview.layer.masksToBounds = true
        self.profileImageview.clipsToBounds = true
        self.profileImageview.image = selectedImage
        
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
            selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.profileImageview.image = selectedImage
        }
        else if imagePicker.sourceType == UIImagePickerControllerSourceType.photoLibrary{
            
            dismiss(animated: true, completion: nil)
            selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.profileImageview.image = selectedImage
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: alert Controller method
    @IBAction func alertControllerAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "", message: "Add Profile Pic", preferredStyle: .actionSheet)
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
    func takePhoto()  {

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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "CountryCodeSelectionViewController")
        self.present(VC, animated: true, completion: nil)
        VC.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
    }
    
    // MARK: country Code Button method
    @IBAction func maleFemaleButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.maleFemaleButton.image(for: UIControlState.normal) == UIImage(named:"gender_btn") {
            self.maleFemaleButton.setImage(UIImage(named:"gender_left_btn"), for: UIControlState.normal)
            self.maleImageview.image = UIImage(named:"male_orange_icon")
            self.femaleImageview.image = UIImage(named:"female_gray_icon")
            gender = "Male"
        }
        else if self.maleFemaleButton.image(for: UIControlState.normal) == UIImage(named:"gender_left_btn") {
            self.maleFemaleButton.setImage(UIImage(named:"gender_btn"), for: UIControlState.normal)
            self.femaleImageview.image = UIImage(named:"female_icon")
            self.maleImageview.image = UIImage(named:"male_icon")
            gender = "Female"
        }
    }
    
    // MARK: location Button method
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    // MARK: next Button method
    @IBAction func nextButtonClicked(_ sender: UIButton) {
//        self.view.endEditing(true)
        if (self.profileImageview.image == nil || self.profileImageview.image == UIImage(named:"default_profile_pic"))
        {
            self.alert(message: "Please select profile picture")
        }
        else if !self.userNameValidation(string: self.firstNameTextfield.text!) {
            self.alert(message: "Please enter valid firstname")
            
        }
        else if !self.userNameValidation(string: self.lastNameTextfield.text!){
            self.alert(message: "Please enter valid lastname")
        }
        else if  (self.EmailTextfield.text == nil || (self.EmailTextfield.text?.characters.count)! == 0){
            self.alert(message: "Please enter email")
        }
        else if  (self.passwordTextfield.text == nil || (self.passwordTextfield.text?.characters.count)! == 0){
            self.alert(message: "Please enter password")
        }
        else if  (self.countryCodeTextfield.text == nil || (self.countryCodeTextfield.text?.characters.count)! == 0){
            self.alert(message: "Please select country code")
        }
        else if  (self.mobileNoTextfield.text == nil || (self.mobileNoTextfield.text?.characters.count)! == 0){
            self.alert(message: "Please enter mobile no. ")
        }
        else if  (self.DOBTextfield.text == nil || (self.DOBTextfield.text?.characters.count)! == 0){
            self.alert(message: "Please enter date of birth ")
        }
        else {
        print(self.DOBTextfield.text)
            
            let datestring: String = self.DOBTextfield.text!
            var parts = datestring.components(separatedBy: "/")
            let userBirthDate: String = String(format:"%@-%@-%@",parts[2],parts[1],parts[0])
            
            print(gender)
            
        let userPrifilePic = selectedImage.convertImageToBase64(image: selectedImage)
        
            let defaults = UserDefaults.standard
            let teacherStudentValue = defaults.string(forKey: "teacherStudentValue")
            if teacherStudentValue! == NSString(format:"%@","0") as String {
                self.userType = teacherStudentValue!
            } else if teacherStudentValue! == NSString(format:"%@","1") as String {
                self.userType = teacherStudentValue!
            }
        let signupInput = SignUpInputDomainModel.init(userType: self.userType, firstName: self.firstNameTextfield.text!, lastName: self.lastNameTextfield.text!, emailId: self.EmailTextfield.text!, password: self.passwordTextfield.text!, countryCode: self.countryCodeTextfield.text!, mobileNo: self.mobileNoTextfield.text!, dob: userBirthDate, gender: gender, profilePic: userPrifilePic, deviceToken: "APA91bEjHcRNwyoNZ4FPDmBFCx9p2W4tDnF6A1kcScrcmrYNEV_IO9_zF4Hidb04e3nEVZEObnxj3YLNOFM--Szj_IFdUiJ6rDYCZlPfsslLwf1ZTzMdoqeG2kWUkN9d2SHV5ZLDVc-z", osType: "iOS", latitude: "18.5077762", longitude: "73.7751809", location: "Pune", regType: "1", socialId: "")
        
        let APIDataManager: SignUpProtocols = SignUpApiDataManager()
            APIDataManager.signUp(data:signupInput,callback: { (result) in
                print(result)
                switch result {
                case .Failure(let error):
                    self.onUserSignUpFailed(error: error)
                case .Success(let data as SignUpOutputDomainModel):
                    do {
                        self.onUserSignUpSucceeded(data: data)
                    } catch {
                        self.onUserSignUpFailed(data: data)
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
        print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        if (buttonIndex==0)
        {
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
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 220))
        
        let label = UILabel(frame: CGRect(x: 0, y: 30, width: 290, height: 20))
        label.text = "Please enter OTP"
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
        OTPTextfield.keyboardType = UIKeyboardType.numberPad
        OTPTextfield.backgroundColor = UIColor.white
        OTPTextfield.textColor = UIColor.black
        OTPTextfield.layer.borderColor=UIColor(red: 247/255, green: 67/255, blue: 0/255, alpha: 1).cgColor
        OTPTextfield.layer.borderWidth = 1.0
        OTPTextfield.delegate=self;
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
        
        
        if textField == self.EmailTextfield {
            self.EmailTextfield.keyboardType = UIKeyboardType.emailAddress
        }
        if textField == self.mobileNoTextfield {
            var cell = SignupDateCell()
            cell = Bundle.main.loadNibNamed("SignupDateCell", owner: nil, options: nil)?[0] as! SignupDateCell
            cell.doneButton.addTarget(self, action: #selector(inputAccessoryViewDidFinish(button:)), for: .touchUpInside)
            let myToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            cell.frame = myToolbar.frame
            myToolbar.addSubview(cell)
            textField.inputAccessoryView = myToolbar;
            textField.inputAccessoryView?.backgroundColor=UIColor.darkGray
            
            self.mobileNoTextfield.keyboardType = UIKeyboardType.phonePad
            return true
        }
        if textField == self.locationTextfield {
            return false
        }
        if textField == OTPTextfield{
            
            return true
        }
        
        if textField == self.DOBTextfield {
            var cell = SignupDateCell()
            cell = Bundle.main.loadNibNamed("SignupDateCell", owner: nil, options: nil)?[0] as! SignupDateCell
            cell.doneButton.addTarget(self, action: #selector(inputAccessoryViewDidFinish(button:)), for: .touchUpInside)
            let myToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            cell.frame = myToolbar.frame
            myToolbar.addSubview(cell)
            textField.inputAccessoryView = myToolbar;
            textField.inputAccessoryView?.backgroundColor=UIColor.darkGray
            
            self.datePickerArray.removeAllObjects()
            self.monthPickerArray.removeAllObjects()
            self.yearPickerArray.removeAllObjects()
            
            self.pickerview.tag = textField.tag
            
            textField.text = "01/01/1950"
            for i in 1..<32{
                var dateLocal = NSString()
                if i<10 {
                    
                    dateLocal = NSString(format:"0%d" , i )
                }
                else
                {
                    dateLocal = NSString(format:"%d" , i )
                }
                self.datePickerArray .add(dateLocal)
            }
            for i in 1..<13 {
                var dateLocal = NSString()
                if (i<10) {
                    
                    dateLocal = NSString(format:"0%d" , i )
                }
                else
                {
                    dateLocal = NSString(format:"%d" , i )
                }
                self.monthPickerArray .add(dateLocal)
                
            }
            for i in 1950..<2017 {
                var dateLocal = NSString()
                
                dateLocal = NSString(format:"%d" , i )
                
                self.yearPickerArray .add(dateLocal)
                
            }
            self.pickerview.reloadAllComponents()
        }
        else
        {
            if textField == countryCodeTextfield{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "CountryCodeSelectionViewController")
                self.present(VC, animated: true, completion: nil)
                VC.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
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
        }
        else if component == 1
        {
            return self.monthPickerArray.count;
        }
        return self.yearPickerArray.count;
    }
    
    // MARK: pickerview delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            
            
            let title = NSString(format:"%@" , self.datePickerArray[row] as! CVarArg )
            return title as String
        }
        else if component == 1
        {
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
            
        }
        else if (component == 1)
        {
            month = String(describing: self.monthPickerArray[row])
            //            month = self.monthPickerArray[row] as! CVarArg as! String
            
        }
        else if (component == 2)
        {
            year = String(describing: self.yearPickerArray[row])
        }
        
        if date.characters.count>0 {
            let str = NSString(format:"%@/%@/%@", date ,month,year) as String
            DOBTextfield.text = str
        }
        else if month.characters.count>0{
            let str = NSString(format:"%@/%@/%@", date ,month,year) as String
            DOBTextfield.text = str
        }
        else if year.characters.count>0{
            let str = NSString(format:"%@/%@/%@", date ,month,year) as String
            DOBTextfield.text = str
        }
    }
    
    // MARK: inputAccessoryViewDidFinish method
    func inputAccessoryViewDidFinish(button : UIButton) {
        self.view.endEditing(true)
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
    
    // MARK: SignUp handelers for API Methods
    func onUserSignUpSucceeded(data: SignUpOutputDomainModel) {
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
        UserDefaults.standard.setValue( data.userId, forKey: "UserId")
        print("Hey you logged in: \(data.message)")
        self.dismissProgress()
        print("signup data %@",data.message)
        print("signup data %@",data.status)
        if data.status {
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
    
    func onUserSignUpFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to register the user")
    }
    
    func onUserSignUpFailed(data:SignUpOutputDomainModel) {
        self.dismissProgress()
        self.displayErrorMessage(message: data.message)
    }

    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
    
    // MARK: Get OTP Methods
    func onGetOTPSucceeded(data:OTPOutputDomainModel) {
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
            alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
                print("CLOSURE: Button '\(self.buttons[buttonIndex])' touched")
            }
            alertView.catchString(withString: "3")
            alertView.show()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onGetOTPFailed(error: EApiErrorType) {
        self.displayErrorMessage(message: "Failed to verify")
    }

    // MARK: Verify OTP Methods
    func onVerifyOTPResponce(data:OTPOutputDomainModel) {
        if data.status == true {
//            self.showSuccessMessage(message: data.message)
            OTPTextfield.resignFirstResponder()
            alertView.close()
            //push next VC
            let defaults = UserDefaults.standard
            let teacherStudentValue = defaults.string(forKey: "teacherStudentValue")
            
            if teacherStudentValue! == NSString(format:"%@","0") as String {
                let coachingDetailsVC : CoachingDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoachingDetailsVC") as UIViewController as! CoachingDetailsVC
                //coachingDetailsVC.userId = self.userId
                self.navigationController?.pushViewController(coachingDetailsVC, animated: true)
                
            } else if teacherStudentValue! == NSString(format:"%@","1") as String {
                let expertDetailsVC : ExpertDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpertDetailsVC") as UIViewController as! ExpertDetailsVC
               // expertDetailsVC.userId = self.userId
                self.navigationController?.pushViewController(expertDetailsVC, animated: true)
            }
        } else {
            self.displayErrorMessage(message: data.message)
            alertView.close()
        }
    }
    
    func onVerifyOTPFailed(error: EApiErrorType) {
        self.displayErrorMessage(message: "Failed to verify")
    }
    
}
