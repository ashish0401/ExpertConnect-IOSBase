
//
//  SearchBrowse.swift
//  ExpertConnect
//
//  Created by Nadeem on 17/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

protocol SearchBrowseListTransferProtocol {
    func searchBrowseSucceded(SearchBrowseListArray:NSArray, isFiltered:Bool) -> Void
    func searchBrowseFailed(isFiltered:Bool) -> Void
}

class SearchBrowse: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,  UITextFieldDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var mainCategoryTextfield: UITextField!
    @IBOutlet var subCategoryTextfield: UITextField!
    @IBOutlet var chargesTextfield: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    var delegate:SearchBrowseListTransferProtocol!
    var pickerviewSearchBrowse = UIPickerView()
    var userId = String()
    var mainCategoryValue = String()
    var subCategoryValue = String()
    var mainCategoryArray: NSArray = [NSDictionary]() as NSArray
    var subCategoryArray: NSArray = [NSDictionary]() as NSArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateSearchBrouseBackIcon(delegate: delegate as! BrowseEnquiryVC)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Browse Enquiry"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.mainCategoryArray = UserDefaults.standard.value(forKey: "MainCategory") as! NSArray
        self.setExpertConnectTextFieldTheme(textfield: self.mainCategoryTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.subCategoryTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.chargesTextfield)
        self.mainCategoryTextfield.setLeftPaddingPoints(10)
        self.subCategoryTextfield.setLeftPaddingPoints(10)
        self.chargesTextfield.sizeToFit()
        self.setupInputViewForTextField(textField: self.mainCategoryTextfield)
        self.setupInputViewForTextField(textField: self.subCategoryTextfield)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setExpertConnectRedButtonTheme(button: self.sendButton)
        self.setExpertConnectShadowTheme(view: self.mainView)
    }
    
    // MARK: Send Button Clicked method
    @IBAction func sendButtonClicked(_ sender: UIButton) {
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
        if (self.chargesTextfield.text == nil || (self.chargesTextfield.text?.characters.count)! == 0) {
            let message = "Please Enter Your Charges".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.chargesTextfield.text == "0" || self.chargesTextfield.text == "00" || self.chargesTextfield.text == "000" || self.chargesTextfield.text == "0000") {
            let message = "Your Charges Cannot Be Zero".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        else{
            let message = "Processing".localized(in: "SignUp")
            self.displayProgress(message: message)
            
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let BrowseEnquiryReceivedNotificationModel = BrowseEnquiryReceivedNotificationDomainModel.init(userId: self.userId, categoryId: self.mainCategoryTextfield.text!, subCategoryId: self.subCategoryTextfield.text!, isFilter: "yes", ammount: self.chargesTextfield.text!)
            let APIDataManager : BrowseEnquiryReceivedNotificationProtocols = BrowseEnquiryReceivedNotificationAPIDataManager()
            APIDataManager.getBrowseEnquiryReceivedNotificationDetails(model: BrowseEnquiryReceivedNotificationModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onGetBrowseEnquiryReceivedNotificationDetailsFailed(error: error)
                case .Success(let data as BrowseEnquiryReceivedNotificationOutputDomainModel):
                    do {
                        self.onGetBrowseEnquiryReceivedNotificationDetailsSucceeded(data: data)
                    } catch {
                        self.onGetBrowseEnquiryReceivedNotificationDetailsFailed(data: data)
                    }
                default:
                    break
                }
            })
        }
    }
    
    // MARK: pickerview datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.pickerviewSearchBrowse.tag == 101 {
            return mainCategoryArray.count
        }
        if self.pickerviewSearchBrowse.tag == 102 {
            return subCategoryArray.count
        }
        return 0
    }
    
    // MARK: pickerview delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = String()
        if self.pickerviewSearchBrowse.tag == 101 {
            let categoryDict = self.mainCategoryArray[row] as? [String:AnyObject]
            title = categoryDict?["category_name"] as! String
        }
        if self.pickerviewSearchBrowse.tag == 102 {
            let subCategoryDict = self.subCategoryArray[row] as? [String:AnyObject]
            title = subCategoryDict?["sub_category_name"] as! String
        }
        return title as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let str = NSString(format:"%d", row)
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "pickerviewSearchBrowse")
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        if self.pickerviewSearchBrowse.tag == 101 {
            let categoryDict = self.mainCategoryArray[row] as? [String:AnyObject]
            
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.ExpertConnectBlack
            pickerLabel.text = categoryDict?["category_name"] as? String
            pickerLabel.font = UIFont(name: "Raleway-Light", size: 18) // In this use your custom font
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
        if self.pickerviewSearchBrowse.tag == 102 {
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
    
    // MARK: Textfield delegate method
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
            self.pickerviewSearchBrowse.tag = textField.tag
            self.pickerviewSearchBrowse.reloadAllComponents()
        } else {
            textField.inputAccessoryView = nil;
            textField.inputAccessoryView?.backgroundColor=UIColor.clear
        }
        return true
    }
    
    func inputAccessoryViewDidFinishForDoneButton(button : UIButton) {
        self.view.endEditing(true)
        if button.tag == 101 {
            let defaults = UserDefaults.standard
            let pickerviewSearchBrowse = defaults.string(forKey: "pickerviewSearchBrowse")
            let intValue = Int(pickerviewSearchBrowse!)
            
            if self.pickerviewSearchBrowse.tag == 101 {
                let categoryDict = self.mainCategoryArray[intValue!] as? [String:AnyObject]
                let title = categoryDict?["category_name"] as! String
                self.mainCategoryTextfield.text = title
                mainCategoryValue = categoryDict?["category_id"] as! String
                
                self.subCategoryTextfield.text = ""
                subCategoryValue = ""
                
                let str = NSString(format:"%@", "0")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "pickerviewSearchBrowse")
                
                self.pickerviewSearchBrowse.reloadAllComponents()
                self.pickerviewSearchBrowse.selectRow(0, inComponent: 0, animated: true)
            }
            if self.pickerviewSearchBrowse.tag == 102 {
                let subCategoryDict = self.subCategoryArray[intValue!] as? [String:AnyObject]
                let title = subCategoryDict?["sub_category_name"] as! String
                self.subCategoryTextfield.text = title
                subCategoryValue = subCategoryDict?["sub_category_id"] as! String
                
                let str = NSString(format:"%@", "0")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "pickerviewSearchBrowse")
                
                self.pickerviewSearchBrowse.reloadAllComponents()
                self.pickerviewSearchBrowse.selectRow(0, inComponent: 0, animated: true)
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
    
    // MARK: setupInputViewForTextField method
    func setupInputViewForTextField(textField: UITextField) {
        let str = NSString(format:"%@", "0")
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "pickerviewSearchBrowse")
        
        self.pickerviewSearchBrowse.delegate = self
        self.pickerviewSearchBrowse.dataSource = self
        self.pickerviewSearchBrowse.backgroundColor = UIColor.white
        
        self.mainCategoryTextfield.inputView = self.pickerviewSearchBrowse
        self.subCategoryTextfield.inputView = self.pickerviewSearchBrowse
        
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
    
    // MARK: SubCategory Response methods
    func onSubcategoryDataSucceeded(data: SubCategoryOutputDomainModel) {
        print("Hey you logged in: \(data.subCategories[0])")
        self.subCategoryArray = data.subCategories
        self.dismissProgress()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pickerviewSearchBrowse.reloadAllComponents()
        }
    }
    
    func onSubcategoryDataFailed(error: EApiErrorType) {
        // Update the view
        self.subCategoryTextfield.resignFirstResponder()
        self.dismissProgress()
        let message = "No sub categories found in the database".localized(in: "Login")
        self.displayErrorMessage(message: message)
    }
    
    // MARK: Search Browse Response methods
    func onGetBrowseEnquiryReceivedNotificationDetailsSucceeded(data: BrowseEnquiryReceivedNotificationOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.delegate.searchBrowseSucceded(SearchBrowseListArray: data.browsedEnquiries, isFiltered: true)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onGetBrowseEnquiryReceivedNotificationDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.delegate.searchBrowseFailed(isFiltered: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func onGetBrowseEnquiryReceivedNotificationDetailsFailed(data: BrowseEnquiryReceivedNotificationOutputDomainModel) {
        self.dismissProgress()
        //self.displayErrorMessage(message: data.message)
        //self.delegate.setData(SearchBrowseListArray: nil, isFiltered: true)
        //self.navigationController?.popViewController(animated: true)
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
