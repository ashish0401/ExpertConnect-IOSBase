//
//  ExpertDetailsVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class ExpertDetailsVC: UIViewController,  UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var mainCategoryTextfield: UITextField!
    @IBOutlet var subCategoryTextfield: UITextField!
    @IBOutlet var qualificationTextfield: UITextField!
    @IBOutlet var mainCategoryButton: UIButton!
    @IBOutlet var subCategoryButton: UIButton!
    
    @IBOutlet var beginnerLeftTextfield: UITextField!
    @IBOutlet var beginnerMiddleTextfield: UITextField!
    @IBOutlet var beginnerRightTextfield: UITextField!
    @IBOutlet var intermediateLeftTextfield: UITextField!
    @IBOutlet var intermediateMiddleTextfield: UITextField!
    @IBOutlet var intermediateRightTextfield: UITextField!
    @IBOutlet var advanceLeftTextfield: UITextField!
    @IBOutlet var advanceMiddleTextfield: UITextField!
    @IBOutlet var advanceRightTextfield: UITextField!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var expertLevelButton: UIButton!
    @IBOutlet var textview: UITextView!
    
    @IBOutlet var beginnerMiddleButton: UIButton!
    @IBOutlet var intermediateMiddleButton: UIButton!
    @IBOutlet var advanceMiddleButton: UIButton!
    
    @IBOutlet var expertLevelView: UIView!
    
    @IBAction func mainCategoryButtonClicked(_ sender: UIButton) {
        
    }
    @IBAction func subCategoryButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func beginnerButtonClicked(_ sender: UIButton) {

    }
    @IBAction func intermediateButtonClicked(_ sender: UIButton) {

    }
    @IBAction func advanceButtonClicked(_ sender: UIButton) {

    }
    @IBAction func beginnerMiddleButtonClicked(_ sender: UIButton) {

    }
    @IBAction func intermediateMiddleButtonClicked(_ sender: UIButton) {

    }
    @IBAction func advanceMiddleButtonClicked(_ sender: UIButton) {

    }
    
    var pickerviewExpertDetails = UIPickerView()
    var datePickerArray = NSMutableArray()
    
    let backItem = UIButton()
    let step: Float = 0.5
    
    var mainCategoryValue = String()
    var subCategoryValue = String()
    var beginnerMiddleValue = String()
    var intermediateMiddleValue = String()
    var advanceMiddleValue = String()
    
    
    enum UIAlertControllerStyle : Int {
        case ActionSheet
        case Alert
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainCategoryTextfield.delegate = self
        self.subCategoryTextfield.delegate = self
        self.qualificationTextfield.delegate = self
        
        self.beginnerLeftTextfield.delegate = self
        self.beginnerMiddleTextfield.delegate = self
        self.beginnerRightTextfield.delegate = self
        self.intermediateLeftTextfield.delegate = self
        self.intermediateMiddleTextfield.delegate = self
        self.intermediateRightTextfield.delegate = self
        self.advanceLeftTextfield.delegate = self
        self.advanceMiddleTextfield.delegate = self
        self.advanceRightTextfield.delegate = self
        
        self.textview.delegate = self
        self.pickerviewExpertDetails.delegate = self
        self.pickerviewExpertDetails.dataSource = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        self.navigationItem.hidesBackButton = true;
        
        self.scrollview.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        let size = CGSize(width: 600, height: 800)
        self.scrollview.contentSize = size
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Expert Details"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 247/255, green: 67/255, blue: 0.0, alpha: 1.0)]
        slider.setThumbImage(UIImage(named: "slider_dot"), for: UIControlState.normal)
        //        self.expertLevelLabel.textContainerInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        self.expertLevelButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        self.expertLevelButton.setTitle("BEGINNER", for: UIControlState.normal)
        
        //        self.textview.text = "Write about yourself..."
        self.textview.textColor = UIColor.gray
        
        self.mainCategoryTextfield.inputView = self.pickerviewExpertDetails
        self.subCategoryTextfield.inputView = self.pickerviewExpertDetails
        self.beginnerMiddleTextfield.inputView = self.pickerviewExpertDetails
        self.intermediateMiddleTextfield.inputView = self.pickerviewExpertDetails
        self.advanceMiddleTextfield.inputView = self.pickerviewExpertDetails
        
        self.beginnerLeftTextfield.keyboardType = UIKeyboardType.numberPad
        self.beginnerRightTextfield.keyboardType = UIKeyboardType.numberPad
        self.intermediateLeftTextfield.keyboardType = UIKeyboardType.numberPad
        self.intermediateRightTextfield.keyboardType = UIKeyboardType.numberPad
        self.advanceLeftTextfield.keyboardType = UIKeyboardType.numberPad
        self.advanceRightTextfield.keyboardType = UIKeyboardType.numberPad
        
        self.intermediateLeftTextfield.isEnabled = false
        self.intermediateMiddleTextfield.isEnabled = false
        self.intermediateRightTextfield.isEnabled = false
        self.advanceLeftTextfield.isEnabled = false
        self.advanceRightTextfield.isEnabled = false
        self.advanceMiddleTextfield.isEnabled = false
        self.intermediateMiddleButton.isEnabled = false
        self.advanceMiddleButton.isEnabled = false
        
        self.textview.text = "Write about yourself..."
        self.textview.textColor = UIColor.lightGray
        //
        //        self.textview.becomeFirstResponder()
        
        //        self.textview.selectedTextRange = self.textview.textRange(from: self.textview.beginningOfDocument, to: self.textview.beginningOfDocument)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        self.addBackButtonOnNavigationBar()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.expertLevelView.layer.shadowColor = UIColor.black.cgColor
        self.expertLevelView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.expertLevelView.layer.shadowOpacity = 0.4
        self.expertLevelView.layer.shadowRadius = 0.3
        
        self.expertLevelView.layer.shadowPath = UIBezierPath(roundedRect: self.expertLevelView.bounds, cornerRadius: 3).cgPath
        self.expertLevelView.layer.cornerRadius = 3
        
        self.textview.layer.shadowColor = UIColor.black.cgColor
        self.textview.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.textview.layer.shadowOpacity = 0.4
        self.textview.layer.shadowRadius = 0.3
        
        self.textview.layer.shadowPath = UIBezierPath(roundedRect: self.textview.bounds, cornerRadius: 3).cgPath
        self.textview.layer.cornerRadius = 3
        self.textview.clipsToBounds = false
        
        
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
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
//        self.view.endEditing(true)
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        slider.setThumbImage(UIImage(named: "slider_dot"), for: UIControlState.normal)
        slider.setThumbImage(UIImage(named: "slider_dot"), for: UIControlState.highlighted)
        if slider.value == 0 {
            self.expertLevelButton.setTitle("BEGINNER", for: UIControlState.normal)
            //            self.beginnerMiddleTextfield.tintColor = UIColor.red
            self.intermediateLeftTextfield.isEnabled = false
            self.intermediateRightTextfield.isEnabled = false
            self.intermediateMiddleTextfield.isEnabled = false
            self.intermediateMiddleButton.isEnabled = false
            self.advanceLeftTextfield.isEnabled = false
            self.advanceRightTextfield.isEnabled = false
            self.advanceMiddleTextfield.isEnabled = false
            self.advanceMiddleButton.isEnabled = false
        }
        else if slider.value == 0.5 {
            self.expertLevelButton.setTitle("INTERMEDIATE", for: UIControlState.normal)
            self.intermediateLeftTextfield.isEnabled = true
            self.intermediateRightTextfield.isEnabled = true
            self.intermediateMiddleTextfield.isEnabled = true
            self.intermediateMiddleButton.isEnabled = true
            self.advanceLeftTextfield.isEnabled = false
            self.advanceRightTextfield.isEnabled = false
            self.advanceMiddleTextfield.isEnabled = false
            self.advanceMiddleButton.isEnabled = false
        }
        else if slider.value == 1 {
            self.expertLevelButton.setTitle("ADVANCE", for: UIControlState.normal)
            self.expertLevelButton.setTitle("INTERMEDIATE", for: UIControlState.normal)
            self.intermediateLeftTextfield.isEnabled = true
            self.intermediateRightTextfield.isEnabled = true
            self.intermediateMiddleTextfield.isEnabled = true
            self.intermediateMiddleButton.isEnabled = true
            self.advanceLeftTextfield.isEnabled = true
            self.advanceRightTextfield.isEnabled = true
            self.advanceMiddleTextfield.isEnabled = true
            self.advanceMiddleButton.isEnabled = true
        }
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if (self.mainCategoryTextfield.text == nil || (self.mainCategoryTextfield.text?.characters.count)! == 0){
            self.alert(message: "Please select main category")
        }
        if (self.subCategoryTextfield.text == nil || (self.subCategoryTextfield.text?.characters.count)! == 0){
            self.alert(message: "Please select sub category")
        }
        if (slider.value == 0) {
            if (self.beginnerLeftTextfield.text == nil || (self.beginnerLeftTextfield.text?.characters.count)! == 0) {
                self.alert(message: "Please enter beginner first field")
            }
            if (self.beginnerRightTextfield.text == nil || (self.beginnerRightTextfield.text?.characters.count)! == 0){
                self.alert(message: "Please enter beginner third field")
            }
        }
        if (slider.value == 0.5){
            if (self.beginnerLeftTextfield.text == nil || (self.beginnerLeftTextfield.text?.characters.count)! == 0) {
                self.alert(message: "Please enter beginner first field")
            }
            if (self.beginnerRightTextfield.text == nil || (self.beginnerRightTextfield.text?.characters.count)! == 0){
                self.alert(message: "Please enter beginner third field")
            }
            if (self.beginnerRightTextfield.text == nil || (self.beginnerRightTextfield.text?.characters.count)! == 0){
                self.alert(message: "Please enter intermediate first field")
            }
            if (self.beginnerRightTextfield.text == nil || (self.beginnerRightTextfield.text?.characters.count)! == 0){
                self.alert(message: "Please enter intermediate third field")
            }
        }
        if (slider.value == 1){
            if (self.beginnerLeftTextfield.text == nil || (self.beginnerLeftTextfield.text?.characters.count)! == 0) {
                self.alert(message: "Please enter beginner first field")
            }
            if (self.beginnerRightTextfield.text == nil || (self.beginnerRightTextfield.text?.characters.count)! == 0){
                self.alert(message: "Please enter beginner third field")
            }
            if (self.beginnerRightTextfield.text == nil || (self.beginnerRightTextfield.text?.characters.count)! == 0){
                self.alert(message: "Please enter intermediate first field")
            }
            if (self.beginnerRightTextfield.text == nil || (self.beginnerRightTextfield.text?.characters.count)! == 0){
                self.alert(message: "Please enter intermediate third field")
            }
            if (self.beginnerRightTextfield.text == nil || (self.beginnerRightTextfield.text?.characters.count)! == 0){
                self.alert(message: "Please enter advance first field")
            }
            if (self.beginnerRightTextfield.text == nil || (self.beginnerRightTextfield.text?.characters.count)! == 0){
                self.alert(message: "Please enter beginner third field")
            }
        }
        if (textview.text.isEmpty || textview.text == "Write about yourself..." || (textview.text?.characters.count)! == 0){
            self.alert(message: "Please Write about yourself")
        }
        else {
            let expertDetailsInput = ExpertDetailsInputDomainModel.init(userId: "31",
                                                                        categoryId: self.mainCategoryTextfield.text!,
                                                                        subCategoryId: self.subCategoryTextfield.text!,
                                                                        qualification: self.qualificationTextfield.text!,
                                                                        about: self.textview.text,
                                                                        beginner: ["Beginner",
                                                                                   self.beginnerLeftTextfield.text!,
                                                                                   self.beginnerMiddleTextfield.text!,
                                                                                   self.beginnerRightTextfield.text!],
                                                                        intermediate:["Intermediate",
                                                                                      self.intermediateLeftTextfield.text!,
                                                                                      self.intermediateMiddleTextfield.text!,
                                                                                      self.intermediateRightTextfield.text!],
                                                                        advance: ["Advance", self.advanceLeftTextfield.text!,
                                                                                  self.advanceMiddleTextfield.text!,
                                                                                  self.advanceRightTextfield.text!])
            
            let APIDataManager: ExpertDetailsProtocol = ExpertDetailsApiDataManager()
            APIDataManager.expertDetails(data:expertDetailsInput,callback: { (result) in
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
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == self.mainCategoryTextfield || textField == self.subCategoryTextfield || textField == self.beginnerMiddleTextfield || textField == self.intermediateMiddleTextfield || textField == self.advanceMiddleTextfield)
        {
            
            var cell = SignupDateCell()
            cell = Bundle.main.loadNibNamed("SignupDateCell", owner: nil, options: nil)?[0] as! SignupDateCell
            cell.doneButton.addTarget(self, action: #selector(inputAccessoryViewDidFinish(button:)), for: .touchUpInside)
            let myToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            cell.frame = myToolbar.frame
            myToolbar.addSubview(cell)
            textField.inputAccessoryView = myToolbar;
            textField.inputAccessoryView?.backgroundColor=UIColor.darkGray
            if textField == self.mainCategoryTextfield {
                cell.centerLabel.text = "Select main Category"
            }
            else if textField == self.subCategoryTextfield {
                cell.centerLabel.text = "Select sub Category"
            }
            else if (textField == self.beginnerMiddleTextfield || textField == self.intermediateMiddleTextfield || textField == self.advanceMiddleTextfield){
                cell.centerLabel.text = "Select Wages"
            }
            self.datePickerArray.removeAllObjects()
            
            
            self.pickerviewExpertDetails.tag = textField.tag
            
            for i in 1..<10{
                var dateLocal = NSString()
                
                dateLocal = NSString(format:"0%d" , i )
                self.datePickerArray .add(dateLocal)
            }
            
            self.pickerviewExpertDetails.reloadAllComponents()
            
        }
        else
        {
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

        return self.datePickerArray.count;
 
    }
    
    // MARK: pickerview delegates
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        

        let title = NSString(format:"%@" , self.datePickerArray[row] as! CVarArg )
        return title as String
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (self.pickerviewExpertDetails.tag == 101) {
            mainCategoryValue = String(describing: self.datePickerArray[row])
            self.mainCategoryTextfield.text = mainCategoryValue
        }
        else if (self.pickerviewExpertDetails.tag == 102){
            subCategoryValue = String(describing: self.datePickerArray[row])
            self.subCategoryTextfield.text = subCategoryValue
        }
        else if (self.pickerviewExpertDetails.tag == 401){
            beginnerMiddleValue = String(describing: self.datePickerArray[row])
            self.beginnerMiddleTextfield.text = beginnerMiddleValue
        }
        else if (self.pickerviewExpertDetails.tag == 402){
            intermediateMiddleValue = String(describing: self.datePickerArray[row])
            self.intermediateMiddleTextfield.text = intermediateMiddleValue
        }
        else if (self.pickerviewExpertDetails.tag == 403){
            advanceMiddleValue = String(describing: self.datePickerArray[row])
            self.advanceMiddleTextfield.text = advanceMiddleValue
        }

//            date = String(describing: self.datePickerArray[row])
        
            //            date = self.datePickerArray[row] as! CVarArg as! String
        
    }
    func inputAccessoryViewDidFinish(button : UIButton) {
        self.view.endEditing(true)
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
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write about yourself..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
    // MARK: SignUp Methods
    func onUserExpertDetailsSucceeded(data: OTPOutputDomainModel) {
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
        self.dismissProgress()
        print("signup data %@",data.message)
        print("signup data %@",data.status)
//        self.showSuccessMessage(message: data.message)
        if data.status {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "AddECreditVC") as UIViewController, animated: true)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    func onUserExpertDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to register the user")
    }
    
    func onUserExpertDetailsFailed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        self.displayErrorMessage(message: data.message)
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
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if ((self.beginnerLeftTextfield != nil) || (self.beginnerRightTextfield != nil) || (self.intermediateLeftTextfield != nil) || (self.intermediateRightTextfield != nil) || (self.advanceLeftTextfield != nil) || (self.advanceRightTextfield != nil)) {
//            let decimalCharacter = NumberFormatter().decimalSeparator
//            let characterSet = NSMutableCharacterSet.decimalDigit()
//            characterSet.addCharacters(in: decimalCharacter!)
//            
//            return replacementString.rangeOfCharacterFromSet(characterSet.invertedSet) == nil
//        } else {
//            return false
//        }
//        
//    }
    
    func callPickerViewMehod(_ textField: UITextField, tag: NSInteger)
    {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
