
//
//  TeacherFilter.swift
//  ExpertConnect
//
//  Created by Nadeem on 17/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos
protocol filteredTeacherListTransferProtocol {
    func filterTeachersDataSucceeded(filteredTeacherListArray:NSArray, isFiltered:Bool) -> Void
    func filterTeachersDataFailed(isFiltered:Bool) -> Void
}

class TeacherFilter: UIViewController, AKSSegmentedSliderControlDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var delegate:filteredTeacherListTransferProtocol!
    let emptyArray = NSArray()
    
    var expertDetailsInputDomainModel: ExpertDetailsInputDomainModel!
    var signUpInputDomainModel: SignUpInputDomainModel!
    var pickerviewExpertDetails = UIPickerView()
    var distanceArray = NSMutableArray()
    
    @IBOutlet var travelKmButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var twoLineLabel: UILabel!
    @IBOutlet weak var onlineSkypeLabel: UILabel!
    @IBOutlet var homeCheckboxButton: UIButton!
    @IBOutlet var instituteCheckboxButton: UIButton!
    @IBOutlet var travelCheckboxButton: UIButton!
    @IBOutlet var otherLibraryCheckboxButton: UIButton!
    @IBOutlet var onlineSkypeCheckboxButton: UIButton!
    @IBOutlet var customSliderView: UIView!
    @IBOutlet weak var distanceTextfield: UITextField!
    
    let checkboxDeselected = UIImage(named:"unselected_check_boc")
    let checkboxSelected = UIImage(named:"selected_check_box")
    var userId = String()
    var categoryId = String()
    var subCategoryId = String()
    var expertLevel = String()
    enum UIAlertControllerStyle : Int {
        case ActionSheet
        case Alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.twoLineLabel.font =  UIFont(name: "Raleway-Light", size: 18)
        self.twoLineLabel.text = NSString(format: "%@", "Other - Library, Community center etc.") as String
        self.onlineSkypeLabel.font =  UIFont(name: "Raleway-Light", size: 18)
        self.onlineSkypeLabel.text = NSString(format: "%@", "Online - Skype, Messanger etc") as String
        self.navigationItem.title = "Filters"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.travelKmButton.setTitle("10", for: UIControlState.normal)
        self.homeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.instituteCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.travelCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.otherLibraryCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.onlineSkypeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.distanceArray.addObjects(from: ["10","20","30","40","50"])
        self.setupInputViewForTextField(textField: self.distanceTextfield)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.addRightNavigationButtonsOnNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.setExpertConnectRedButtonTheme(button: self.applyButton)
    }
    
    @IBAction func distanceButtonClicked(_ sender: UIButton) {
        self.distanceTextfield.becomeFirstResponder()
        self.pickerviewExpertDetails.reloadAllComponents()
    }
    
    //MARK: Add Clear Button method
    func addRightNavigationButtonsOnNavigationBar(){
        let clearButton = UIButton()
        clearButton.frame = CGRect(x: 0, y: 0, width: 55, height: 35)
        clearButton.backgroundColor = UIColor.clear
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(UIColor.ExpertConnectRed, for: .normal)
        clearButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 19)
        clearButton.addTarget(self, action: #selector(clearButtonClicked(button:)), for: .touchUpInside)
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 35))
        view1.backgroundColor = UIColor.clear
        view1.addSubview(clearButton)
        let rightButtonItem1 = UIBarButtonItem(customView: view1)
        
        let verticalLineView = UIView()
        verticalLineView.frame = CGRect(x: -12, y: 0, width: 1, height: 35)
        verticalLineView.backgroundColor = UIColor.ExpertConnectRed
        
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
        view1.backgroundColor = UIColor.clear
        view1.addSubview(verticalLineView)
        let rightButtonItem2 = UIBarButtonItem(customView: view2)
        
        self.navigationItem.rightBarButtonItems = [rightButtonItem1,rightButtonItem2]
    }
    
    //MARK: Clear Button Clicked method
    func clearButtonClicked(button: UIButton) {
        /*
         self.view.endEditing(true)
         self.delegate.filterTeachersDataSucceeded(filteredTeacherListArray: emptyArray, isFiltered: false)
         self.navigationController?.popViewController(animated: true)
         */
    }
    
    //MARK: Apply Button method
    @IBAction func applyButtonClicked(_ sender: UIButton) {
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
            
            if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
                self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            } else {
                self.userId = "0"
            }
            let TeacherFilterModel = TeacherFilterDomainModel.init(userId: self.userId, categoryId: self.categoryId, subCategoryId: self.subCategoryId, level: self.expertLevel, coachingVenue: coachingVenue)
            
            let message = "Processing".localized(in: "Login")
            self.displayProgress(message: message)
            
            let APIDataManager : TeacherFilterProtocols = TeacherFilterApiDataManager()
            APIDataManager.getTeacherFilterList(data: TeacherFilterModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onGetTeacherFilterListFailed(error: error)
                case .Success(let data as TeacherFilterOutputDomainModel):
                    do {
                        self.onGetTeacherFilterListSucceeded(data: data)
                    } catch {
                        self.onGetTeacherFilterListFailed(data: data)
                    }
                default:
                    break
                }
            })
        }
    }
    
    //MARK: All Checkbox Button  Click Methods
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
    
    // MARK: TeacherFilter Response methods
    func onGetTeacherFilterListSucceeded(data: TeacherFilterOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.delegate.filterTeachersDataSucceeded(filteredTeacherListArray: data.categories, isFiltered: true)
            _ = self.navigationController?.popViewController(animated: true)
        }
        else{
            // self.displayErrorMessage(message: data.message)
            self.delegate.filterTeachersDataFailed(isFiltered: true)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onGetTeacherFilterListFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.delegate.filterTeachersDataFailed(isFiltered: true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func onGetTeacherFilterListFailed(data:TeacherFilterOutputDomainModel) {
        self.dismissProgress()
        //self.displayErrorMessage(message: data.message)
        self.delegate.filterTeachersDataFailed(isFiltered: true)
        _ = self.navigationController?.popViewController(animated: true)
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
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
