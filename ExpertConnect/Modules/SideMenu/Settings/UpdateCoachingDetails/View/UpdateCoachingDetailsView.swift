//
//  UpdateCoachingDetailsView.swift
//  ExpertConnect
//
//  Created by Redbytes on 19/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol CoachingDetailsDelegate {
    func updateCoachingDetailsSucceded(showAlert:Bool, message: String) -> Void
}
class UpdateCoachingDetailsView: UIViewController, AKSSegmentedSliderControlDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var expertDetailsInputDomainModel: ExpertDetailsInputDomainModel!
    var signUpInputDomainModel: SignUpInputDomainModel!
    
    var delegate:CoachingDetailsDelegate!
    
    @IBOutlet var travelKmButton: UIButton!
    @IBOutlet var joinExpertConnectButton: UIButton!
    @IBOutlet var twoLineLabel: UILabel!
    @IBOutlet weak var onlineSkypeLabel: UILabel!
    @IBOutlet var homeCheckboxButton: UIButton!
    @IBOutlet var instituteCheckboxButton: UIButton!
    @IBOutlet var travelCheckboxButton: UIButton!
    @IBOutlet var otherLibraryCheckboxButton: UIButton!
    @IBOutlet var onlineSkypeCheckboxButton: UIButton!
    @IBOutlet var customSliderView: UIView!
    @IBOutlet weak var distanceTextfield: UITextField!
    
    var sliderControl =  AKSSegmentedSliderControl()
    let checkboxDeselected = UIImage(named:"unselected_check_boc")
    let checkboxSelected = UIImage(named:"selected_check_box")
    var pickerviewExpertDetails = UIPickerView()
    var distanceArray = NSMutableArray()
    var userId: String = ""
    var userType: String = ""
    var coachingDetailsArray = NSMutableArray()
    
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
        self.getCoachingDetails()
        self.distanceArray.addObjects(from: ["10","20","30","40","50"])
        self.setupInputViewForTextField(textField: self.distanceTextfield)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.setExpertConnectRedButtonTheme(button: self.joinExpertConnectButton)
    }
    
    @IBAction func distanceButtonClicked(_ sender: UIButton) {
        self.distanceTextfield.becomeFirstResponder()
        self.pickerviewExpertDetails.reloadAllComponents()
    }
    
    //MARK: Get Coaching Details
    func getCoachingDetails() {
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
        let coachingArray = [String]()
        let message = "Getting Coaching Details".localized(in: "UpdateCoachingDetailsView")
        self.displayProgress(message: message)
        let updateCoachingDetailsInput = UpdateCoachingDetailsInputDomainModel.init(userId: self.userId, userType: self.userType, coachingVenue: coachingArray)
        let APIDataManager: UpdateCoachingDetailsProtocol = UpdateCoachingDetailsApiDataManager()
        APIDataManager.getCoachingDetails(data:updateCoachingDetailsInput,callback: { (result) in
            print(result)
            switch result {
            case.Failure(let error):
                self.onUserCoachingDetailsFailed(error: error)
            case.Success(let data as UpdateCoachingDetailsOutputDomainModel):
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
    
    func configureCoahingDetails() {
        self.clearCoachingDetails()
        for venue in self.coachingDetailsArray {
            let coachingVenuesDict: NSDictionary = venue as! NSDictionary
            let coachingVenue = coachingVenuesDict.value(forKey: "venue") as! String
            let split = coachingVenue.characters.split(separator: " ")
            let lastWordOfVenue = String(split.suffix(1).joined(separator: [" "]))
            let firstWordOfVenue = String(split.prefix(1).joined(separator: [" "]))
            if(coachingVenue == "Home") {
                self.homeCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
            }
            if(coachingVenue == "Institute or Coaching Class") {
                self.instituteCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
            }
            if(lastWordOfVenue == "Km") {
                self.travelCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
                self.travelKmButton.setTitle(firstWordOfVenue, for: UIControlState.normal)
                let distanceInKm:Int32? = Int32(firstWordOfVenue)
                let sliderValue:Int32? = distanceInKm!/10
                sliderControl.move(to: sliderValue! - 1)
            }
            if(coachingVenue == "Other - Library, Community Center etc.") {
                self.otherLibraryCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
            }
            if(coachingVenue == "Online - Skype, Messanger") {
                self.onlineSkypeCheckboxButton.setImage(checkboxSelected, for: UIControlState.normal)
            }
        }
    }
    
    func clearCoachingDetails() {
        self.homeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.instituteCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.travelCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.otherLibraryCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.onlineSkypeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
    }
    
    //MARK: Join ExprtConnect
    @IBAction func expertConnectButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "UpdateCoachingDetailsView")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.homeCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected &&
            self.instituteCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected &&
            self.travelCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected &&
            self.otherLibraryCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected &&
            self.onlineSkypeCheckboxButton.image(for: UIControlState.normal) == checkboxDeselected) {
            let message = "Please Check Atleast One Field".localized(in: "UpdateCoachingDetailsView")
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
            
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
            
            let message = "Updating Coaching Details".localized(in: "UpdateCoachingDetailsView")
            self.displayProgress(message: message)
            
            let updateCoachingDetailsInput = UpdateCoachingDetailsInputDomainModel.init(userId: self.userId, userType: self.userType, coachingVenue: coachingVenue)
            let APIDataManager: UpdateCoachingDetailsProtocol = UpdateCoachingDetailsApiDataManager()
            APIDataManager.updateCoachingDetails(data:updateCoachingDetailsInput,callback: { (result) in
                print(result)
                switch result {
                case.Failure(let error):
                    self.onUpdateCoachingDetailsFailed(error: error)
                case.Success(let data as UpdateCoachingDetailsOutputDomainModel):
                    do {
                        self.onUpdateCoachingDetailsSucceeded(data: data)
                    } catch {
                        self.onUpdateCoachingDetailsFailed(error: EApiErrorType.InternalError)
                    }
                default:
                    break
                }
            })
        }
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
    
    // MARK: CoachingDetail Delegate
    func onUserCoachingDetailsSucceeded(data: UpdateCoachingDetailsOutputDomainModel) {
        self.dismissProgress()
        print("signup data %@",data.message)
        print("signup data %@",data.status)
        self.coachingDetailsArray = NSMutableArray.init(array: data.coachingDetails as! [Any])
        self.configureCoahingDetails()
    }
    
    func onUserCoachingDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.showStylishSuccessMessage(message: "No coaching details found in the database")
    }
    
    func onUpdateCoachingDetailsSucceeded(data: UpdateCoachingDetailsOutputDomainModel) {
        self.dismissProgress()
        print("signup data %@",data.message)
        print("signup data %@",data.status)
        if data.status {
            self.delegate.updateCoachingDetailsSucceded(showAlert: true, message: "Your coaching details updated successfully".localized(in: "UpdateCoachingDetailsView"))
            self.view.endEditing(true)
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onUpdateCoachingDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to update user coaching details")
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
                //self.distanceTextfield.text = title
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
