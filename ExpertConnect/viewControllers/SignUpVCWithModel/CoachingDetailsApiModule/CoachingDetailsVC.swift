//
//  CoachingDetailsVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//


import UIKit

class CoachingDetailsVC: UIViewController {
    
    @IBOutlet var travelKmButton: UIButton!
    @IBOutlet var joinExpertConnectButton: UIButton!
    @IBOutlet var twoLineLabel: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var homeCheckboxButton: UIButton!
    @IBOutlet var instituteCheckboxButton: UIButton!
    @IBOutlet var travelCheckboxButton: UIButton!
    @IBOutlet var otherLibraryCheckboxButton: UIButton!
    @IBOutlet var onlineSkypeCheckboxButton: UIButton!
    @IBOutlet var termsAndConditionsCheckboxButton: UIButton!
    var userId: String = ""

    let step: Float = 10
    
    enum UIAlertControllerStyle : Int {
        case ActionSheet
        case Alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.twoLineLabel.font = UIFont (name: "Helvetica", size: 18)
        self.twoLineLabel.text = NSString(format: "%@", "Other - Library, Community center") as String
        
        self.navigationItem.title = "Coaching Details"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 247/255, green: 67/255, blue: 0.0, alpha: 1.0)]
        slider.setThumbImage(UIImage(named: "slider_dot"), for: UIControlState.normal)
        self.travelKmButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        self.travelKmButton.setTitle("10", for: UIControlState.normal)
        
        self.homeCheckboxButton.setImage(UIImage(named: "unselected_check_boc"), for: UIControlState.normal)
        self.instituteCheckboxButton.setImage(UIImage(named: "unselected_check_boc"), for: UIControlState.normal)
        self.travelCheckboxButton.setImage(UIImage(named: "unselected_check_boc"), for: UIControlState.normal)
        self.otherLibraryCheckboxButton.setImage(UIImage(named: "unselected_check_boc"), for: UIControlState.normal)
        self.onlineSkypeCheckboxButton.setImage(UIImage(named: "unselected_check_boc"), for: UIControlState.normal)
        self.termsAndConditionsCheckboxButton.setImage(UIImage(named: "unselected_check_boc"), for: UIControlState.normal)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.addBackButtonOnNavigationBar()
        
    }
    func addBackButtonOnNavigationBar(){
        let settingsButton = UIButton()
        settingsButton.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        settingsButton.backgroundColor = UIColor.clear
        
        settingsButton.setImage(UIImage(named: "back_btn"), for: UIControlState.normal)
        settingsButton.addTarget(self, action: #selector(backButtonClicked(button:)), for: .touchUpInside)
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view1.backgroundColor = UIColor.clear
        view1.addSubview(settingsButton)
        
        
        let rightButtonItem = UIBarButtonItem(customView: view1)
        //        let barItems = Array[rightButtonItem]
        self.navigationItem.leftBarButtonItem = rightButtonItem
        
    }
    func backButtonClicked(button: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func expertConnectButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if (self.homeCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc") && self.instituteCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc") && self.travelCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc") && self.otherLibraryCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc") && self.onlineSkypeCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc")){
            self.alert(message: "Please check atleast one field")
        }
        if self.termsAndConditionsCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc"){
            self.alert(message: "Agree to Terms And Conditions")
        } else {
            var coachingVenue = [] as Array
            
            if self.homeCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
                coachingVenue.append("Home")
            }
            if self.instituteCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
                coachingVenue.append("Institute or Coaching Class")
            }
            if self.travelCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
                coachingVenue.append(String(format:"Travel %@ km",(self.travelKmButton.titleLabel?.text)!))
            }
            if self.otherLibraryCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
                coachingVenue.append("Other - Library, Community Center")
            }
            if self.onlineSkypeCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
                coachingVenue.append("Online - Skype, Messanger")
            }
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let coachingDetailsInput = CoachingDetailsInputDomainModel.init(userId: self.userId, coachingVenue: coachingVenue)
            
            var url = String()
            let defaults = UserDefaults.standard
            let teacherStudentValue = defaults.string(forKey: "teacherStudentValue")
            if teacherStudentValue! == NSString(format:"%@","0") as String {
                url = "register_student_coaching.php"
            }
            else if teacherStudentValue! == NSString(format:"%@","1") as String {
                url = "register_teacher_coaching.php"
            }
            
            let APIDataManager: CoachingDetailsProtocol = CoachingDetailsApiDataManager()
            APIDataManager.coachingDetails(endpoint: url, data:coachingDetailsInput,callback: { (result) in
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
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        let sliderIntValue:Int = Int(roundedValue)
        slider.setThumbImage(UIImage(named: "slider_dot"), for: UIControlState.normal)
        
        slider.setThumbImage(UIImage(named: "slider_dot"), for: UIControlState.highlighted)
        
        self.travelKmButton.setTitle(NSString(format:"%d", sliderIntValue) as String , for: UIControlState.normal)
        
    }
    @IBAction func homeCheckboxButtonClicked(_ sender: UIButton) {
        if self.homeCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc"){
            
            self.homeCheckboxButton.setImage(UIImage(named:"selected_check_box"), for: UIControlState.normal)
        }
        else if self.homeCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
            
            self.homeCheckboxButton.setImage(UIImage(named:"unselected_check_boc"), for: UIControlState.normal)
        }
    }
    @IBAction func instituteCheckboxButtonClicked(_ sender: UIButton) {
        if self.instituteCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc"){
            
            self.instituteCheckboxButton.setImage(UIImage(named:"selected_check_box"), for: UIControlState.normal)
        }
        else if self.instituteCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
            
            self.instituteCheckboxButton.setImage(UIImage(named:"unselected_check_boc"), for: UIControlState.normal)
        }
    }
    @IBAction func travelCheckboxButtonClicked(_ sender: UIButton) {
        if self.travelCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc"){
            
            self.travelCheckboxButton.setImage(UIImage(named:"selected_check_box"), for: UIControlState.normal)
        }
        else if self.travelCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
            
            self.travelCheckboxButton.setImage(UIImage(named:"unselected_check_boc"), for: UIControlState.normal)
        }
    }
    @IBAction func otherCheckboxButtonClicked(_ sender: UIButton) {
        if self.otherLibraryCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc"){
            
            self.otherLibraryCheckboxButton.setImage(UIImage(named:"selected_check_box"), for: UIControlState.normal)
        }
        else if self.otherLibraryCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
            
            self.otherLibraryCheckboxButton.setImage(UIImage(named:"unselected_check_boc"), for: UIControlState.normal)
        }
    }
    @IBAction func onlineCheckboxButtonClicked(_ sender: UIButton) {
        if self.onlineSkypeCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc"){
            
            self.onlineSkypeCheckboxButton.setImage(UIImage(named:"selected_check_box"), for: UIControlState.normal)
        }
        else if self.onlineSkypeCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
            
            self.onlineSkypeCheckboxButton.setImage(UIImage(named:"unselected_check_boc"), for: UIControlState.normal)
        }
    }
    @IBAction func termsAndConditionsCheckboxButtonClicked(_ sender: UIButton) {
        if self.termsAndConditionsCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"unselected_check_boc"){
            
            self.termsAndConditionsCheckboxButton.setImage(UIImage(named:"selected_check_box"), for: UIControlState.normal)
        }
        else if self.termsAndConditionsCheckboxButton.image(for: UIControlState.normal) == UIImage(named:"selected_check_box"){
            
            self.termsAndConditionsCheckboxButton.setImage(UIImage(named:"unselected_check_boc"), for: UIControlState.normal)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
