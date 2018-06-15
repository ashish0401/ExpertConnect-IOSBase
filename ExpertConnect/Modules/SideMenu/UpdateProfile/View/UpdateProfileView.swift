//
//  UpdateProfileView.swift
//  ExpertConnect
//
//  Created by Redbytes on 02/02/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import GooglePlacePicker
import GoogleMaps
import GooglePlaces

protocol UpdateProfileDelegate {
    func updateProfileSucceded(showAlert:Bool, message: String) -> Void
}

class UpdateProfileView: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    var delegate:UpdateProfileDelegate!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var cell = SignupDateCell()
    var date = String()
    var month = String()
    var year = String()
    var pickerview = UIPickerView()
    var datePickerArray = NSMutableArray()
    var monthPickerArray = NSMutableArray()
    var yearPickerArray = NSMutableArray()
    var userId: String = ""
    var userType: String = ""
    var lattitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var cityName : String = ""
    @IBOutlet var scrollview: TPKeyboardAvoidingScrollView!
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var firstNameTextfield: UITextField!
    @IBOutlet var lastNameTextfield: UITextField!
    @IBOutlet var EmailTextfield: UITextField!
    @IBOutlet var DOBTextfield: UITextField!
    @IBOutlet var locationTextfield: UITextField!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    let locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateUpdateProfileBackIcon(delegate: self)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.navigationItem.title = "Edit Profile"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        imagePicker.delegate = self
        self.DOBTextfield.delegate = self
        self.EmailTextfield.delegate = self
        self.locationTextfield.delegate = self
        self.scrollview.delegate = self
        date = NSString(format:"%@", "01") as String
        month = NSString(format:"%@", "01") as String as String
        year = NSString(format:"%@", "1950") as String
        self.getCurrentLocation()
        self.setupProfileData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let originalImage = UIImage(named:"location_icon")
        let tintedImage = originalImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        locationButton.setImage(tintedImage, for: .normal)
        locationButton.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.profileImageview.layer.cornerRadius = self.profileImageview.frame.size.width/2
        self.profileImageview.layer.masksToBounds = true
        self.profileImageview.clipsToBounds = true
        if let userProfileData = UserDefaults.standard.value(forKey: "UserProfileData") as? Data {
            self.profileImageview.image = UIImage(data: userProfileData as Data)
        }
        let image: UIImage? = selectedImage
        if image != nil {
            self.profileImageview.image = selectedImage
        } else {
            self.profileImageview.image = UIImage(named:"default_profile_pic")!
        }
        self.setExpertConnectRedButtonTheme(button: self.locationButton)
        self.setExpertConnectRedButtonTheme(button: self.nextButton)
        self.setExpertConnectTextFieldTheme(textfield: self.locationTextfield)
        self.locationTextfield.layer.borderColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfileData() {
        self.firstNameTextfield.text = UserDefaults.standard.value(forKey: "firstname") as! String?
        self.lastNameTextfield.text = UserDefaults.standard.value(forKey: "lastname") as! String?
        self.EmailTextfield.text = UserDefaults.standard.value(forKey: "email_id") as! String?
        self.DOBTextfield.text = UserDefaults.standard.value(forKey: "dob") as! String?
        self.locationTextfield.text = UserDefaults.standard.value(forKey: "Location") as! String?
        if let userProfileData = UserDefaults.standard.value(forKey: "UserProfileData") as? Data {
            selectedImage = UIImage(data: userProfileData as Data)
        } else {
            selectedImage = UIImage(named: "default_profile_pic")
        }
    }
    
    func updateProfileBackMenuBarTapped() {
        self.view.endEditing(true)
        var isProfileChanged: Bool = false
        if(self.firstNameTextfield.text != UserDefaults.standard.value(forKey: "firstname") as! String?) {
            isProfileChanged = true
        }
        if(self.lastNameTextfield.text != UserDefaults.standard.value(forKey: "lastname") as! String?) {
            isProfileChanged = true
        }
        if(self.EmailTextfield.text != UserDefaults.standard.value(forKey: "email_id") as! String?) {
            isProfileChanged = true
        }
        if(self.DOBTextfield.text != UserDefaults.standard.value(forKey: "dob") as! String?) {
            isProfileChanged = true
        }
        if(self.locationTextfield.text != UserDefaults.standard.value(forKey: "Location") as! String?) {
            isProfileChanged = true
        }
        if let userProfileData = UserDefaults.standard.value(forKey: "UserProfileData") as? Data {
            if let currentImage = UIImage(data: userProfileData as Data) {
                let currentImageData = UIImagePNGRepresentation(currentImage)
                let compareImageData = UIImagePNGRepresentation(selectedImage!)
                if let empty = currentImageData, let compareTo = compareImageData {
                    if(empty != compareTo) {
                        // Empty image is the same as image1.image
                        isProfileChanged = true
                    }
                }
            }
        } else if let currentImage = UIImage(named: "default_profile_pic") {
            let currentImageData = UIImagePNGRepresentation(currentImage)
            let compareImageData = UIImagePNGRepresentation(selectedImage!)
            
            if let empty = currentImageData, let compareTo = compareImageData {
                if(empty != compareTo) {
                    // Empty image is the same as image1.image
                    isProfileChanged = true
                }
            }
        }
        
        if(isProfileChanged) {
            self.askForSaveIfUserIsSure()
            
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func askForSaveIfUserIsSure() {
        let message = "unsavedChangesAlert".localized(in: "UpdateProfileView")
        let cancel = "No".localized(in: "UpdateProfileView")
        let ok = "Yes".localized(in: "UpdateProfileView")
        
        let saveAlert = UIAlertController(title: "Unsaved changes", message: message, preferredStyle: .alert)
        saveAlert.addAction(UIAlertAction(title: ok, style: .default, handler: { (action: UIAlertAction!) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        saveAlert.addAction(UIAlertAction(title: cancel, style: .default, handler: nil))
        self.present(saveAlert, animated: true, completion: nil)
    }
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: editProfile button click methods
    @IBAction func editProfileButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.alertControllerAction(sender: sender)
    }
    
    // MARK: image picker methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if imagePicker.sourceType == UIImagePickerControllerSourceType.camera {
            dismiss(animated: true, completion: nil)
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.profileImageview.image = selectedImage
        }
        else if imagePicker.sourceType == UIImagePickerControllerSourceType.photoLibrary {
            
            dismiss(animated: true, completion: nil)
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.profileImageview.image = selectedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: alert Controller method
    @IBAction func alertControllerAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Profile Pic (Optional)", message: "", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("Ok Button Pressed")
            self.takePhoto()
        })
        let ok1 = UIAlertAction(title: "Choose from Gallery", style: .default, handler: { (action) -> Void in
            print("Ok Button Pressed")
            self.openPhotoGallery()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
        })
        alertController.addAction(ok)
        alertController.addAction(ok1)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openPhotoGallery()  {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: location Button method
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        let message = "Getting Locations".localized(in: "SignUp")
        self.displayProgress(message: message)
        self.setCurrentLocationOnPlacePicker()
    }
    
    // MARK: next Button method
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        //        self.view.endEditing(true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if !self.userNameValidation(string: self.firstNameTextfield.text!) {
            let message = "Please Enter Valid Firstname".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if !self.userNameValidation(string: self.lastNameTextfield.text!) {
            let message = "Please Enter Valid Lastname".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if(!self.isValidEmail()) {
            let message = "Please Enter Valid Email".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if  (self.DOBTextfield.text == nil || (self.DOBTextfield.text?.characters.count)! == 0){
            let message = "Please Enter Date Of Birth".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        }
        if  (self.locationTextfield.text == nil || (self.locationTextfield.text?.characters.count)! == 0) {
            let message = "Please Select Location".localized(in: "SignUp")
            self.displayErrorMessage(message: message)
            return
        } else {
            
            var userPrifilePic: String
            let image: UIImage? = selectedImage
            if image != nil {
                selectedImage = (selectedImage?.fixedOrientation())
                userPrifilePic = (selectedImage?.convertImageToBase64(image: selectedImage!))! as String
            } else {
                userPrifilePic = ""
            }
            let lattitudeString = String(format: "%f", self.lattitude)
            let longitudeString = String(format: "%f", self.longitude)
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
            let updateProfileViewInputDomainModel = UpdateProfileViewInputDomainModel.init(userId: self.userId,
                                                                                           userType: self.userType,
                                                                                           firstName: self.firstNameTextfield.text!,
                                                                                           lastName: self.lastNameTextfield.text!,
                                                                                           emailId: self.EmailTextfield.text!,
                                                                                           dob: self.DOBTextfield.text!,
                                                                                           profilePic: userPrifilePic,
                                                                                           latitude: lattitudeString,
                                                                                           longitude: longitudeString,
                                                                                           location: self.locationTextfield.text!)
            let message = "Updating profile".localized(in: "UpdateProfileView")
            self.displayProgress(message: message)
            let APIDataManager: UpdateProfileViewProtocol = UpdateProfileViewApiDataManager()
            APIDataManager.updateProfile(data: updateProfileViewInputDomainModel, callback: { (result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onUpdateProfileFailed(error: error)
                case .Success(let data as CoachingDetailsOutputDomainModel):
                    self.onUpdateProfileResponce(data: data)
                default:
                    break
                }
            })
        }
    }
    
    // MARK: Verify OTP Methods
    func onUpdateProfileResponce(data:CoachingDetailsOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            let userInfo = ["CoachingDetailsOutputDomainModel": data] as [String: Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.ExpertConnect.Signup"), object: nil, userInfo:userInfo)
            self.delegate.updateProfileSucceded(showAlert: true, message: "Your profile updated successfully".localized(in: "UpdateProfileView"))
            self.view.endEditing(true)
            _ = self.navigationController?.popViewController(animated: true)
            
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onUpdateProfileFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "profile update failed")
    }
    
    // MARK: Validation method
    func userNameValidation(string: String) -> Bool {
        let emailRegex = "[a-zA-z]+([ '-][a-zA-Z]+)*$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: string)
    }
    func isValidateDOB(string: NSString) -> Bool {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return true
    }
    
    // MARK: textfield delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.locationTextfield {
            self.view.endEditing(true)
            let message = "Getting Locations".localized(in: "SignUp")
            self.displayProgress(message: message)
            self.setCurrentLocationOnPlacePicker()
            return false
        }
        if textField == self.DOBTextfield {
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.year = -112
            let hundredYearAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            dateComponents.year = -12
            let twelveYearAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            
            DatePickerDialog().show("Select Date Of Birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: hundredYearAgo, maximumDate: twelveYearAgo, datePickerMode: .date) { (date) in
                if let FullDateObject = date {
                    let tempDate = "\(FullDateObject)"
                    if (tempDate == "" || tempDate.characters.count == 0 || tempDate == "nil") {
                        self.DOBTextfield.text = ""
                        return
                    }
                    self.DOBTextfield.text = FullDateObject.ToLocalStringWithFormat(dateFormat: "yyyy-MM-dd")
                }
            }
            return false
        } else {
            textField.inputAccessoryView = nil;
            textField.inputAccessoryView?.backgroundColor=UIColor.clear
        }
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
    
    func isValidEmail() -> Bool {
        if getEmailText().isEmpty { return false }
        let factory = ValidatorFactory()
        let validator = factory.create(type: EInputType.EMAIL)
        return validator.isValid(text: getEmailText())
    }
    func getEmailText() -> String! {
        if let _ = self.EmailTextfield.text {
            return self.EmailTextfield.text
        } else {
            return ""
        }
    }
    
    // MARK: PlacePicker Method
    func setCurrentLocationOnPlacePicker() {
        let placesClient = GMSPlacesClient()
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            self.dismissProgress()
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                self.displayErrorMessage(message: "Pick Place error: \(error.localizedDescription)")
                return
            }
            if let placeLikelihoodList = placeLikelihoodList {
                if(placeLikelihoodList.likelihoods.count == 0)
                {
                    self.getDefaultLocation()
                } else {
                    for likelihood in placeLikelihoodList.likelihoods {
                        let place = likelihood.place
                        self.getLocation(place: place)
                        
                        print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                        print("Current Place address \(place.formattedAddress)")
                        print("Current Place attributions \(place.attributions)")
                        print("Current PlaceID \(place.placeID)")
                        break
                    }
                }
            }
        })
    }
    
    func getLocation(place: GMSPlace) {
        let center = place.coordinate
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                self.displayErrorMessage(message: "Pick Place error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                let coordinates = place.coordinate
                self.lattitude = place.coordinate.latitude
                self.longitude = place.coordinate.longitude
                self.setUsersClosestCity()
            } else {
            }
        })
    }
    
    func getDefaultLocation() {
        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                self.displayErrorMessage(message: "Pick Place error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                let coordinates = place.coordinate
                self.lattitude = place.coordinate.latitude
                self.longitude = place.coordinate.longitude
                self.setUsersClosestCity()
            } else {
            }
        })
    }
    
    func setUsersClosestCity()
    {
        let message = "Updating Location".localized(in: "SignUp")
        self.displayProgress(message: message)
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.lattitude, longitude: self.longitude)
        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            self.dismissProgress()
            let placeArray = placemarks as [CLPlacemark]!
            if((placeArray?.count)! > 0) {
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                if placeMark.addressDictionary != nil {
                    // Location name
                    if let locationName = placeMark.addressDictionary?["Name"] as? NSString {
                        print(locationName)
                    }
                    // Street address
                    if let street = placeMark.addressDictionary?["Thoroughfare"] as? NSString {
                        print(street)
                    }
                    // City
                    if let city = placeMark.addressDictionary?["City"] as? NSString {
                        print("City Place : \(city)")
                        self.cityName = city as String
                        self.locationTextfield.text = self.cityName
                    }
                    // Zip code
                    if let zip = placeMark.addressDictionary?["ZIP"] as? NSString {
                        print(zip)
                    }
                    // Country
                    if let country = placeMark.addressDictionary?["Country"] as? NSString {
                        print(country)
                    }
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
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
