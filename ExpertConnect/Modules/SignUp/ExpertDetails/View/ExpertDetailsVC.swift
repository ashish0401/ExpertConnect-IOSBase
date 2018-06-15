//
//  ExpertDetailsVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

@objc protocol AddExpertiseProtocol {
    @objc optional func addExpertiseSucceded(showAlert:Bool) -> Void
    @objc optional func upgradeSucceded(showAlert:Bool, message: String) -> Void
}

class ExpertDetailsVC: UIViewController,  UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AKSSegmentedSliderControlDelegate, CustomIOS7AlertViewDelegate {
    
    var delegate:AddExpertiseProtocol!
    
    var signUpInputDomainModel: SignUpInputDomainModel!
    var expertDetailsInputDomainModel: ExpertDetailsInputDomainModel!
    var beginnerArray = ["Beginner"]
    var intermediateArray = ["Intermediate"]
    var advanceArray = ["Advance"]
    var isAddExpertise: Bool = false
    var isUpgradeToTeacher: Bool = false
    var isUpgradeToTeacherFromBlogView: Bool = false
    var userId: String = ""
    var userType: String = ""
    var pickerviewExpertDetails = UIPickerView()
    let backItem = UIButton()
    var sliderIntValue = Int()
    var mainCategoryValue = String()
    var subCategoryValue = String()
    var beginnerMiddleValue = String()
    var intermediateMiddleValue = String()
    var advanceMiddleValue = String()
    var categoryArray: NSArray = [NSDictionary]() as NSArray
    var subCategoryArray: NSArray = [NSDictionary]() as NSArray
    let alertView = CustomIOS7AlertView()
    let buttonTitleArray = ["SUBMIT"]
    var expertLevelSliderView = UIView()
    var cell = ExpertLevelCell()
    var subscriptionLevelString = String()

    enum UIAlertControllerStyle : Int {
        case ActionSheet
        case Alert
    }
    
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var mainCategoryTextfield: UITextField!
    @IBOutlet var subCategoryTextfield: UITextField!
    @IBOutlet var qualificationTextfield: UITextField!
    @IBOutlet var mainCategoryButton: UIButton!
    @IBOutlet var subCategoryButton: UIButton!
    @IBOutlet weak var chargesLabel: UILabel!
    @IBOutlet weak var chargesTextField: UITextField!
    @IBOutlet weak var intermediateTextField: UITextField!
    @IBOutlet weak var advanceTextField: UITextField!
    @IBOutlet weak var beginerTextField: UITextField!
    @IBOutlet weak var beginnerButton: UIButton!
    @IBOutlet weak var intermediateButton: UIButton!
    @IBOutlet weak var advanceButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet weak var beginerPriceLabel: UILabel!
    @IBOutlet weak var intermediatePriceLabel: UILabel!
    @IBOutlet weak var advancePriceLabel: UILabel!
    @IBOutlet weak var advanceLabel: UILabel!
    @IBOutlet weak var intermediateLabel: UILabel!
    @IBOutlet weak var beginerLabel: UILabel!
    @IBOutlet weak var textviewBackgroundView: UIView!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet var customSliderView: UIView!
    @IBOutlet var expertLevelView: UIView!
    @IBOutlet weak var categoryBaseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollview.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        let size = CGSize(width: 600, height: 800)
        self.scrollview.contentSize = size
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = "Expert Details"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.textview.textColor = UIColor.ExpertConnectBlack
        
//        self.beginerTextField.adjustsFontSizeToFitWidth = true
//        self.intermediateTextField.adjustsFontSizeToFitWidth = true
//        self.advanceTextField.adjustsFontSizeToFitWidth = true
        
//        self.intermediateTextField.isEnabled = false
//        self.advanceTextField.isEnabled = false
        
        self.textview.text = "Write about yourself..."
        self.textview.textColor = UIColor.lightGray
        //setup UI
        self.setExpertConnectRedButtonTheme(button: self.nextButton)
        
        self.setExpertConnectTextFieldTheme(textfield: self.mainCategoryTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.subCategoryTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.qualificationTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.chargesTextField)
        
//        self.setCustomAlertTextFieldTheme(textfield: self.beginerTextField)
//        self.setExpertConnectDisabledTextFieldTheme(textfield: self.intermediateTextField)
//        self.setExpertConnectDisabledTextFieldTheme(textfield: self.advanceTextField)
        
//        self.beginerLabel.textColor = UIColor.ExpertConnectRed
//        self.beginerPriceLabel.textColor = UIColor.ExpertConnectRed
//        self.beginerTextField.textColor = UIColor.ExpertConnectRed
//        self.intermediateLabel.textColor = UIColor.ExpertConnectDisabled
//        self.intermediatePriceLabel.textColor = UIColor.ExpertConnectDisabled
//        self.advanceLabel.textColor = UIColor.ExpertConnectDisabled
//        self.advancePriceLabel.textColor = UIColor.ExpertConnectDisabled
        
