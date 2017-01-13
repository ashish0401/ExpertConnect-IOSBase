
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
class TeacherFilter: UIViewController, AKSSegmentedSliderControlDelegate {
    var delegate:filteredTeacherListTransferProtocol!
    let emptyArray = NSArray()
    
    var expertDetailsInputDomainModel: ExpertDetailsInputDomainModel!
    var signUpInputDomainModel: SignUpInputDomainModel!
    
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
        // self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 247/255, green: 67/255, blue: 0.0, alpha: 1.0)]
        self.travelKmButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        self.travelKmButton.setTitle("10", for: UIControlState.normal)
        
        self.homeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.instituteCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.travelCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.otherLibraryCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.onlineSkypeCheckboxButton.setImage(checkboxDeselected, for: UIControlState.normal)
        self.setUpDistanceSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.addRightNavigationButtonsOnNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setExpertConnectRedButtonTheme(button: self.travelKmButton)
        self.setExpertConnectRedButtonTheme(button: self.applyButton)
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

            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
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
            self.navigationController?.popViewController(animated: true)
        }
        else{
           // self.displayErrorMessage(message: data.message)
            self.delegate.filterTeachersDataFailed(isFiltered: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onGetTeacherFilterListFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.delegate.filterTeachersDataFailed(isFiltered: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func onGetTeacherFilterListFailed(data:TeacherFilterOutputDomainModel) {
        self.dismissProgress()
        //self.displayErrorMessage(message: data.message)
        self.delegate.filterTeachersDataFailed(isFiltered: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: setUpDistanceSlider method
    func setUpDistanceSlider() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        if(screenWidth == 320) {
            let tempXPosition : Float = Float((self.view.frame.width * 12)/100)
            let xPosition : Int = Int(tempXPosition)
            let yPosition = 20
            
            let tempWidth : Float = Float((self.view.frame.width * 88)/100)
            let width : Int = Int(tempWidth)
            let height = 20
            
            let tempSpaceBetweenPoints : Float = Float((self.view.frame.width * 14)/100)
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
            sliderControl.numberOfPoints = 5
            self.customSliderView.addSubview(sliderControl)
        } else {
            
            let tempXPosition : Float = Float((self.view.frame.width * 12)/100)
            let xPosition : Int = Int(tempXPosition)
            let yPosition = 20
            
            let tempWidth : Float = Float((self.view.frame.width * 88)/100)
            let width : Int = Int(tempWidth)
            let height = 20
            
            let tempSpaceBetweenPoints : Float = Float((self.view.frame.width * 15)/100)
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
            sliderControl.numberOfPoints = 5
            self.customSliderView.addSubview(sliderControl)
            //sliderControl.backgroundColor = UIColor.red
        }
    }
    
    // MARK: DistanceSlider Delegate method
    func timeSlider(_ timeSlider: AKSSegmentedSliderControl! , didSelectPointAtIndex index:Int) -> Void  {
        print(index)
        var sliderIntValue = Int()
        if index == 0 {
            sliderIntValue = 10
        }
        if index == 1 {
            sliderIntValue = 20
        }
        if index == 2 {
            sliderIntValue = 30
        }
        if index == 3 {
            sliderIntValue = 40
        }
        if index == 4 {
            sliderIntValue = 50
        }
        self.travelKmButton.setTitle(NSString(format:"%d", sliderIntValue) as String , for: UIControlState.normal)
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
