//
//  CoachingDetailsVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class CoachingDetailsVC: UIViewController, AKSSegmentedSliderControlDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var expertDetailsInputDomainModel: ExpertDetailsInputDomainModel!
    var signUpInputDomainModel: SignUpInputDomainModel!
    
    @IBOutlet var travelKmButton: UIButton!
    @IBOutlet var joinExpertConnectButton: UIButton!
    @IBOutlet var twoLineLabel: UILabel!
    @IBOutlet weak var onlineSkypeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet var homeCheckboxButton: UIButton!
    @IBOutlet var instituteCheckboxButton: UIButton!
    @IBOutlet var travelCheckboxButton: UIButton!
    @IBOutlet var otherLibraryCheckboxButton: UIButton!
    @IBOutlet var onlineSkypeCheckboxButton: UIButton!
    @IBOutlet var termsAndConditionsCheckboxButton: UIButton!
    @IBOutlet weak var distanceTextfield: UITextField!
    
    let checkboxDeselected = UIImage(named:"unselected_check_boc")
    let checkboxSelected = UIImage(named:"selected_check_box")
    var pickerviewExpertDetails = UIPickerView()
    var distanceArray = NSMutableArray()
    var userId: String = ""
    enum UIAlertControllerStyle : Int {
        case ActionSheet
        case Alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = "Coaching Details"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        self.twoLineLabel.font =  UIFont(name: "Raleway-Light", size: 18)
        self.twoLineLabel.text = NSString(format: "%@", "Other - Library, Community center etc.") as String
        self.onlineSkypeLabel.font =  UIFont(name: "Raleway-Light", size: 18)
        self.onlineSkypeLabel.text = NSString(format: "%@", "Online - Skype, Messanger etc") as String
        self.travelKmButton.setTitle("10", for: UIControlState.normal)
        
        self.homeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.instituteCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.travelCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.otherLibraryCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.onlineSkypeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.termsAndConditionsCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.distanceArray.addObjects(from: ["10","20","30","40","50"])
        self.setupInputViewForTextField(textField: self.distanceTextfield)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setExpertConnectRedButtonTheme(button: self.joinExpertConnectButton)
    }
    
    @IBAction func distanceButtonClicked(_ sender: UIButton) {
        self.distanceTextfield.becomeFirstResponder()
        self.pickerviewExpertDetails.reloadAllComponents()
    }
    
    //MARK: Join ExprtConnect
    @IBAction func expertConnectButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "CoachingDetails")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.homeCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected && self.instituteCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected && self.travelCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected && self.otherLibraryCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected && self.onlineSkypeCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected) {
            let message = "Please Check Atleast One Field".localized(in: "CoachingDetails")
            self.displayErrorMessage(message: message)
            return
        }
        if self.termsAndConditionsCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected {
            let message = "Agree To Terms And Conditions".localized(in: "CoachingDetails")
            self.displayErrorMessage(message: message)
            return
        }
        else {
            var coachingVenue = [] as Array
            if self.homeCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
                coachingVenue.append("Home")
            }
            if self.instituteCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
                coachingVenue.append("Institute or Coaching Class")
            }
            if self.travelCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
                coachingVenue.append(String(format:"%@ Km",(self.travelKmButton.titleLabel?.text)!))
            }
            if self.otherLibraryCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
                coachingVenue.append("Other - Library, Community Center etc.")
            }
            if self.onlineSkypeCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
                coachingVenue.append("Online - Skype, Messanger")
            }
            
            var registerUserInputDomainModel: RegisterUserInputDomainModel?
            var url = String()
            let defaults = UserDefaults.standard
            let teacherStudentValue = defaults.string(forKey: "teacherStudentValue")
            if teacherStudentValue! == NSString(format:"%@","3") as String {
                //Teacher Details
                url = "user_register.php"
                registerUserInputDomainModel = RegisterUserInputDomainModel.init(userType: signUpInputDomainModel.userType,
                                                                                 firstName: signUpInputDomainModel.firstName,
                                                                                 lastName: signUpInputDomainModel.lastName,
                                                                                 emailId: signUpInputDomainModel.emailId,
                                                                                 password: signUpInputDomainModel.password,
                                                                                 countryCode: signUpInputDomainModel.countryCode,
                                                                                 mobileNo: signUpInputDomainModel.mobileNo,
                                                                                 dob: signUpInputDomainModel.dob,
                                                                                 gender: signUpInputDomainModel.gender,
                                                                                 profilePic: signUpInputDomainModel.profilePic,
                                                                                 deviceToken: signUpInputDomainModel.deviceToken,
                                                                                 osType: signUpInputDomainModel.osType,
                                                                                 latitude: signUpInputDomainModel.latitude,
                                                                                 longitude: signUpInputDomainModel.longitude,
                                                                                 location: signUpInputDomainModel.location,
                                                                                 regType: signUpInputDomainModel.regType,
                                                                                 socialId: signUpInputDomainModel.socialId,
                                                                                 categoryId: expertDetailsInputDomainModel.categoryId,
                                                                                 subCategoryId: expertDetailsInputDomainModel.subCategoryId,
                                                                                 qualification: expertDetailsInputDomainModel.qualification,
                                                                                 about: expertDetailsInputDomainModel.about,
                                                                                 basePrice: expertDetailsInputDomainModel.basePrice,
                                                                                 beginner : expertDetailsInputDomainModel.beginner,
                                                                                 intermediate : expertDetailsInputDomainModel.intermediate,
                                                                                 advance : expertDetailsInputDomainModel.advance,
                                                                                 coachingVenue : coachingVenue)
                
            }
            else if teacherStudentValue! == NSString(format:"%@","2") as String {
                //Student Details
                url = "user_register.php"
                registerUserInputDomainModel = RegisterUserInputDomainModel.init(userType: signUpInputDomainModel.userType,
                                                                                 firstName: signUpInputDomainModel.firstName,
                                                                                 lastName: signUpInputDomainModel.lastName,
                                                                                 emailId: signUpInputDomainModel.emailId,
                                                                                 password: signUpInputDomainModel.password,
                                                                                 countryCode: signUpInputDomainModel.countryCode,
                                                                                 mobileNo: signUpInputDomainModel.mobileNo,
                                                                                 dob: signUpInputDomainModel.dob,
                                                                                 gender: signUpInputDomainModel.gender,
                                                                                 profilePic: signUpInputDomainModel.profilePic,
                                                                                 deviceToken: signUpInputDomainModel.deviceToken,
                                                                                 osType: signUpInputDomainModel.osType,
                                                                                 latitude: signUpInputDomainModel.latitude,
                                                                                 longitude: signUpInputDomainModel.longitude,
                                                                                 location: signUpInputDomainModel.location,
                                                                                 regType: signUpInputDomainModel.regType,
                                                                                 socialId: signUpInputDomainModel.socialId,
                                                                                 categoryId: "",
                                                                                 subCategoryId: "",
                                                                                 qualification: "",
                                                                                 about: "",
                                                                                 basePrice: "",
                                                                                 beginner : [],
                                                                                 intermediate : [],
                                                                                 advance : [],
                                                                                 coachingVenue : coachingVenue)
                
                
            }
            
            let message = "Registering to ExpertConnect".localized(in: "CoachingDetails")
            self.displayProgress(message: message)
            
            let APIDataManager: CoachingDetailsProtocol = CoachingDetailsApiDataManager()
            APIDataManager.coachingDetails(endpoint: url, data:registerUserInputDomainModel!,callback: { (result) in
                print(result)
                switch result {
                case.Failure(let error):
                    self.onUserCoachingDetailsFailed(error: error)
                case.Success(let data as CoachingDetailsOutputDomainModel):
                    do {
                        self.onUserCoachingDetailsSucceeded(data: data)
                    } catch {
                        self.onUserCoachingDetailsFailed(error: EApiErrorType.InternalError)
                    }
                default:
                    break
                }
            })
        }
    }
    
    func showHomeController() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController()
    }
    
    @IBAction func homeCheckboxButtonClicked(_ sender: UIButton) {
        if self.homeCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected {
            self.homeCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
        } else if self.homeCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
            self.homeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        }
    }
    
    @IBAction func instituteCheckboxButtonClicked(_ sender: UIButton) {
        if self.instituteCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected {
            self.instituteCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
        } else if self.instituteCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
            self.instituteCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        }
    }
    
    @IBAction func travelCheckboxButtonClicked(_ sender: UIButton) {
        if self.travelCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected {
            self.travelCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
        } else if self.travelCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
            self.travelCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        }
    }
    
    @IBAction func otherCheckboxButtonClicked(_ sender: UIButton) {
        if self.otherLibraryCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected {
            self.otherLibraryCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
        } else if self.otherLibraryCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
            self.otherLibraryCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        }
    }
    
    @IBAction func onlineCheckboxButtonClicked(_ sender: UIButton) {
        if self.onlineSkypeCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected {
            self.onlineSkypeCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
        } else if self.onlineSkypeCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
            self.onlineSkypeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        }
    }
    
    @IBAction func termsAndConditionsCheckboxButtonClicked(_ sender: UIButton) {
        if self.termsAndConditionsCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected {
            self.termsAndConditionsCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
        } else if self.termsAndConditionsCheckboxButton.image(for: UIControlState.normal) == checkboxSelected {
            self.termsAndConditionsCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        }
    }
    
    // MARK: CoachingDetail Delegate
    func onUserCoachingDetailsSucceeded(data: CoachingDetailsOutputDomainModel) {
        self.dismissProgress()
        print("signup data %@",data.message)
        print("signup data %@",data.status)
        let userInfo = ["CoachingDetailsOutputDomainModel": data] as [String: Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.ExpertConnect.Signup"), object: nil, userInfo:userInfo)
        UserDefaults.standard.set(true, forKey: "UserLoggedInStatus")
        let userId = data.userId as String
        UserDefaults.standard.set(userId, forKey: "UserId")
        let location = String(data.location)
        UserDefaults.standard.set(location, forKey: "Location")
        let userType = String(data.userType)
        UserDefaults.standard.set(userType, forKey: "teacherStudentValue")
        let notificationStatus = String(data.notificationStatus)
        if(notificationStatus == "1") {
            UserDefaults.standard.set(true, forKey: "PushNotificationStatus")
        } else if(notificationStatus == "0") {
            UserDefaults.standard.set(false, forKey: "PushNotificationStatus")
        }
        let currentPassword = String(data.currentPassword)
        UserDefaults.standard.set(currentPassword, forKey: "CurrentPassword")
        let firstname = String(data.firstName)
        UserDefaults.standard.set(firstname, forKey: "firstname")
        let lastname = String(data.lastName)
        UserDefaults.standard.set(lastname, forKey: "lastname")
        let email = String(data.email)
        UserDefaults.standard.set(email, forKey: "email_id")
        let dob = String(data.dob)
        UserDefaults.standard.set(dob, forKey: "dob")
        self.navigateBackToHomeViewController()
    }
    
    func onUserCoachingDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to register the user")
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateBackToHomeViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController()
    }
    
    func setupInputViewForTextField(textField: UITextField) {
        let str = NSString(format:"%@", "0")
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "pickerviewExpertDetailsCoaching")
        self.pickerviewExpertDetails.delegate = self
        self.pickerviewExpertDetails.dataSource = self
        self.pickerviewExpertDetails.backgroundColor = UIColor.white
        self.pickerviewExpertDetails.tag = 101
        textField.inputView = pickerviewExpertDetails
        var cell = SignupDateCell()
        cell = Bundle.main.loadNibNamed("SignupDateCell", owner: nil, options: nil)?[0] as! SignupDateCell
        cell.doneButton.addTarget(self, action: #selector(inputAccessoryViewDidFinishForDoneButton(button:)), for: .touchUpInside)
        cell.cancelButton.addTarget(self, action: #selector(inputAccessoryViewDidFinishForDoneButton(button:)), for: .touchUpInside)
        cell.doneButton.tag = 101
        cell.cancelButton.tag = 102
        cell.centerLabel.textColor = UIColor.ExpertConnectBlack
        cell.centerLabel.font = UIFont(name: "Raleway-Light", size: 18)
        let myToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        cell.frame = myToolbar.frame
        myToolbar.addSubview(cell)
        textField.inputAccessoryView = myToolbar;
        textField.inputAccessoryView?.backgroundColor=UIColor.darkGray
        if textField == self.distanceTextfield {
            cell.centerLabel.text = "Distance in Km"
        }
    }
    
    // MARK: pickerview datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.pickerviewExpertDetails.tag == 101 {
            return distanceArray.count
        }
        return 0
    }
    
    // MARK: pickerview delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = String()
        if self.pickerviewExpertDetails.tag == 101 {
            title = self.distanceArray[row] as! String
        }
        return title as String
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        if self.pickerviewExpertDetails.tag == 101 {
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.ExpertConnectBlack
            pickerLabel.text = self.distanceArray[row] as? String
            pickerLabel.font = UIFont(name: "Raleway-Light", size: 18) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.ExpertConnectBlack
        pickerLabel.text = ""
        pickerLabel.font = UIFont(name: "Raleway-Light", size: 18) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let str = NSString(format:"%d", row)
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "pickerviewExpertDetailsCoaching")
    }
    
    func inputAccessoryViewDidFinishForDoneButton(button : UIButton) {
        self.view.endEditing(true)
        if button.tag == 101 {
            let defaults = UserDefaults.standard
            let pickerviewExpertDetails = defaults.string(forKey: "pickerviewExpertDetailsCoaching")
            let intValue = Int(pickerviewExpertDetails!)
            
            if self.pickerviewExpertDetails.tag == 101 {
                let title = self.distanceArray[intValue!] as! String
                self.travelKmButton.setTitle(NSString(format:"%@", title) as String , for: UIControlState.normal)
                let str = NSString(format:"%@", "0")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "pickerviewExpertDetailsCoaching")
                self.pickerviewExpertDetails.reloadAllComponents()
                self.pickerviewExpertDetails.selectRow(0, inComponent: 0, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