        self.mainCategoryTextfield.setLeftPaddingPoints(10)
        self.subCategoryTextfield.setLeftPaddingPoints(10)
        self.qualificationTextfield.setLeftPaddingPoints(10)
        self.chargesLabel.sizeToFit()
        
        //API
        self.callMainCategoryListApi()
        self.setupInputViewForTextField(textField: self.mainCategoryTextfield)
        self.setupInputViewForTextField(textField: self.subCategoryTextfield)
        
        if(isAddExpertise) {
            self.activateTextualCancelIcon()
            self.activateTextualAddIcon(delegate: self)
            self.nextButton.isHidden = true
        } else if(isUpgradeToTeacher) {
            self.activateBackIcon()
            self.nextButton.isHidden = false
            //self.navigationItem.title = "Upgrade To Teacher"
            self.nextButton.setTitle("UPGRADE",for: .normal)
        } else if(isUpgradeToTeacherFromBlogView) {
            self.activateTextualCancelIcon()
            self.nextButton.isHidden = false
            //self.navigationItem.title = "Upgrade To Teacher"
            self.nextButton.setTitle("UPGRADE",for: .normal)
        } else {
            self.activateBackIcon()
            self.nextButton.isHidden = false
            self.nextButton.setTitle("NEXT",for: .normal)
        }
//        self.configureExpertLevelButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.resetExpertDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.setExpertConnectShadowTheme(view: self.categoryBaseView)
        self.setExpertConnectShadowTheme(view: self.expertLevelView)
        self.setExpertConnectShadowTheme(view: self.textviewBackgroundView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isAddExpertise = false
        isUpgradeToTeacher = false
        isUpgradeToTeacherFromBlogView = false
    }
    
    @IBAction func mainCategoryButtonClicked(_ sender: UIButton) {
        
    }
    @IBAction func subCategoryButtonClicked(_ sender: UIButton) {
        
    }
    
//    func configureExpertLevelButton() {
//        self.beginnerButton.setImage(UIImage(named:"selected_beginner_btn"), for: UIControlState.normal)
//        self.intermediateButton.setImage(UIImage(named:"unselected_intermediate_btn"), for: UIControlState.normal)
//        self.advanceButton.setImage(UIImage(named:"unselected_advance_btn"), for: UIControlState.normal)
//        self.beginnerButton.setTitleColor(.ExpertConnectRed, for: .normal)
//        self.intermediateButton.setTitleColor(.ExpertConnectBlack, for: .normal)
//        self.advanceButton.setTitleColor(.ExpertConnectBlack, for: .normal)
//    }
    
    func callMainCategoryListApi() {
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Processing".localized(in: "Login")
        self.displayProgress(message: message)
        let APIDataManager: HomeProtocols = HomeAPIDataManager()
        APIDataManager.getCategoryDetails(callback: { (result) in
            switch result {
            case .Failure(let error):
                self.onMainCategoryListFailed(error: error)
            case .Success(let data as HomeOutputDomainModel):
                do {
                    self.onMainCategoryListSucceeded(data: data)
                } catch {
                    self.onMainCategoryListFailed(error: EApiErrorType.InternalError)
                }
            default:
                break
            }
        })
    }
    
