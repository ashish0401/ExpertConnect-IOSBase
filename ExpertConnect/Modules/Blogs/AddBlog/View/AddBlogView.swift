//
//  AddBlogView.swift
//  ExpertConnect
//
//  Created by Redbytes on 06/02/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

@objc protocol AddBlogDelegate {
    @objc optional func addBlogSucceded(showAlert:Bool, message: String) -> Void
}

class AddBlogView: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var delegate:AddBlogDelegate!
    
    var mainCategoryValue = String()
    var subCategoryValue = String()
    var categoryArray: NSArray = [NSDictionary]() as NSArray
    var subCategoryArray: NSArray = [NSDictionary]() as NSArray
    var pickerviewExpertDetails = UIPickerView()
    
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var descriptionTextview: UITextView!
    @IBOutlet weak var blogTextfield: UITextField!
    @IBOutlet var mainCategoryTextfield: UITextField!
    @IBOutlet var subCategoryTextfield: UITextField!
    @IBOutlet var mainCategoryButton: UIButton!
    @IBOutlet var subCategoryButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var baseView: UIView!
    var userId: String = ""
    var location: String = ""
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        self.scrollview.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        let size = CGSize(width: 600, height: 800)
        self.scrollview.contentSize = size
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = "Add Blog"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.descriptionTextview.textColor = UIColor.ExpertConnectBlack
        
        //setup UI
        self.setExpertConnectRedButtonTheme(button: self.submitButton)
        self.setExpertConnectTextFieldTheme(textfield: self.mainCategoryTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.subCategoryTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.titleTextfield)
        self.setExpertConnectTextFieldTheme(textfield: self.blogTextfield)
        self.setExpertConnectTextViewTheme(textview: self.descriptionTextview)
        
        self.mainCategoryTextfield.setLeftPaddingPoints(10)
        self.subCategoryTextfield.setLeftPaddingPoints(10)
        self.titleTextfield.setLeftPaddingPoints(10)
        self.blogTextfield.setLeftPaddingPoints(10)
        self.descriptionTextview.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        //self.descriptionTextview.text = "Write about yourself..."
        self.descriptionTextview.textColor = UIColor.lightGray
        
        //API
        self.callMainCategoryListApi()
        self.setupInputViewForTextField(textField: self.mainCategoryTextfield)
        self.setupInputViewForTextField(textField: self.subCategoryTextfield)
        
        self.activateTextualCancelIcon()
        // self.activateTextualAddIcon(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.setExpertConnectShadowTheme(view: self.baseView)
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
            //textView.text = "Write about yourself..."
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
    
    // MARK: Picker View Delegate
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
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "AddBlogView")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.titleTextfield.text == nil || (self.titleTextfield.text?.characters.count)! == 0){
            let message = "Please Enter Title".localized(in: "AddBlogView")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.descriptionTextview.text.isEmpty || self.descriptionTextview.text == "Write about yourself..." || (self.descriptionTextview.text?.characters.count)! == 0){
            let message = "Please Enter Description".localized(in: "AddBlogView")
            self.displayErrorMessage(message: message)
            return
        }
//        if (self.blogTextfield.text == nil || (self.blogTextfield.text?.characters.count)! == 0){
//            let message = "Please Enter Blog Url".localized(in: "AddBlogView")
//            self.displayErrorMessage(message: message)
//            return
//        }
//        if (!self.verifyUrl(urlString: self.blogTextfield.text)){
//            let message = "Please Enter Correct Blog Url".localized(in: "AddBlogView")
//            self.displayErrorMessage(message: message)
//            return
//        }
        
        if (self.blogTextfield.text != nil && (self.blogTextfield.text?.characters.count)! > 0) {
            if (!self.verifyUrl(urlString: self.blogTextfield.text)) {
                let message = "Please Enter Correct Blog Url".localized(in: "AddBlogView")
                self.displayErrorMessage(message: message)
                return
            }
        }

        if (self.mainCategoryTextfield.text == nil || (self.mainCategoryTextfield.text?.characters.count)! == 0){
            let message = "Please Select Main Category".localized(in: "AddBlogView")
            self.displayErrorMessage(message: message)
            return
        }
        if (self.subCategoryTextfield.text == nil || (self.subCategoryTextfield.text?.characters.count)! == 0){
            let message = "Please Select Sub Category".localized(in: "AddBlogView")
            self.displayErrorMessage(message: message)
            return
        }
        
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        self.location = UserDefaults.standard.value(forKey: "Location") as! String
        let message = "Adding new blog".localized(in: "AddBlogView")
        self.displayProgress(message: message)
        let addBlogViewInputDomainModel = AddBlogViewInputDomainModel.init(userId: self.userId, categoryId: self.mainCategoryValue, subCategoryId: self.subCategoryValue, blogTitle: self.titleTextfield.text!, blogDescription: self.descriptionTextview.text!, blogUrl: self.blogTextfield.text!, blogCity: self.location)
        let APIDataManager : AddBlogViewProtocol = AddBlogViewApiDataManager()
        APIDataManager.addBlog(data: addBlogViewInputDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onAddBlogFailed(error: error)
                break
                
            case .Success(let data as OTPOutputDomainModel):
                self.onAddBlogSucceed(data: data)
                break
                
            default:
                break
            }
        })
    }
    
    // MARK: Verify OTP Methods
    func onAddBlogSucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            self.delegate.addBlogSucceded!(showAlert: true, message: "Your blog added successfully")
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onAddBlogFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to add blog")
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
    
    func callPickerViewMehod(_ textField: UITextField, tag: NSInteger) {
    }
    
    func onMainCategoryListSucceeded(data: HomeOutputDomainModel) {
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
        self.dismissProgress()
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
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}