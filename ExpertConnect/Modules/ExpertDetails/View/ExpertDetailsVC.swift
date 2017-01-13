//
//  ExpertDetailsVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit


class ExpertDetailsVC: UIViewController,  UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AKSSegmentedSliderControlDelegate  {
  
    var signUpInputDomainModel: SignUpInputDomainModel!
    var expertDetailsInputDomainModel: ExpertDetailsInputDomainModel!
    var beginnerArray = ["Beginner"]
    var intermediateArray = ["Intermediate"]
    var advanceArray = ["Advance"]
    var isAddExpertise: Bool = false

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
    
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet weak var beginerPriceLabel: UILabel!
    @IBOutlet weak var intermediatePriceLabel: UILabel!
    @IBOutlet weak var advancePriceLabel: UILabel!
    
    @IBOutlet weak var advanceLabel: UILabel!
    @IBOutlet weak var intermediateLabel: UILabel!
    @IBOutlet weak var beginerLabel: UILabel!
    
    var userId: String = ""
    
    @IBOutlet var expertLevelButton: UIButton!
    @IBOutlet weak var textviewBackgroundView: UIView!
    @IBOutlet weak var textview: UITextView!
    
    @IBOutlet var customSliderView: UIView!

    @IBOutlet var expertLevelView: UIView!
    
    @IBAction func mainCategoryButtonClicked(_ sender: UIButton) {
        
    }
    @IBAction func subCategoryButtonClicked(_ sender: UIButton) {
        
    }
    
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
    
    enum UIAlertControllerStyle : Int {
        case ActionSheet
        case Alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isAddExpertise) {
            self.activateTextualCancelIcon()
            self.activateTextualAddIcon(delegate: self)
            self.nextButton.isHidden = true
        } else {
            self.activateBackIcon()
            self.nextButton.isHidden = false
        }

       // print("signup data %@",signUpInputDomainModel.userType)
        
        self.scrollview.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        let size = CGSize(width: 600, height: 800)
        self.scrollview.contentSize = size
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = "Expert Details"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.expertLevelButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        self.expertLevelButton.setTitle("BEGINNER", for: UIControlState.normal)
        
        self.textview.textColor = UIColor.ExpertConnectBlack
        
        self.beginerTextField.adjustsFontSizeToFitWidth = true
        self.intermediateTextField.adjustsFontSizeToFitWidth = true
        self.advanceTextField.adjustsFontSizeToFitWidth = true
        
        self.intermediateTextField.isEnabled = false
        self.advanceTextField.isEnabled = false

        self.textview.text = "Write about yourself..."
        self.textview.textColor = UIColor.lightGray
        //setup UI
        self.setExpertConnectRedButtonTheme(button: self.expertLevelButton)
        self.setExpertConnectRedButtonTheme(button: self.nextButton)
        
        self.setExpertConnectTextFieldTheme(textfield: self.mainCategoryTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.subCategoryTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.qualificationTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.chargesTextField)
        
        self.setCustomAlertTextFieldTheme(textfield: self.beginerTextField)
        self.setExpertConnectTextFieldTheme(textfield: self.intermediateTextField)
        self.setExpertConnectTextFieldTheme(textfield: self.advanceTextField)
        
        self.beginerLabel.textColor = UIColor.ExpertConnectRed
        self.beginerPriceLabel.textColor = UIColor.ExpertConnectRed
        self.beginerTextField.textColor = UIColor.ExpertConnectRed

        self.mainCategoryTextfield.setLeftPaddingPoints(10)
        self.subCategoryTextfield.setLeftPaddingPoints(10)
        self.qualificationTextfield.setLeftPaddingPoints(10)
        self.chargesLabel.sizeToFit()

        //API
        self.setUpExpertLevelSlider()
        self.callMainCategoryListApi()
        self.setupInputViewForTextField(textField: self.mainCategoryTextfield)
        self.setupInputViewForTextField(textField: self.subCategoryTextfield)
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.resetExpertDetails()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.setExpertConnectShadowTheme(view: self.expertLevelView)
        self.setExpertConnectShadowTheme(view: self.textviewBackgroundView)
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