    func resetExpertDetails() {
        self.beginnerArray.removeAll()
        self.intermediateArray.removeAll()
        self.advanceArray.removeAll()
        
        self.beginnerArray.append("Beginner")
        self.intermediateArray.append("Intermediate")
        self.advanceArray.append("Advance")
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.mainCategoryTextfield.text == nil || (self.mainCategoryTextfield.text?.characters.count)! == 0){
            let message = "Please Select Main Category".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.subCategoryTextfield.text == nil || (self.subCategoryTextfield.text?.characters.count)! == 0){
            let message = "Please Select Sub Category".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.chargesTextField.text == nil || (self.chargesTextField.text?.characters.count)! == 0) {
            let message = "Please Enter Your Charges".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.chargesTextField.text == "0" || self.chargesTextField.text == "00" || self.chargesTextField.text == "000" || self.chargesTextField.text == "0000") {
            let message = "Your Charges Cannot Be Zero".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        
//        if (sliderIntValue == 0) {
//            if (self.beginerTextField.text == nil || (self.beginerTextField.text?.characters.count)! == 0) {
//                let message = "Please Enter Beginner Lectures Required".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            if (self.beginerTextField.text == "0" || self.beginerTextField.text == "00" || self.beginerTextField.text == "000") {
//                let message = "Beginner Lectures Cannot Be Zero".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            
//        }
//        if (sliderIntValue == 1) {
//            if (self.beginerTextField.text == nil || (self.beginerTextField.text?.characters.count)! == 0) {
//                let message = "Please Enter Beginner Lectures Required".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            if (self.beginerTextField.text == "0" || self.beginerTextField.text == "00" || self.beginerTextField.text == "000") {
//                let message = "Beginner Lectures Cannot Be Zero".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            
//            if (self.intermediateTextField.text == nil || (self.intermediateTextField.text?.characters.count)! == 0){
//                let message = "Please Enter Intermediate Lectures Required".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            if (self.intermediateTextField.text == "0" || self.intermediateTextField.text == "00" || self.intermediateTextField.text == "000") {
//                let message = "Intermediate Lectures Cannot Be Zero".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            
//        }
//        if (sliderIntValue == 2) {
//            if (self.beginerTextField.text == nil || (self.beginerTextField.text?.characters.count)! == 0) {
//                let message = "Please Enter Beginner Lectures Required".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            if (self.beginerTextField.text == "0" || self.beginerTextField.text == "00" || self.beginerTextField.text == "000") {
//                let message = "Beginner Lectures Cannot Be Zero".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            
//            if (self.intermediateTextField.text == nil || (self.intermediateTextField.text?.characters.count)! == 0){
//                let message = "Please Enter Intermediate Lectures Required".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            if (self.intermediateTextField.text == "0" || self.intermediateTextField.text == "00" || self.intermediateTextField.text == "000") {
//                let message = "Intermediate Lectures Cannot Be Zero".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            
//            if (self.advanceTextField.text == nil || (self.advanceTextField.text?.characters.count)! == 0) {
//                let message = "Please Enter Advance Lectures Required".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            if (self.advanceTextField.text == "0" || self.advanceTextField.text == "00" || self.advanceTextField.text == "000") {
//                let message = "Advance Lectures Cannot Be Zero".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//        }
        
        if (textview.text.isEmpty || textview.text == "Write about yourself..." || (textview.text?.characters.count)! == 0){
            let message = "Please Write About Yourself".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }

        self.resetExpertDetails()
//            if (sliderIntValue == 0) {
//                let fullTextBeginer = self.beginerPriceLabel.text!
//                let fullBeginerArray = fullTextBeginer.components(separatedBy: " ")
//                let lastTextBeginer = fullBeginerArray[1]
//                beginnerArray.append(lastTextBeginer)
//                beginnerArray.append(self.beginerTextField.text!)
//            }
//            if (sliderIntValue == 1) {
//                let fullTextBeginer = self.beginerPriceLabel.text!
//                let fullBeginerArray = fullTextBeginer.components(separatedBy: " ")
//                let lastTextBeginer = fullBeginerArray[1]
//                beginnerArray.append(lastTextBeginer)
//                beginnerArray.append(self.beginerTextField.text!)
//                
//                let fullTextIntermediate = self.intermediatePriceLabel.text!
//                let fullIntermediateArray = fullTextIntermediate.components(separatedBy: " ")
//                let lastTextIntermediate = fullIntermediateArray[1]
//                intermediateArray.append(lastTextIntermediate)
//                intermediateArray.append(self.intermediateTextField.text!)
//            }
//            if (sliderIntValue == 2) {
//                let fullTextBeginer = self.beginerPriceLabel.text!
//                let fullBeginerArray = fullTextBeginer.components(separatedBy: " ")
//                let lastTextBeginer = fullBeginerArray[1]
//                beginnerArray.append(lastTextBeginer)
//                beginnerArray.append(self.beginerTextField.text!)
//                
//                let fullTextIntermediate = self.intermediatePriceLabel.text!
//                let fullIntermediateArray = fullTextIntermediate.components(separatedBy: " ")
//                let lastTextIntermediate = fullIntermediateArray[1]
//                intermediateArray.append(lastTextIntermediate)
//                intermediateArray.append(self.intermediateTextField.text!)
//                
//                let fullTextAdvance = self.advancePriceLabel.text!
//                let fullAdvanceArray = fullTextAdvance.components(separatedBy: " ")
//                let lastTextAdvance = fullAdvanceArray[1]
//                advanceArray.append(lastTextAdvance)
//                advanceArray.append(self.advanceTextField.text!)
//            }
        
            if(isAddExpertise) {
                self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            } else if(isUpgradeToTeacher) {
                self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
                self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
            } else if(isUpgradeToTeacherFromBlogView) {
                self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
                self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
            }
        
            expertDetailsInputDomainModel = ExpertDetailsInputDomainModel.init(userId: self.userId,
                                                                               categoryId: mainCategoryValue,
                                                                               subCategoryId: subCategoryValue,
                                                                               qualification: self.qualificationTextfield.text!,
                                                                               about: self.textview.text,
                                                                               basePrice: self.chargesTextField.text!,
                                                                               beginner: beginnerArray,
                                                                               intermediate:intermediateArray,
                                                                               advance: advanceArray)
            
            if(isAddExpertise) {
                let message = "Adding New Expertise Details".localized(in: "ExpertDetails")
                self.displayProgress(message: message)
                
                let APIDataManager: ExpertDetailsProtocol = ExpertDetailsApiDataManager()
                APIDataManager.expertDetails(apiEndPoint: "register_expert_details.php", data:expertDetailsInputDomainModel,callback: { (result) in
                    print(result)
                    switch result {
                    case .Failure(let error):
                        self.onUserExpertDetailsFailed(error: error)
                    case .Success(let data as OTPOutputDomainModel):
                        do {
                            self.onUserExpertDetailsSucceeded(data: data)
                        } catch {
                            self.onUserExpertDetailsFailed(data: data)
                        }
                    default:
                        break
                    }
                })
            } else if(isUpgradeToTeacher || isUpgradeToTeacherFromBlogView) {
                let message = "Upgrading to teacher".localized(in: "ExpertDetails")
                self.displayProgress(message: message)
                
                let APIDataManager: ExpertDetailsProtocol = ExpertDetailsApiDataManager()
                APIDataManager.expertDetails(apiEndPoint: "upgrade_to_teacher.php", data:expertDetailsInputDomainModel,callback: { (result) in
                    print(result)
                    switch result {
                    case .Failure(let error):
                        self.onUserExpertDetailsFailed(error: error)
                    case .Success(let data as OTPOutputDomainModel):
                        do {
                            self.onUserExpertDetailsSucceeded(data: data)
                        } catch {
                            self.onUserExpertDetailsFailed(data: data)
                        }
                    default:
                        break
                    }
                })
            } else {
                
                alertView.buttonTitles = buttonTitleArray
                alertView.containerView = createContainerViewForExpertLevel()
                alertView.delegate = self
                alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
                }
                alertView.catchString(withString: "AlertWithSlider")
                alertView.show()
//
//                let addECreditVC : AddECreditVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddECreditVC") as UIViewController as! AddECreditVC
//                addECreditVC.expertDetailsInputDomainModel = expertDetailsInputDomainModel
//                addECreditVC.signUpInputDomainModel = signUpInputDomainModel
//                self.navigationController?.pushViewController(addECreditVC, animated: true)
            }
    }
    
    //MARK: TextField Delegate
    @IBAction func textFieldEditingDidChange(_ sender: AnyObject) {
        if(sender as! UITextField == self.chargesTextField)
        {
            var chargesPerLecture:Int? = Int(self.chargesTextField.text!)
            if(chargesPerLecture == nil) {
                chargesPerLecture = 0
            }
//            var beginerLectureCount:Int? = Int(self.beginerTextField.text!)
//            if(beginerLectureCount == nil) {
//                beginerLectureCount = 0
//            }
//            self.beginerPriceLabel.text =  "AU$ \(chargesPerLecture! * beginerLectureCount!)"
//            
//            var intermediateLectureCount:Int? = Int(self.intermediateTextField.text!)
//            if(intermediateLectureCount == nil) {
//                intermediateLectureCount = 0
//            }
//            self.intermediatePriceLabel.text =  "AU$ \(chargesPerLecture! * intermediateLectureCount!)"
//            
//            var advanceLectureCount:Int? = Int(self.advanceTextField.text!)
//            if(advanceLectureCount == nil) {
//                advanceLectureCount = 0
//            }
//            self.advancePriceLabel.text =  "AU$ \(chargesPerLecture! * advanceLectureCount!)"
            
        }
//        else if (sender as! UITextField == self.beginerTextField) {
//            var chargesPerLecture:Int? = Int(self.chargesTextField.text!)
//            if(chargesPerLecture == nil)
//            {
//                chargesPerLecture = 0
//            }
//            var beginerLectureCount:Int? = Int(self.beginerTextField.text!)
//            if(beginerLectureCount == nil) {
//                beginerLectureCount = 0
//            }
//            self.beginerPriceLabel.text =  "AU$ \(chargesPerLecture! * beginerLectureCount!)"
//            
//        } else if (sender as! UITextField == self.intermediateTextField) {
//            var chargesPerLecture:Int? = Int(self.chargesTextField.text!)
//            if(chargesPerLecture == nil) {
//                chargesPerLecture = 0
//            }
//            var intermediateLectureCount:Int? = Int(self.intermediateTextField.text!)
//            if(intermediateLectureCount == nil) {
//                intermediateLectureCount = 0
//            }
//            self.intermediatePriceLabel.text =  "AU$ \(chargesPerLecture! * intermediateLectureCount!)"
//            
//        } else if (sender as! UITextField == self.advanceTextField) {
//            var chargesPerLecture:Int? = Int(self.chargesTextField.text!)
//            if(chargesPerLecture == nil)
//            {
//                chargesPerLecture = 0
//            }
//            var advanceLectureCount:Int? = Int(self.advanceTextField.text!)
//            if(advanceLectureCount == nil)
//            {
//                advanceLectureCount = 0
//            }
//            self.advancePriceLabel.text =  "AU$ \(chargesPerLecture! * advanceLectureCount!)"
//        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.subCategoryTextfield {
            if (self.mainCategoryTextfield.text?.characters.count)! == 0 {
                let message = "Please Select Main Category First".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return false
            } else {
                //Get Sub Categories
                if (!self.isInternetAvailable()) {
                    let message = "No Internet Connection".localized(in: "SignUp")
                    self.displayErrorMessage(message: message)
                    return false
                    
                } else {
                    let message = "Processing".localized(in: "Login")
                    self.displayProgress(message: message)
                    let viewModel = SubCategoryDomainModel.init(categoryId: mainCategoryValue)
                    let APIDataManager: SubCategoryProtocols = SubCategoryAPIDataManager()
                    APIDataManager.getSubCategoryDetails(model: viewModel, callback: { (result) in
                        switch result {
                        case .Failure(let error):
                            self.onSubcategoryDataFailed(error: error)
                        case .Success(let data as SubCategoryOutputDomainModel):
                            do {
                                self.onSubcategoryDataSucceeded(data: data)
                            } catch {
                                self.onSubcategoryDataFailed(error: EApiErrorType.InternalError)
                            }
                        default:
                            break
                        }
                    })
                }
            }
        }
        if (textField == self.mainCategoryTextfield || textField == self.subCategoryTextfield) {
            self.pickerviewExpertDetails.tag = textField.tag
            self.pickerviewExpertDetails.reloadAllComponents()
        } else {
            textField.inputAccessoryView = nil;
            textField.inputAccessoryView?.backgroundColor=UIColor.clear
        }
        return true
    }
    
    // MARK: pickerview datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.pickerviewExpertDetails.tag == 101 {
            return categoryArray.count
        }
        if self.pickerviewExpertDetails.tag == 102 {
            return subCategoryArray.count
        }
        return 0
    }
    
    // MARK: pickerview delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = String()
        if self.pickerviewExpertDetails.tag == 101 {
            let categoryDict = self.categoryArray[row] as? [String:AnyObject]
            title = categoryDict?["category_name"] as! String
        }
        if self.pickerviewExpertDetails.tag == 102 {
            let subCategoryDict = self.subCategoryArray[row] as? [String:AnyObject]
            title = subCategoryDict?["sub_category_name"] as! String
        }
        return title as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let str = NSString(format:"%d", row)
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "pickerviewExpertDetails")
    }
    
    func inputAccessoryViewDidFinishForDoneButton(button : UIButton) {
        self.view.endEditing(true)
        if button.tag == 101 {
            let defaults = UserDefaults.standard
            let pickerviewExpertDetails = defaults.string(forKey: "pickerviewExpertDetails")
            let intValue = Int(pickerviewExpertDetails!)
            
            if self.pickerviewExpertDetails.tag == 101 {
                let categoryDict = self.categoryArray[intValue!] as? [String:AnyObject]
                let title = categoryDict?["category_name"] as! String
                self.mainCategoryTextfield.text = title
                mainCategoryValue = categoryDict?["category_id"] as! String
                
                self.subCategoryTextfield.text = ""
                subCategoryValue = ""
                
                let str = NSString(format:"%@", "0")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "pickerviewExpertDetails")
                
                self.pickerviewExpertDetails.reloadAllComponents()
                self.pickerviewExpertDetails.selectRow(0, inComponent: 0, animated: true)
            }
            if self.pickerviewExpertDetails.tag == 102 {
                let subCategoryDict = self.subCategoryArray[intValue!] as? [String:AnyObject]
                let title = subCategoryDict?["sub_category_name"] as! String
                self.subCategoryTextfield.text = title
                subCategoryValue = subCategoryDict?["sub_category_id"] as! String
                
                let str = NSString(format:"%@", "0")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "pickerviewExpertDetails")
                
                self.pickerviewExpertDetails.reloadAllComponents()
                self.pickerviewExpertDetails.selectRow(0, inComponent: 0, animated: true)
                return
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: textview delegate
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.ExpertConnectBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write about yourself..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 200
        let currentString: NSString = textView.text as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
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
    
    // MARK: Expert Details Delegate
    func onUserExpertDetailsSucceeded(data: OTPOutputDomainModel) {
        self.dismissProgress()
        print("signup data %@",data.message)
        print("signup data %@",data.status)
        if data.status {
            if(isAddExpertise) {
                self.delegate.addExpertiseSucceded!(showAlert: true)
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            } else if(isUpgradeToTeacher) {
                self.delegate.upgradeSucceded!(showAlert: true, message: data.message)
                let userType = String(3)
                UserDefaults.standard.set(userType, forKey: "teacherStudentValue")
                _ = self.navigationController?.popViewController(animated: true)
            } else if(isUpgradeToTeacherFromBlogView) {
                self.delegate.upgradeSucceded!(showAlert: true, message: data.message)
                let userType = String(3)
                UserDefaults.standard.set(userType, forKey: "teacherStudentValue")
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onUserExpertDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        if(isAddExpertise) {
            self.displayErrorMessage(message: "Failed to register expert details")
        } else if(isUpgradeToTeacher || isUpgradeToTeacherFromBlogView) {
            self.displayErrorMessage(message: "Failed to upgrade")
        }
    }
    
    func onUserExpertDetailsFailed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        self.displayErrorMessage(message: data.message)
    }
    
    func callPickerViewMehod(_ textField: UITextField, tag: NSInteger) {
    }
    
    func onMainCategoryListSucceeded(data: HomeOutputDomainModel) {
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
        self.dismissProgress()
        print("Hey you logged in: \(data.categories[0])")
        self.categoryArray = data.categories
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pickerviewExpertDetails.reloadAllComponents()
        }
    }
    
    func onMainCategoryListFailed(error: EApiErrorType) {
        // Update the view
        print("Ooops, there is a problem with your creditantials")
        self.dismissProgress()
        
        let message = "No categories found in the database".localized(in: "Login")
        self.displayErrorMessage(message: message)
    }
    
    func onSubcategoryDataSucceeded(data: SubCategoryOutputDomainModel) {
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
        print("Hey you logged in: \(data.subCategories[0])")
        self.subCategoryArray = data.subCategories
        self.dismissProgress()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pickerviewExpertDetails.reloadAllComponents()
        }
    }
    
    func onSubcategoryDataFailed(error: EApiErrorType) {
        // Update the view
        self.subCategoryTextfield.resignFirstResponder()
        self.dismissProgress()
        let message = "No sub categories found in the database".localized(in: "Login")
        self.displayErrorMessage(message: message)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        if self.pickerviewExpertDetails.tag == 101 {
            let categoryDict = self.categoryArray[row] as? [String:AnyObject]
            
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.ExpertConnectBlack
            pickerLabel.text = categoryDict?["category_name"] as? String
            pickerLabel.font = UIFont(name: "Raleway-Light", size: 18) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
        if self.pickerviewExpertDetails.tag == 102 {
            let subCategoryDict = self.subCategoryArray[row] as? [String:AnyObject]
            
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.ExpertConnectBlack
            pickerLabel.text = subCategoryDict?["sub_category_name"] as? String
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneButtonAction(sender: UIButton!) {
        print("doneButtonAction")
    }
    
    func setupInputViewForTextField(textField: UITextField) {
        let str = NSString(format:"%@", "0")
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "pickerviewExpertDetails")
        
        self.pickerviewExpertDetails.delegate = self
        self.pickerviewExpertDetails.dataSource = self
        self.pickerviewExpertDetails.backgroundColor = UIColor.white
        
        self.mainCategoryTextfield.inputView = self.pickerviewExpertDetails
        self.subCategoryTextfield.inputView = self.pickerviewExpertDetails
        
        var cell = SignupDateCell()
        cell = Bundle.main.loadNibNamed("SignupDateCell", owner: nil, options: nil)?[0] as! SignupDateCell
        
        cell.doneButton.addTarget(self, action: #selector(inputAccessoryViewDidFinishForDoneButton(button:)), for: .touchUpInside)
        cell.cancelButton.addTarget(self, action: #selector(inputAccessoryViewDidFinishForDoneButton(button:)), for: .touchUpInside)
        cell.doneButton.tag = 101
        cell.cancelButton.tag = 102
        
        cell.centerLabel.textColor = UIColor.ExpertConnectBlack
        cell.centerLabel.font = UIFont(name: "Raleway-Light", size: 18)
        
        
        cell.doneButton.isHidden = true
        cell.cancelButton.isHidden = true
        
        let button = UIButton()
        button.frame = CGRect(x: self.view.frame.size.width-80, y: 0, width: 80, height: 44)
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        cell.addSubview(button)
        
        
        let myToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        cell.frame = myToolbar.frame
        myToolbar.addSubview(cell)
        
        textField.inputAccessoryView = myToolbar;
        textField.inputAccessoryView?.backgroundColor=UIColor.darkGray
        if textField == self.mainCategoryTextfield {
            cell.centerLabel.text = "Select main Category"
        } else if textField == self.subCategoryTextfield {
            cell.centerLabel.text = "Select sub Category"
        }
    }
    
//    @IBAction func beginnerButtonClicked(_ sender: UIButton) {
//        sliderIntValue = 0
//        self.setupBeginnerLevelButtons()
//        self.intermediateTextField.isEnabled = false
//        self.advanceTextField.isEnabled = false
//        self.intermediateTextField.text = ""
//        self.advanceTextField.text = ""
//        self.intermediatePriceLabel.text = "AU$ 0"
//        self.advancePriceLabel.text = "AU$ 0"
//        
//        self.setExpertConnectDisabledTextFieldTheme(textfield: self.intermediateTextField)
//        self.setExpertConnectDisabledTextFieldTheme(textfield: self.advanceTextField)
//        self.beginerTextField.textColor = UIColor.ExpertConnectRed
//        self.intermediateTextField.textColor = UIColor.ExpertConnectBlack
//        self.advanceTextField.textColor = UIColor.ExpertConnectBlack
//        self.intermediateLabel.textColor = UIColor.ExpertConnectDisabled
//        self.intermediatePriceLabel.textColor = UIColor.ExpertConnectDisabled
//        self.advanceLabel.textColor = UIColor.ExpertConnectDisabled
//        self.advancePriceLabel.textColor = UIColor.ExpertConnectDisabled
//    }
//    
//    @IBAction func intermediateButtonClicked(_ sender: UIButton) {
//        sliderIntValue = 1
//        self.setupIntermediateLevelButtons()
//        self.intermediateTextField.isEnabled = true
//        self.advanceTextField.isEnabled = false
//        self.advanceTextField.text = ""
//        self.advancePriceLabel.text = "AU$ 0"
//        
//        self.setCustomAlertTextFieldTheme(textfield: self.intermediateTextField)
//        self.setExpertConnectDisabledTextFieldTheme(textfield: self.advanceTextField)
//        self.intermediateTextField.textColor = UIColor.ExpertConnectRed
//        self.advanceTextField.textColor = UIColor.ExpertConnectBlack
//        self.intermediateLabel.textColor = UIColor.ExpertConnectRed
//        self.intermediatePriceLabel.textColor = UIColor.ExpertConnectRed
//        self.advanceLabel.textColor = UIColor.ExpertConnectDisabled
//        self.advancePriceLabel.textColor = UIColor.ExpertConnectDisabled
//    }
//    
//    @IBAction func advanceButtonClicked(_ sender: UIButton) {
//        sliderIntValue = 2
//        self.setupAdvanceLevelButtons()
//        self.intermediateTextField.isEnabled = true
//        self.advanceTextField.isEnabled = true
//        
//        self.setCustomAlertTextFieldTheme(textfield: self.intermediateTextField)
//        self.setCustomAlertTextFieldTheme(textfield: self.advanceTextField)
//        self.intermediateTextField.textColor = UIColor.ExpertConnectRed
//        self.advanceTextField.textColor = UIColor.ExpertConnectRed
//        self.intermediateLabel.textColor = UIColor.ExpertConnectRed
//        self.intermediatePriceLabel.textColor = UIColor.ExpertConnectRed
//        self.advanceLabel.textColor = UIColor.ExpertConnectRed
//        self.advancePriceLabel.textColor = UIColor.ExpertConnectRed
//    }
    
//    func setupBeginnerLevelButtons() {
//        self.beginnerButton.setImage(UIImage(named:"selected_beginner_btn"), for: UIControlState.normal)
//        self.intermediateButton.setImage(UIImage(named:"unselected_intermediate_btn"), for: UIControlState.normal)
//        self.advanceButton.setImage(UIImage(named:"unselected_advance_btn"), for: UIControlState.normal)
//        UIView.transition(with: self.beginnerButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            self.beginnerButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
//            self.beginnerButton.setTitleColor(.ExpertConnectRed, for: .normal)
//        }, completion: nil)
//        UIView.transition(with: self.intermediateButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            self.intermediateButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
//            self.intermediateButton.setTitleColor(.ExpertConnectBlack, for: .normal)
//        }, completion: nil)
//        UIView.transition(with: self.advanceButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            self.advanceButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
//            self.advanceButton.setTitleColor(.ExpertConnectBlack, for: .normal)
//        }, completion: nil)
//    }
//    
//    func setupIntermediateLevelButtons() {
//        self.beginnerButton.setImage(UIImage(named:"unselected_beginner_btn"), for: UIControlState.normal)
//        self.intermediateButton.setImage(UIImage(named:"selected_intermediate_btn"), for: UIControlState.normal)
//        self.advanceButton.setImage(UIImage(named:"unselected_advance_btn"), for: UIControlState.normal)
//        UIView.transition(with: self.beginnerButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            self.beginnerButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
//            self.beginnerButton.setTitleColor(.ExpertConnectBlack, for: .normal)
//        }, completion: nil)
//        UIView.transition(with: self.intermediateButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            self.intermediateButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
//            self.intermediateButton.setTitleColor(.ExpertConnectRed, for: .normal)
//        }, completion: nil)
//        UIView.transition(with: self.advanceButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            self.advanceButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
//            self.advanceButton.setTitleColor(.ExpertConnectBlack, for: .normal)
//        }, completion: nil)
//    }
//    
//    func setupAdvanceLevelButtons() {
//        self.beginnerButton.setImage(UIImage(named:"unselected_beginner_btn"), for: UIControlState.normal)
//        self.intermediateButton.setImage(UIImage(named:"unselected_intermediate_btn"), for: UIControlState.normal)
//        self.advanceButton.setImage(UIImage(named:"selected_advance_btn"), for: UIControlState.normal)
//        UIView.transition(with: self.beginnerButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            self.beginnerButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
//            self.beginnerButton.setTitleColor(.ExpertConnectBlack, for: .normal)
//        }, completion: nil)
//        UIView.transition(with: self.intermediateButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            self.intermediateButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
//            self.intermediateButton.setTitleColor(.ExpertConnectBlack, for: .normal)
//        }, completion: nil)
//        UIView.transition(with: self.advanceButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            self.advanceButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
//            self.advanceButton.setTitleColor(.ExpertConnectRed, for: .normal)
//        }, completion: nil)
//    }
    
    func createContainerViewForExpertLevel() -> UIView {
        let View = UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 170))
        let label = UILabel(frame: CGRect(x: 10, y: 20, width: 200, height: 25))
        label.text = "Select Your Subscription Plan"
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.left;
        label.adjustsFontSizeToFitWidth = true
        label.font =  UIFont(name: "Raleway-Medium", size: 15)
        label.textColor = UIColor.ExpertConnectBlack
        View.addSubview(label)
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 246, y: 0, width: 44, height: 44)
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        closeButton.layer.cornerRadius = 3
        View.addSubview(closeButton)
        
        expertLevelSliderView = UIView(frame: CGRect(x: 0, y: 50, width: 290.00, height: 80.00))
        self.setUpExpertLevelSlider()
        View.addSubview(expertLevelSliderView)
        
        return View;
    }
    
    func pressButton(button: UIButton) {
        alertView.close()
    }
    
    func setUpExpertLevelSlider(){
        self.cell = Bundle.main.loadNibNamed("ExpertLevelCell", owner: nil, options: nil)?[0] as! ExpertLevelCell
        cell.beginnerButton.addTarget(self, action: #selector(oneMonthButtonClicked), for: .touchUpInside)
        cell.intermediateButton.addTarget(self, action: #selector(sixMonthButtonClicked), for: .touchUpInside)
        cell.advanceButton.addTarget(self, action: #selector(twelveMonthButtonClicked), for: .touchUpInside)
        cell.beginnerButton.setTitle("1 Month", for: UIControlState.normal)
        cell.intermediateButton.setTitle("6 Month", for: UIControlState.normal)
        cell.advanceButton.setTitle("12 Month", for: UIControlState.normal)
        self.oneMonthButtonClicked()
        expertLevelSliderView.addSubview(self.cell)
    }
    
    func oneMonthButtonClicked() {
        self.setupOneMonthLevelButtons()
        self.subscriptionLevelString = "1"
    }
    
    func sixMonthButtonClicked() {
        self.setupSixMonthLevelButtons()
        self.subscriptionLevelString = "6"
    }
    
    func twelveMonthButtonClicked() {
        self.setupTwelveMonthLevelButtons()
        self.subscriptionLevelString = "12"
    }
    
    func setupOneMonthLevelButtons() {
        self.cell.beginnerButton.setImage(UIImage(named:"selected_beginner_btn"), for: UIControlState.normal)
        self.cell.intermediateButton.setImage(UIImage(named:"unselected_intermediate_btn"), for: UIControlState.normal)
        self.cell.advanceButton.setImage(UIImage(named:"unselected_advance_btn"), for: UIControlState.normal)
        UIView.transition(with: self.cell.beginnerButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.beginnerButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
            self.cell.beginnerButton.setTitleColor(.ExpertConnectRed, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.intermediateButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.intermediateButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.intermediateButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.advanceButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.advanceButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.advanceButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
    }
    
    func setupSixMonthLevelButtons() {
        self.cell.beginnerButton.setImage(UIImage(named:"unselected_beginner_btn"), for: UIControlState.normal)
        self.cell.intermediateButton.setImage(UIImage(named:"selected_intermediate_btn"), for: UIControlState.normal)
        self.cell.advanceButton.setImage(UIImage(named:"unselected_advance_btn"), for: UIControlState.normal)
        UIView.transition(with: self.cell.beginnerButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.beginnerButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.beginnerButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.intermediateButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.intermediateButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
            self.cell.intermediateButton.setTitleColor(.ExpertConnectRed, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.advanceButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.advanceButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.advanceButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
    }
    
    func setupTwelveMonthLevelButtons() {
        self.cell.beginnerButton.setImage(UIImage(named:"unselected_beginner_btn"), for: UIControlState.normal)
        self.cell.intermediateButton.setImage(UIImage(named:"unselected_intermediate_btn"), for: UIControlState.normal)
        self.cell.advanceButton.setImage(UIImage(named:"selected_advance_btn"), for: UIControlState.normal)
        UIView.transition(with: self.cell.beginnerButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.beginnerButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.beginnerButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.intermediateButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.intermediateButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.intermediateButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.advanceButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.advanceButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
            self.cell.advanceButton.setTitleColor(.ExpertConnectRed, for: .normal)
        }, completion: nil)
    }
    
    // MARK: Custom Alert Handle button touches
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        alertView.close()
        if (buttonIndex==0)
        {
            let addECreditVC : AddECreditVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddECreditVC") as UIViewController as! AddECreditVC
            addECreditVC.expertDetailsInputDomainModel = expertDetailsInputDomainModel
            addECreditVC.signUpInputDomainModel = signUpInputDomainModel
            self.navigationController?.pushViewController(addECreditVC, animated: true)
        }
    }
}
