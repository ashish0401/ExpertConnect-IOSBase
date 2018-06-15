//
//  AddCategoryView.swift
//  ExpertConnect
//
//  Created by Redbytes on 06/02/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol AddCategoryDelegate {
    func addCategorySucceded(showAlert:Bool, message: String) -> Void
}
class AddCategoryView: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var delegate:AddCategoryDelegate!
    
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var subCategoryTextField: UITextField!
    @IBOutlet weak var mainCategoryTextField: UITextField!
    
    @IBOutlet weak var chooseCategoryButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    
    var pickerviewExpertDetails = UIPickerView()
    var categoryArray: NSArray = [NSDictionary]() as NSArray
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.navigationItem.title = "Add Category"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        self.setExpertConnectRedButtonTheme(button: self.requestButton)
        self.setExpertConnectTextFieldTheme(textfield: self.mainCategoryTextField)
        self.setExpertConnectTextFieldTheme(textfield: self.subCategoryTextField)
        self.mainCategoryTextField.setLeftPaddingPoints(10)
        self.subCategoryTextField.setLeftPaddingPoints(10)
        self.callMainCategoryListApi()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.setExpertConnectShadowTheme(view: baseView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseCategoryButtonClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.mainCategoryTextField.tag = 10
        self.setupInputViewForTextField(textField: self.mainCategoryTextField)
        self.mainCategoryTextField.becomeFirstResponder()
        self.pickerviewExpertDetails.tag = 101
        self.pickerviewExpertDetails.reloadAllComponents()
    }
    
    @IBAction func requestButtonClicked(_ sender: Any) {
        self.view.endEditing(true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "AddCategoryView")
            self.displayErrorMessage(message: message)
            return
        }
        
        if (self.mainCategoryTextField.text == nil || (self.mainCategoryTextField.text?.characters.count)! == 0){
            let message = "Please Enter Main Category".localized(in: "AddCategoryView")
            self.displayErrorMessage(message: message)
            return
        }
        
        if (self.mainCategoryTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)! {
            let message = "Please Enter Main Category".localized(in: "AddCategoryView")
            self.displayErrorMessage(message: message)
            return
        }
        
        if (self.subCategoryTextField.text == nil || (self.subCategoryTextField.text?.characters.count)! == 0){
            let message = "Please Enter Sub Category".localized(in: "AddCategoryView")
            self.displayErrorMessage(message: message)
            return
        }
        
        if (self.subCategoryTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)! {
            let message = "Please Enter Sub Category".localized(in: "AddCategoryView")
            self.displayErrorMessage(message: message)
            return
        }
        
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        let message = "Adding new category".localized(in: "AddCategoryView")
        self.displayProgress(message: message)
        let addCategoryViewInputDomainModel = AddCategoryViewInputDomainModel.init(userId: self.userId, categoryName: self.mainCategoryTextField.text!, subCategoryName: self.subCategoryTextField.text!)
        let APIDataManager : AddCategoryViewProtocol = AddCategoryViewApiDataManager()
        APIDataManager.addCategory(data: addCategoryViewInputDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onAddCategoryFailed(error: error)
                break
                
            case .Success(let data as OTPOutputDomainModel):
                self.onAddCategorySucceed(data: data)
                break
                
            default:
                break
            }
        })
        
    }
    
    // MARK: Verify OTP Methods
    func onAddCategorySucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            self.delegate.addCategorySucceded(showAlert: true, message: "Your request has been successfully sent to admin for approval")
            self.view.endEditing(true)
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onAddCategoryFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to update")
    }
    
    func callMainCategoryListApi() {
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "AddCategoryView")
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
        self.dismissProgress()
        
        let message = "No categories found in the database".localized(in: "Login")
        self.displayErrorMessage(message: message)
    }
    
    func setupInputViewForTextField(textField: UITextField) {
        let str = NSString(format:"%@", "0")
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "pickerviewExpertDetails")
        let pickerviewExpertDetails = UIPickerView()
        pickerviewExpertDetails.delegate = self
        pickerviewExpertDetails.dataSource = self
        pickerviewExpertDetails.backgroundColor = UIColor.white
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
        if textField == self.mainCategoryTextField {
            cell.centerLabel.text = "Select main category"
        }
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
    
    // MARK: pickerview datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.pickerviewExpertDetails.tag == 101 {
            return categoryArray.count
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
        return title as String
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
                self.mainCategoryTextField.text = title
                let str = NSString(format:"%@", "0")
                let defaults = UserDefaults.standard
                defaults.set(str, forKey: "pickerviewExpertDetails")
                self.pickerviewExpertDetails.reloadAllComponents()
                self.pickerviewExpertDetails.selectRow(0, inComponent: 0, animated: true)
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.subCategoryTextField {
            if (self.mainCategoryTextField.text?.characters.count)! == 0 {
                let message = "Please Enter Main Category First".localized(in: "AddCategoryView")
                self.displayErrorMessage(message: message)
                return false
            }
        }
        if (textField.tag == 10) {
            self.pickerviewExpertDetails.tag = 101
            textField.tag = 101
            self.pickerviewExpertDetails.reloadAllComponents()
        }
        else {
            textField.inputAccessoryView = nil;
            textField.inputView = nil;
            textField.inputAccessoryView?.backgroundColor=UIColor.clear
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.mainCategoryTextField { // Switch focus to other text field
            self.subCategoryTextField.becomeFirstResponder()
        }
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