        if (sliderIntValue == 0) {
            if (self.beginerTextField.text == nil || (self.beginerTextField.text?.characters.count)! == 0) {
                let message = "Please Enter Beginner Lectures Required".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }
            if (self.beginerTextField.text == "0" || self.beginerTextField.text == "00" || self.beginerTextField.text == "000") {
                let message = "Beginner Lectures Cannot Be Zero".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }

        }
        if (sliderIntValue == 1) {
            if (self.beginerTextField.text == nil || (self.beginerTextField.text?.characters.count)! == 0) {
                let message = "Please Enter Beginner Lectures Required".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }
            if (self.beginerTextField.text == "0" || self.beginerTextField.text == "00" || self.beginerTextField.text == "000") {
                let message = "Beginner Lectures Cannot Be Zero".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }

            if (self.intermediateTextField.text == nil || (self.intermediateTextField.text?.characters.count)! == 0){
                let message = "Please Enter Intermediate Lectures Required".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }
            if (self.intermediateTextField.text == "0" || self.intermediateTextField.text == "00" || self.intermediateTextField.text == "000") {
                let message = "Intermediate Lectures Cannot Be Zero".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }

        }
        if (sliderIntValue == 2) {
            if (self.beginerTextField.text == nil || (self.beginerTextField.text?.characters.count)! == 0) {
                let message = "Please Enter Beginner Lectures Required".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }
            if (self.beginerTextField.text == "0" || self.beginerTextField.text == "00" || self.beginerTextField.text == "000") {
                let message = "Beginner Lectures Cannot Be Zero".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }

            if (self.intermediateTextField.text == nil || (self.intermediateTextField.text?.characters.count)! == 0){
                let message = "Please Enter Intermediate Lectures Required".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }
            if (self.intermediateTextField.text == "0" || self.intermediateTextField.text == "00" || self.intermediateTextField.text == "000") {
                let message = "Intermediate Lectures Cannot Be Zero".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }

            if (self.advanceTextField.text == nil || (self.advanceTextField.text?.characters.count)! == 0) {
                let message = "Please Enter Advance Lectures Required".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }
            if (self.advanceTextField.text == "0" || self.advanceTextField.text == "00" || self.advanceTextField.text == "000") {
                let message = "Advance Lectures Cannot Be Zero".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }
        }
        if (textview.text.isEmpty || textview.text == "Write about yourself..." || (textview.text?.characters.count)! == 0){
            let message = "Please Write About Yourself".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        else {
            self.resetExpertDetails()
            if (sliderIntValue == 0) {
                let fullTextBeginer = self.beginerPriceLabel.text!
                let fullBeginerArray = fullTextBeginer.components(separatedBy: " ")
                let lastTextBeginer = fullBeginerArray[1]
                beginnerArray.append(lastTextBeginer)
                beginnerArray.append(self.beginerTextField.text!)
            }
            if (sliderIntValue == 1) {
                let fullTextBeginer = self.beginerPriceLabel.text!
                let fullBeginerArray = fullTextBeginer.components(separatedBy: " ")
                let lastTextBeginer = fullBeginerArray[1]
                beginnerArray.append(lastTextBeginer)
                beginnerArray.append(self.beginerTextField.text!)

                let fullTextIntermediate = self.intermediatePriceLabel.text!
                let fullIntermediateArray = fullTextIntermediate.components(separatedBy: " ")
                let lastTextIntermediate = fullIntermediateArray[1]
                intermediateArray.append(lastTextIntermediate)
                intermediateArray.append(self.intermediateTextField.text!)
            }
            if (sliderIntValue == 2) {
                let fullTextBeginer = self.beginerPriceLabel.text!
                let fullBeginerArray = fullTextBeginer.components(separatedBy: " ")
                let lastTextBeginer = fullBeginerArray[1]
                beginnerArray.append(lastTextBeginer)
                beginnerArray.append(self.beginerTextField.text!)
                
                let fullTextIntermediate = self.intermediatePriceLabel.text!
                let fullIntermediateArray = fullTextIntermediate.components(separatedBy: " ")
                let lastTextIntermediate = fullIntermediateArray[1]
                intermediateArray.append(lastTextIntermediate)
                intermediateArray.append(self.intermediateTextField.text!)

                let fullTextAdvance = self.advancePriceLabel.text!
                let fullAdvanceArray = fullTextAdvance.components(separatedBy: " ")
                let lastTextAdvance = fullAdvanceArray[1]
                advanceArray.append(lastTextAdvance)
                advanceArray.append(self.advanceTextField.text!)
            }

            if(isAddExpertise) {
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
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
                APIDataManager.expertDetails(data:expertDetailsInputDomainModel,callback: { (result) in
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
                let addECreditVC : AddECreditVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddECreditVC") as UIViewController as! AddECreditVC
                // expertDetailsVC.userId = self.userId
                addECreditVC.expertDetailsInputDomainModel = expertDetailsInputDomainModel
                addECreditVC.signUpInputDomainModel = signUpInputDomainModel
                self.navigationController?.pushViewController(addECreditVC, animated: true)
            }
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
            var beginerLectureCount:Int? = Int(self.beginerTextField.text!)
            if(beginerLectureCount == nil) {
                beginerLectureCount = 0
            }
            self.beginerPriceLabel.text =  "AU$ \(chargesPerLecture! * beginerLectureCount!)"
            
            var intermediateLectureCount:Int? = Int(self.intermediateTextField.text!)
            if(intermediateLectureCount == nil) {
                intermediateLectureCount = 0
            }
            self.intermediatePriceLabel.text =  "AU$ \(chargesPerLecture! * intermediateLectureCount!)"
            
            var advanceLectureCount:Int? = Int(self.advanceTextField.text!)
            if(advanceLectureCount == nil) {
                advanceLectureCount = 0
            }
            self.advancePriceLabel.text =  "AU$ \(chargesPerLecture! * advanceLectureCount!)"
            
        } else if (sender as! UITextField == self.beginerTextField) {
            var chargesPerLecture:Int? = Int(self.chargesTextField.text!)
            if(chargesPerLecture == nil)
            {
                chargesPerLecture = 0
            }
            var beginerLectureCount:Int? = Int(self.beginerTextField.text!)
            if(beginerLectureCount == nil) {
                beginerLectureCount = 0
            }
            self.beginerPriceLabel.text =  "AU$ \(chargesPerLecture! * beginerLectureCount!)"
            
        } else if (sender as! UITextField == self.intermediateTextField) {
            var chargesPerLecture:Int? = Int(self.chargesTextField.text!)
            if(chargesPerLecture == nil) {
                chargesPerLecture = 0
            }
            var intermediateLectureCount:Int? = Int(self.intermediateTextField.text!)
            if(intermediateLectureCount == nil) {
                intermediateLectureCount = 0
            }
            self.intermediatePriceLabel.text =  "AU$ \(chargesPerLecture! * intermediateLectureCount!)"

        } else if (sender as! UITextField == self.advanceTextField) {
            var chargesPerLecture:Int? = Int(self.chargesTextField.text!)
            if(chargesPerLecture == nil)
            {
                chargesPerLecture = 0
            }
            var advanceLectureCount:Int? = Int(self.advanceTextField.text!)
            if(advanceLectureCount == nil)
            {
                advanceLectureCount = 0
            }
            self.advancePriceLabel.text =  "AU$ \(chargesPerLecture! * advanceLectureCount!)"
        }
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
    
    // MARK: SignUp Delegate
    func onUserExpertDetailsSucceeded(data: OTPOutputDomainModel) {
        self.dismissProgress()
        print("signup data %@",data.message)
        print("signup data %@",data.status)
        if data.status {
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onUserExpertDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to register expert details")
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
    
    func setUpExpertLevelSlider() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        if(screenWidth == 320) {
            let tempXPosition : Float = Float((self.view.frame.width * 5)/100)
            let xPosition : Int = Int(tempXPosition)
            let yPosition = 30
            
            let tempWidth : Float = Float((self.view.frame.width * 85)/100)
            let width : Int = Int(tempWidth)
            let height = 20
            
            let tempSpaceBetweenPoints : Float = Float((self.view.frame.width * 35)/100)
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
            sliderControl.numberOfPoints = 3
            self.customSliderView.addSubview(sliderControl)
        } else {

            let tempXPosition : Float = Float((self.view.frame.width * 5)/100)
            let xPosition : Int = Int(tempXPosition)
            let yPosition = 30
            
            let tempWidth : Float = Float((self.view.frame.width * 85)/100)
            let width : Int = Int(tempWidth)
            let height = 20
            
            let tempSpaceBetweenPoints : Float = Float((self.view.frame.width * 36.5)/100)
            let spaceBetweenPoints = tempSpaceBetweenPoints
            let radiusPoint = 8
            let sliderLineWidth = 5
            
            var sliderConrolFrame: CGRect = CGRect.null
            sliderConrolFrame = CGRect(x: xPosition-4, y: (yPosition), width: width+7, height: height)
            //let sliderControl :  AKSSegmentedSliderControl = AKSSegmentedSliderControl(frame: sliderConrolFrame)
            let sliderControl :  AKSSegmentedSliderControl = AKSSegmentedSliderControl.init(frame: sliderConrolFrame)

            sliderControl.delegate = self
            sliderControl.move(to: 0)
            sliderControl.spaceBetweenPoints = Float(spaceBetweenPoints)
            sliderControl.radiusPoint = Float(radiusPoint)
            sliderControl.heightLine = Float(sliderLineWidth)
            sliderControl.numberOfPoints = 3
            self.customSliderView.addSubview(sliderControl)
        }
    }
    
    func timeSlider(_ timeSlider: AKSSegmentedSliderControl! , didSelectPointAtIndex index:Int) -> Void  {
        self.resetExpertDetails()
        sliderIntValue = index

        if index == 0 {
            self.expertLevelButton.setTitle("BEGINNER", for: UIControlState.normal)
            //            self.beginnerMiddleTextfield.tintColor = UIColor.red
            self.intermediateTextField.isEnabled = false
            self.advanceTextField.isEnabled = false
            self.intermediateTextField.text = ""
            self.advanceTextField.text = ""
            self.intermediatePriceLabel.text = "AU$ 0"
            self.advancePriceLabel.text = "AU$ 0"
          
            self.setExpertConnectTextFieldTheme(textfield: self.intermediateTextField)
            self.setExpertConnectTextFieldTheme(textfield: self.advanceTextField)
            self.beginerTextField.textColor = UIColor.ExpertConnectRed
            self.intermediateTextField.textColor = UIColor.ExpertConnectBlack
            self.advanceTextField.textColor = UIColor.ExpertConnectBlack
            self.intermediateLabel.textColor = UIColor.ExpertConnectBlack
            self.intermediatePriceLabel.textColor = UIColor.ExpertConnectBlack
            self.advanceLabel.textColor = UIColor.ExpertConnectBlack
            self.advancePriceLabel.textColor = UIColor.ExpertConnectBlack

        }
        else if index == 1 {
            self.expertLevelButton.setTitle("INTERMEDIATE", for: UIControlState.normal)
            self.intermediateTextField.isEnabled = true
            self.advanceTextField.isEnabled = false
            self.advanceTextField.text = ""
            self.advancePriceLabel.text = "AU$ 0"

            self.setCustomAlertTextFieldTheme(textfield: self.intermediateTextField)
            self.setExpertConnectTextFieldTheme(textfield: self.advanceTextField)
            self.intermediateTextField.textColor = UIColor.ExpertConnectRed
            self.advanceTextField.textColor = UIColor.ExpertConnectBlack
            self.intermediateLabel.textColor = UIColor.ExpertConnectRed
            self.intermediatePriceLabel.textColor = UIColor.ExpertConnectRed
            self.advanceLabel.textColor = UIColor.ExpertConnectBlack
            self.advancePriceLabel.textColor = UIColor.ExpertConnectBlack
        }
        else if index == 2 {
            self.expertLevelButton.setTitle("ADVANCE", for: UIControlState.normal)
            self.intermediateTextField.isEnabled = true
            self.advanceTextField.isEnabled = true
            
            self.setCustomAlertTextFieldTheme(textfield: self.intermediateTextField)
            self.setCustomAlertTextFieldTheme(textfield: self.advanceTextField)
            self.intermediateTextField.textColor = UIColor.ExpertConnectRed
            self.advanceTextField.textColor = UIColor.ExpertConnectRed
            self.intermediateLabel.textColor = UIColor.ExpertConnectRed
            self.intermediatePriceLabel.textColor = UIColor.ExpertConnectRed
            self.advanceLabel.textColor = UIColor.ExpertConnectRed
            self.advancePriceLabel.textColor = UIColor.ExpertConnectRed
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
