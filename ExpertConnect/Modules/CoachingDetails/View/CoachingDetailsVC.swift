//
//  CoachingDetailsVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class CoachingDetailsVC: UIViewController, AKSSegmentedSliderControlDelegate {

    var expertDetailsInputDomainModel: ExpertDetailsInputDomainModel!
    var signUpInputDomainModel: SignUpInputDomainModel!

    @IBOutlet var travelKmButton: UIButton!
    @IBOutlet var joinExpertConnectButton: UIButton!
    @IBOutlet var twoLineLabel: UILabel!
    @IBOutlet weak var onlineSkypeLabel: UILabel!
    
    @IBOutlet var homeCheckboxButton: UIButton!
    @IBOutlet var instituteCheckboxButton: UIButton!
    @IBOutlet var travelCheckboxButton: UIButton!
    @IBOutlet var otherLibraryCheckboxButton: UIButton!
    @IBOutlet var onlineSkypeCheckboxButton: UIButton!
    @IBOutlet var termsAndConditionsCheckboxButton: UIButton!
    @IBOutlet var customSliderView: UIView!
    
    let checkboxDeselected = UIImage(named:"unselected_check_boc")
    let checkboxSelected = UIImage(named:"selected_check_box")

    var userId: String = ""
    
    enum UIAlertControllerStyle : Int {
        case ActionSheet
        case Alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
       // print("signup data %@",signUpInputDomainModel.userType)
       // print("signup data %@",expertDetailsInputDomainModel.categoryId)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
//        self.twoLineLabel.font = UIFont (name: "Helvetica", size: 18)
        self.twoLineLabel.font =  UIFont(name: "Raleway-Light", size: 18)
        self.twoLineLabel.text = NSString(format: "%@", "Other - Library, Community center etc.") as String
  
        self.onlineSkypeLabel.font =  UIFont(name: "Raleway-Light", size: 18)
        self.onlineSkypeLabel.text = NSString(format: "%@", "Online - Skype, Messanger etc") as String

        self.navigationItem.title = "Coaching Details"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
       // self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 247/255, green: 67/255, blue: 0.0, alpha: 1.0)]
        self.travelKmButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        self.travelKmButton.setTitle("10", for: UIControlState.normal)
        
        self.homeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.instituteCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.travelCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.otherLibraryCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.onlineSkypeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.termsAndConditionsCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.setUpDistanceSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidAppear(_ animated: Bool) {
        self.setExpertConnectRedButtonTheme(button: self.travelKmButton)
        self.setExpertConnectRedButtonTheme(button: self.joinExpertConnectButton)
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
            
            let message = "Processing".localized(in: "Login")
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
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
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
    
    func setUpDistanceSlider() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        if(screenWidth == 320) {
            let tempXPosition : Float = Float((self.view.frame.width * 12)/100)
            let xPosition : Int = Int(tempXPosition)
            let yPosition = 20
            
            let tempWidth : Float = Float((self.view.frame.width * 88)/100)
            let width : Int = Int(tempWidth)
            let height = 20
            
            let tempSpaceBetweenPoints : Float = Float((self.view.frame.width * 14)/100)
            let spaceBetweenPoints = tempSpaceBetweenPoints
            let radiusPoint = 8
            let sliderLineWidth = 5
            
            var sliderConrolFrame: CGRect = CGRect.null
            sliderConrolFrame = CGRect(x: xPosition-4, y: (yPosition), width: width, height: height)
            //let sliderControl :  AKSSegmentedSliderControl = AKSSegmentedSliderControl(frame: sliderConrolFrame)
            let sliderControl :  AKSSegmentedSliderControl = AKSSegmentedSliderControl.init(frame: sliderConrolFrame)

            sliderControl.delegate = self
            sliderControl.move(to: 0)
            sliderControl.spaceBetweenPoints = Float(spaceBetweenPoints)
            sliderControl.radiusPoint = Float(radiusPoint)
            sliderControl.heightLine = Float(sliderLineWidth)
            sliderControl.numberOfPoints = 5
            self.customSliderView.addSubview(sliderControl)
        } else {

        let tempXPosition : Float = Float((self.view.frame.width * 12)/100)
        let xPosition : Int = Int(tempXPosition)
        let yPosition = 20
        
        let tempWidth : Float = Float((self.view.frame.width * 88)/100)
        let width : Int = Int(tempWidth)
        let height = 20
        
        let tempSpaceBetweenPoints : Float = Float((self.view.frame.width * 15)/100)
        let spaceBetweenPoints = tempSpaceBetweenPoints
        let radiusPoint = 8
        let sliderLineWidth = 5
        
        var sliderConrolFrame: CGRect = CGRect.null
        sliderConrolFrame = CGRect(x: xPosition-4, y: (yPosition), width: width, height: height)
       // let sliderControl :  AKSSegmentedSliderControl = AKSSegmentedSliderControl(frame: sliderConrolFrame)
        let sliderControl :  AKSSegmentedSliderControl = AKSSegmentedSliderControl.init(frame: sliderConrolFrame)
        sliderControl.delegate = self
        sliderControl.move(to: 0)
        sliderControl.spaceBetweenPoints = Float(spaceBetweenPoints)
        sliderControl.radiusPoint = Float(radiusPoint)
        sliderControl.heightLine = Float(sliderLineWidth)
        sliderControl.numberOfPoints = 5
        self.customSliderView.addSubview(sliderControl)
        }
    }
    
    func timeSlider(_ timeSlider: AKSSegmentedSliderControl! , didSelectPointAtIndex index:Int) -> Void  {
        print(index)
        var sliderIntValue = Int()
        if index == 0 {
            sliderIntValue = 10
        }
        if index == 1 {
            sliderIntValue = 20
        }
        if index == 2 {
            sliderIntValue = 30
        }
        if index == 3 {
            sliderIntValue = 40
        }
        if index == 4 {
            sliderIntValue = 50
        }
        self.travelKmButton.setTitle(NSString(format:"%d", sliderIntValue) as String , for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
