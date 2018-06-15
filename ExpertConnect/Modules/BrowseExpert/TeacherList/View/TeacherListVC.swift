
//
//  TeacherListVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 17/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos
class TeacherListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, filteredTeacherListTransferProtocol,UITextFieldDelegate,CustomIOS7AlertViewDelegate, UITextViewDelegate {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var totalCountBaseView: UIView!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    var teacherListArray = NSMutableArray()
    var filteredTeacherListArray = NSMutableArray()
    var ratedByArray = Array<Any>()

    var isFiltered: Bool = false
    var userId = String()
    var receiverId = String()
    var expertId = String()
    var requestId = String()
    let alertView = CustomIOS7AlertView()
    var categoryId = String()
    var subCategoryId = String()
    var expertLevel = String()
    var expertiseString = String()
    var tempExpertId = Int()
    
    var teacherNameHeight = CGFloat()
    
    var expertiseStaticHeight = CGFloat()
    var expertiseHeight = CGFloat()
    
    var feeStaticHeight = CGFloat()
    var feeHeight = CGFloat()
    
    var genderStaticHeight = CGFloat()
    var genderHeight = CGFloat()
    
    
    var locationStaticHeight = CGFloat()
    var locationHeight = CGFloat()
    
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)
    let teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+40+76))
    
    let expertiseStaticWidth : CGFloat = 62
    let expertiseWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+62+8+22))
    
    let feeStaticWidth : CGFloat = 28
    let feeWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+28+8+22))
    
    let genderStaticWidth : CGFloat = 51
    let genderWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+51+8+22))
    
    let locationStaticWidth : CGFloat = 58
    let locationWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+58+8+22))

    var alertActionType = String()
    let buttonsForSendMessage = ["SEND"]
    var messageTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        self.activateFilterIcon()
        print(teacherListArray)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.makeTableSeperatorColorClear()
        self.totalCountLabel.textColor = UIColor.ExpertConnectGray
        self.lineView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Teacher List"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        if(self.filteredTeacherListArray.count == 0 && isFiltered) {
            self.displayErrorMessage(message: "No teacher list found in the database")
            self.isFiltered = Bool.init(false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.setExpertConnectShadowTheme(view: self.totalCountBaseView)
    }
    
    // MARK: Add Filter Button method
    func activateFilterIcon() {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter_btn")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(filterButtonClicked(button:)))
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(rightButton)
        } else {
            self.navigationItem.rightBarButtonItem = rightButton
        }
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.ExpertConnectRed
    }
    
    // MARK: Filter Button Click method
    func filterButtonClicked(button: UIButton) {
        self.view.endEditing(true)
        let teacherFilterObj : TeacherFilter = UIStoryboard(name: "TeacherFilter", bundle: nil).instantiateViewController(withIdentifier: "TeacherFilter") as UIViewController as! TeacherFilter
        if self.teacherListArray.count == 0 {
            self.displayErrorMessage(message: "No teacher list found in the database")
        }
        else{
            teacherFilterObj.delegate = self
            teacherFilterObj.categoryId = self.categoryId
            teacherFilterObj.subCategoryId = self.subCategoryId
            teacherFilterObj.expertLevel = self.expertLevel
            self.navigationController?.pushViewController(teacherFilterObj, animated: true)
        }
    }
    
    // MARK: TeacherFilter Delegate method
    func filterTeachersDataSucceeded(filteredTeacherListArray:NSArray, isFiltered:Bool) {
        if filteredTeacherListArray.count != 0 {
            self.filteredTeacherListArray = NSMutableArray.init(array: filteredTeacherListArray)
            self.isFiltered = isFiltered
            self.tableview.reloadData()
        } else {
            self.filteredTeacherListArray.removeAllObjects()
            self.isFiltered = isFiltered
            self.tableview.reloadData()
            //self.displayErrorMessage(message: "Notifications are not available")
        }
    }
    
    func filterTeachersDataFailed(isFiltered:Bool) {
        self.filteredTeacherListArray.removeAllObjects()
        self.isFiltered = isFiltered
        self.tableview.reloadData()
        //self.displayErrorMessage(message: "Notifications are not available")
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isFiltered {
            let aStr = String(format: "%d Expert(s) available to connect with",self.filteredTeacherListArray.count)
            self.totalCountLabel.text = aStr
            
            return self.filteredTeacherListArray.count
        }
        let aStr = String(format: "%d Expert(s) available to connect with",self.teacherListArray.count)
        self.totalCountLabel.text = aStr
        
        return self.teacherListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "TeacherListCell"
        var cell: TeacherListCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TeacherListCell
        if cell == nil {
            tableView.register(TeacherListCell.self, forCellReuseIdentifier: "TeacherListCell")
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TeacherListCell
        }
        
        var dic = NSDictionary()
        if isFiltered {
            dic = self.filteredTeacherListArray[indexPath.row] as! NSDictionary
        }
        else {
            dic = self.teacherListArray[indexPath.row] as! NSDictionary
        }
        
        cell.requestButton.tag = indexPath.row
        cell.requestButton.addTarget(self, action: #selector(sendMessageButtonClicked(button:)), for: .touchUpInside)
        
        let firstName: String = dic.value(forKey: "firstname") as! String
        let lastName: String = dic.value(forKey: "lastname") as! String
        let firstNameWithSpace = firstName.appending(" ")
        let teacherName = firstNameWithSpace.appending(lastName)
        cell.teacherNameLabel.text = teacherName
        
        cell.profileImageview.image = UIImage(named: "profile_rectangle_img")
        if (dic.value(forKey: "profile_pic") as! String != "") {
            let url = URL(string: dic.value(forKey: "profile_pic") as! String)
            cell.profileImageview.kf.setImage(with: url)
        }
        cell.expertiseLabel.text = self.expertiseString
        let feesString = dic.value(forKey: "base_price") as! String
        cell.feeLabel.text = "AU$ \(feesString)"
        
        cell.locationLabel.text = dic.value(forKey: "location") as! String?
        // collecting venues in coachingVenueArray
        let ratingDetails : NSArray = dic.value(forKey: "teacher_rating") as! NSArray
        var ratingArray = Array<Any>()
        for rating in ratingDetails {
            let str:NSDictionary = rating as! NSDictionary
            self.ratedByArray.append(str.value(forKey: "teacherRatedBy") as! String)
            ratingArray.append(str.value(forKey: "overallTeacherRating") as! String)
        }
        if(ratingArray.count > 0) {
            cell.starView.rating = Double(ratingArray[0]  as! String)!
            cell.starView.settings.fillMode = .precise 
        } else {
            cell.starView.rating = Double("0")!
            cell.starView.settings.fillMode = .precise
        }

        cell.genderLabel.text = dic.value(forKey: "gender") as! String?
        
        teacherNameHeight = (cell.teacherNameLabel.text?.heightForView(text: cell.teacherNameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: teacherNameWidth))!
        
        expertiseStaticHeight = (cell.expertiseStaticLabel.text?.heightForView(text: cell.expertiseStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: expertiseStaticWidth))!
        expertiseHeight = (cell.expertiseLabel.text?.heightForView(text: (cell.expertiseLabel.text)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: expertiseWidth))!
        
        feeStaticHeight = (cell.feeStaticLabel.text?.heightForView(text: cell.feeStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:feeStaticWidth))!
        feeHeight = (cell.feeLabel.text?.heightForView(text: cell.feeLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: feeWidth))!
        
        genderStaticHeight = (cell.genderStaticLabel.text?.heightForView(text: cell.genderStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:genderStaticWidth))!
        genderHeight = (cell.genderLabel.text?.heightForView(text: cell.genderLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: genderWidth))!
        
        locationStaticHeight = (cell.locationStaticLabel.text?.heightForView(text: cell.locationStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationStaticWidth))!
        locationHeight = (cell.locationLabel.text?.heightForView(text: cell.locationLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationWidth))!
        
        cell.teacherNameLabel.removeConstraints(cell.teacherNameLabel.constraints)
        cell.starView.removeConstraints(cell.starView.constraints)
        
        cell.expertiseStaticLabel.removeConstraints(cell.expertiseStaticLabel.constraints)
        cell.expertiseLabel.removeConstraints(cell.expertiseLabel.constraints)
        
        cell.feeStaticLabel.removeConstraints(cell.feeStaticLabel.constraints)
        cell.feeLabel.removeConstraints(cell.feeLabel.constraints)
        
        cell.genderStaticLabel.removeConstraints(cell.genderStaticLabel.constraints)
        cell.genderLabel.removeConstraints(cell.genderLabel.constraints)
        
        cell.locationStaticLabel.removeConstraints(cell.locationStaticLabel.constraints)
        cell.locationLabel.removeConstraints(cell.locationLabel.constraints)
        
        let screenSize: CGRect = UIScreen.main.bounds
        var screenWidth = screenSize.width * 0.30
        let height = screenSize.size.height
        
        switch height {
        case 480.0:
            print("iPhone 3,4")
            screenWidth = screenSize.width * 0.40
        case 568.0:
            print("iPhone 5")
            screenWidth = screenSize.width * 0.40
        case 667.0:
            print("iPhone 6")
            screenWidth = screenSize.width * 0.40
        case 736.0:
            print("iPhone 6+")
            screenWidth = screenSize.width * 0.40
        default:
            print("not an iPhone")
        }

        self.setConstraints(actualView: cell.teacherNameLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 40, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 10, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setConstraints(actualView: cell.starView, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 39, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 8, height: 20, width: 50, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.expertiseStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: expertiseStaticHeight, width: expertiseStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.expertiseLabel, leadingView: cell.expertiseStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: expertiseHeight, width: expertiseWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if expertiseHeight > expertiseStaticHeight {
            self.setConstraints(actualView: cell.feeStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: cell.feeLabel, leadingView: cell.feeStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeHeight, width: feeWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            //Gender
            self.setConstraints(actualView: cell.genderStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: screenSize.size.width - screenWidth, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderStaticHeight, width: genderStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            
            self.setConstraints(actualView: cell.genderLabel, leadingView: cell.genderStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderHeight, width: genderWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
        } else {
            self.setConstraints(actualView: cell.feeStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: cell.feeLabel, leadingView: cell.feeStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.expertiseStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeHeight, width: feeWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            //Gender
            self.setConstraints(actualView: cell.genderStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: screenSize.size.width - screenWidth, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderStaticHeight, width: genderStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            
            self.setConstraints(actualView: cell.genderLabel, leadingView: cell.genderStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.expertiseStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderHeight, width: genderWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        }
        
        self.setConstraints(actualView: cell.locationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.feeLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.locationLabel, leadingView: cell.locationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.feeLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationHeight, width: locationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setECTableViewCellShadowTheme(view: cell.mainView)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let height = (22)+(teacherNameHeight)+(8)+(20)+(10)+(expertiseHeight)+(4)+(feeHeight)+(4)+(locationHeight)+(22)
        return height
    }
    
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int ) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if !UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            //Go to login screen
            // self.navigationController!.pushViewController(LoginWireFrame.setupLoginModule() as UIViewController, animated: false)
            let loginView = LoginWireFrame.setupLoginModule() as UIViewController
            let navController = UINavigationController(rootViewController: loginView)
            self.present(navController, animated: true, completion: nil)
            loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        } else {
            let teacherDetailView : TeacherDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeacherDetailView") as UIViewController as! TeacherDetailView
            var dic = NSDictionary()
            if isFiltered {
                dic = self.filteredTeacherListArray[indexPath.row] as! NSDictionary
            }
            else {
                dic = self.teacherListArray[indexPath.row] as! NSDictionary
            }

            teacherDetailView.techerDetail = dic
            self.navigationController?.pushViewController(teacherDetailView, animated: true)
        }
    }
    
    // MARK: Send Message Button Click method
    func sendMessageButtonClicked(button: UIButton) {
        if !UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            //Go to login screen
            let loginView = LoginWireFrame.setupLoginModule() as UIViewController
            let navController = UINavigationController(rootViewController: loginView)
            self.present(navController, animated: true, completion: nil)
            loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        } else {
            var dic = NSDictionary()
            if isFiltered {
                dic = self.filteredTeacherListArray[button.tag] as! NSDictionary
            }
            else {
                dic = self.teacherListArray[button.tag] as! NSDictionary
            }
            self.receiverId = dic.value(forKey: "user_id") as! String

            alertActionType = "sendMesageAction"
            alertView.buttonTitles = buttonsForSendMessage
            // Set a custom container view
            alertView.containerView = createContainerViewForForgotPassword()
            // Set self as the delegate
            alertView.delegate = self
            // Show time!
            alertView.catchString(withString: "4")
            alertView.show()
        }
    }
    
    // MARK: Request Button Click method
    func requestButtonClicked(button: UIButton) {
        self.view.endEditing(true)
        let index = button.tag
        let dic : NSDictionary = teacherListArray[index] as! NSDictionary
        self.requestId = dic.value(forKey: "user_id") as! String
        self.expertId = dic.value(forKey: "expert_id") as! String
        self.categoryId = dic.value(forKey: "category_id") as! String
        self.subCategoryId = dic.value(forKey: "sub_category_id") as! String
        
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Processing".localized(in: "SignUp")
        self.displayProgress(message: message)
        
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        let sendRequestModel = SendRequestDomainModel.init(fromId: self.userId, toId: self.requestId, type: "request", expertId: self.expertId, categoryId: self.categoryId, subCategoryId: self.subCategoryId)
        self.tempExpertId = Int(self.expertId)!
        let APIDataManager : SendRequestProtocols = SendRequestApiDataManager()
        APIDataManager.sendRequest(data: sendRequestModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onSendRequestFailed(error: error)
            case .Success(let data as SendRequestOutputDomainModel):
                do {
                    self.onRequSendestSucceeded(data: data, button: button)
                } catch {
                    self.onSendRequestFailed(data: data)
                }
            default:
                break
            }
        })
    }
    
    // MARK: Request API Response methods
    func onRequSendestSucceeded(data: SendRequestOutputDomainModel, button: UIButton) {
        self.dismissProgress()
        
        if data.status {
            let index = button.tag
            if self.isFiltered {
                let dic : NSDictionary = self.filteredTeacherListArray[index] as! NSDictionary
                let foundationDictionary = NSMutableDictionary(dictionary: dic)
                foundationDictionary["flag"] = 1
                self.filteredTeacherListArray[index] = foundationDictionary
            }
            else {
                let dic : NSDictionary = self.teacherListArray[index] as! NSDictionary
                let foundationDictionary = NSMutableDictionary(dictionary: dic)
                foundationDictionary["flag"] = 1
                self.teacherListArray[index] = foundationDictionary
            }
            self.tableview.reloadData()
            
            let alertMessage = "Your request has been sent successfully.".localized(in: "Localizable")
            alertView.containerView = createContainerView(requestSuccessMessage: alertMessage)
            alertView.catchString(withString: "AlertForRequest/Accept/Reject")
            alertView.show()
            
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onSendRequestFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed To Send Request")
    }
    
    func onSendRequestFailed(data:SendRequestOutputDomainModel) {
        self.dismissProgress()
        self.displayErrorMessage(message: data.message)
    }
    
    // MARK: Custom Alert view method
    func createContainerView(requestSuccessMessage: String) -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 150))
        let label = UILabel(frame: CGRect(x: 20, y: 80, width: 240, height: 50))
        label.text = requestSuccessMessage
        //label.text = "Your request has been sent successfully."
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center;
        
        label.font =  UIFont(name: "Raleway-Medium", size: 18)
        label.textColor = UIColor.ExpertConnectBlack
        label.textAlignment = NSTextAlignment.center
        View.addSubview(label)
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 246, y: 0, width: 44, height: 44)
        closeButton.addTarget(self, action: #selector(alertViewCloseButtonClicked(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        closeButton.layer.cornerRadius = 3
        View.addSubview(closeButton)
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 0.3
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 3).cgPath
        view.layer.cornerRadius = 3
        
        return View;
    }
    
    // MARK: Custom Alert view close button method
    func alertViewCloseButtonClicked(button: UIButton) {
        alertView.close()
    }
    
    // MARK: TeacherList API Response methods
    func ongetTeacherListSucceeded(data: TeacherListOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.teacherListArray = NSMutableArray.init(array: data.categories as! [Any])
            self.tableview.reloadData()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func ongetTeacherListFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "No teacher list found in the database")
    }
    
    func ongetTeacherListFailed(data:TeacherListOutputDomainModel) {
        self.dismissProgress()
        self.displayErrorMessage(message: data.message)
    }
    
    // MARK: Set Constraints method
    func setConstraintsForFeeLabel(actualView:UIView, leadingView:UIView, leadingAttributeForActualView:NSLayoutAttribute, leadingAttributeForLeadingView:NSLayoutAttribute, leadingViewConstant:CGFloat, trailingView:UIView, trailingAttributeForActualView:NSLayoutAttribute, trailingAttributeForTrailingView:NSLayoutAttribute, trailingViewConstant:CGFloat, upperView:UIView, upperAttributeForActualView:NSLayoutAttribute, upperAttributeForUpperView:NSLayoutAttribute, upperViewConstant:CGFloat, height:CGFloat, width:CGFloat, upperSpaceConstraint:Bool, leadingMarginConstraint:Bool, trailingMarginConstraint:Bool) {
        
        actualView.translatesAutoresizingMaskIntoConstraints = false
        /** remove constraints of reusable cell*/
        actualView.removeConstraints(actualView.constraints)
        /** end - remove constraints of reusable cell*/
        
        print("height : %d", height)
        let heightConstraint = NSLayoutConstraint(item: actualView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(height))
        
        print("heightConstraint : %d", heightConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: actualView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
        
        
        actualView.addConstraints([heightConstraint,widthConstraint])
        
        var leadingMargin : NSLayoutConstraint!
        var trailingMargin : NSLayoutConstraint!
        var upperSpace : NSLayoutConstraint!
        if leadingMarginConstraint {
            leadingMargin = NSLayoutConstraint(item: actualView, attribute: leadingAttributeForActualView,
                                               relatedBy: NSLayoutRelation.equal, toItem: leadingView,
                                               attribute: leadingAttributeForLeadingView, multiplier: 1, constant: leadingViewConstant)
            NSLayoutConstraint.activate([leadingMargin])
        }
        if trailingMarginConstraint {
            trailingMargin = NSLayoutConstraint(item: trailingView, attribute: trailingAttributeForTrailingView,
                                                relatedBy: NSLayoutRelation.equal, toItem: actualView,
                                                attribute: trailingAttributeForActualView, multiplier: 1, constant: trailingViewConstant)
            NSLayoutConstraint.activate([trailingMargin])
        }
        if upperSpaceConstraint {
            upperSpace = NSLayoutConstraint(item: actualView, attribute: upperAttributeForActualView, relatedBy: .equal, toItem: upperView, attribute: upperAttributeForUpperView, multiplier: 1, constant: upperViewConstant)
            NSLayoutConstraint.activate([upperSpace])
        }
        print("y : %d", upperSpace)
        print("y : %d , height : %d", actualView.frame.origin.y, actualView.frame.size.height)
    }
    
    func setConstraints(actualView:UIView, leadingView:UIView, leadingAttributeForActualView:NSLayoutAttribute, leadingAttributeForLeadingView:NSLayoutAttribute, leadingViewConstant:CGFloat, trailingView:UIView, trailingAttributeForActualView:NSLayoutAttribute, trailingAttributeForTrailingView:NSLayoutAttribute, trailingViewConstant:CGFloat, upperView:UIView, upperAttributeForActualView:NSLayoutAttribute, upperAttributeForUpperView:NSLayoutAttribute, upperViewConstant:CGFloat, height:CGFloat, width:CGFloat, upperSpaceConstraint:Bool, leadingMarginConstraint:Bool, trailingMarginConstraint:Bool) {
        
        actualView.translatesAutoresizingMaskIntoConstraints = false
        
        /** remove constraints of reusable cell*/
        actualView.removeConstraints(actualView.constraints)
        /** end - remove constraints of reusable cell*/
        
        let heightConstraint = NSLayoutConstraint(item: actualView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(height))
        
        let widthConstraint = NSLayoutConstraint(item: actualView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
        
        NSLayoutConstraint.activate([heightConstraint,widthConstraint])
        
        var leadingMargin : NSLayoutConstraint!
        var trailingMargin : NSLayoutConstraint!
        var upperSpace : NSLayoutConstraint!
        if leadingMarginConstraint {
            leadingMargin = NSLayoutConstraint(item: actualView, attribute: leadingAttributeForActualView,
                                               relatedBy: NSLayoutRelation.equal, toItem: leadingView,
                                               attribute: leadingAttributeForLeadingView, multiplier: 1, constant: leadingViewConstant)
            NSLayoutConstraint.activate([leadingMargin])
        }
        if trailingMarginConstraint {
            trailingMargin = NSLayoutConstraint(item: trailingView, attribute: trailingAttributeForTrailingView,
                                                relatedBy: NSLayoutRelation.equal, toItem: actualView,
                                                attribute: trailingAttributeForActualView, multiplier: 1, constant: trailingViewConstant)
            NSLayoutConstraint.activate([trailingMargin])
        }
        if upperSpaceConstraint {
            upperSpace = NSLayoutConstraint(item: actualView, attribute: upperAttributeForActualView, relatedBy: .equal, toItem: upperView, attribute: upperAttributeForUpperView, multiplier: 1, constant: upperViewConstant)
            NSLayoutConstraint.activate([upperSpace])
        }
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage(message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Custom Alert Delegates
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        //  print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        if alertActionType == "sendMesageAction" {
            
            if (self.messageTextView.text == nil || (self.messageTextView.text?.characters.count)! == 0) {
                let message = "Please write your message"
                alertView.close()
                self.displayErrorMessageWithCallback(message: message)
                return
            }
            //Send Message
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let textMessage = self.messageTextView.text!
            if (!self.isInternetAvailable()) {
                let message = "No Internet Connection".localized(in: "ManageExpertise")
                self.displayErrorMessage(message: message)
                return
            }
            let message = "Sending Message".localized(in: "BrowseExpertsVC")
            self.displayProgress(message: message)
            let sendMessageInputModel = SendMessageInputModel.init(senderId: self.userId, receiverId: self.receiverId, message: textMessage.trimmingCharacters(in: .whitespacesAndNewlines))
            let APIDataManager : BrowseExpertListProtocols = BrowseExpertListApiDataManager()
            APIDataManager.sendMessage(data: sendMessageInputModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onSendMessageFailed(error: error)
                    break
                    
                case .Success(let data as OTPOutputDomainModel):
                    self.onSendMessageSucceed(data: data)
                    break
                    
                default:
                    break
                }
            })
            //presenter?.notifyForgotPasswordButtonTapped()
            print("send email code")
            alertView.close()
        }
    }
    func createContainerViewForForgotPassword() -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 280))
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 240, height: 30))
        label.text = "Write your message here"
        label.font =  UIFont(name: "Raleway-Medium", size: 18)
        label.textColor = UIColor.ExpertConnectBlack
        View.addSubview(label)
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 246, y: 0, width: 44, height: 44)
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        closeButton.layer.cornerRadius = 3

        View.addSubview(closeButton)
        messageTextView = UITextView(frame: CGRect(x: 20, y: 55, width: 250.00, height: 200.00))
        messageTextView.backgroundColor = UIColor.white
        messageTextView.textColor = UIColor.ExpertConnectBlack
        messageTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        //messageTextView.text = "Write your message..."
        messageTextView.font = UIFont(name: "Raleway-Light", size: 18)
        //messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate=self;
        
        self.setExpertConnectTextViewTheme(textview: self.messageTextView)
        messageTextView.becomeFirstResponder()
        View.addSubview(messageTextView)
        return View;
    }
    
    func pressButton(button: UIButton) {
        // Do whatever you need when the button is pressed
        alertView.close()
    }
    
    func displayErrorMessageWithCallback(message: String) {
        self.showErrorMessage(message: message, callback: {
            self.alertView.show()
        })
    }
    
    // MARK: Send Message Response Methods
    func onSendMessageSucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            self.view.endEditing(true)
            self.displaySuccessMessage(message: data.message)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onSendMessageFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed To Send Message")
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
//            textView.text = "Write your message..."
//            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 300
        let currentString: NSString = textView.text as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
    }
}
