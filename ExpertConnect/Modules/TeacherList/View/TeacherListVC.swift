
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
class TeacherListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, filteredTeacherListTransferProtocol {

    @IBOutlet var tableview: UITableView!
    
    var teacherListArray = NSMutableArray()
    var filteredTeacherListArray = NSMutableArray()
    
    var isFiltered: Bool = false
    var userId = String()
    var expertId = String()
    var requestId = String()
    let alertView = CustomIOS7AlertView()
    
    var teacherNameHeight = CGFloat()
    var expertiseStaticHeight = CGFloat()
    var expertiseHeight = CGFloat()
    var coachingStaticHeight = CGFloat()
    var coachingHeight = CGFloat()
    var feeStaticHeight = CGFloat()
    var feeHeight = CGFloat()
    var locationStaticHeight = CGFloat()
    var locationHeight = CGFloat()
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)
    
    var categoryId = String()
    var subCategoryId = String()
    var expertLevel = String()
    var expertiseString = String()
    var tempExpertId = Int()
    
    let teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+60+59))
    let expertiseStaticWidth : CGFloat = 62
    let expertiseWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+146))
    let coachingStaticWidth : CGFloat = 64
    var coachingWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+64))
    let feeStaticWidth : CGFloat = 28
    let feeWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+28))
    let locationStaticWidth : CGFloat = 58
    let locationWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+58))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        self.activateFilterIcon()

        print(teacherListArray)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.makeTableSeperatorColorClear()
//        self.makeProfileImageCircular()

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
            return self.filteredTeacherListArray.count
        }
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
        if (dic.value(forKey: "flag") as! Int == 0) {
            self.setExpertConnectRedButtonTheme(button: cell.requestButton)
        } else {
            self.setExpertConnectGrayButtonTheme(button: cell.requestButton)
        }
 
        cell.requestButton.addTarget(self, action: #selector(requestButtonClicked(button:)), for: .touchUpInside)

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
        let feesString = dic.value(forKey: "rate") as! String
        cell.feeLabel.text = "AU$ \(feesString)"
        
        cell.locationLabel.text = dic.value(forKey: "location") as! String?
        // collecting venues in coachingVenueArray
        let coachingDetails : NSArray = dic.value(forKey: "coaching_details") as! NSArray
        var coachingVenueArray = Array<Any>()
        for venue in coachingDetails {
            let str:NSDictionary = venue as! NSDictionary
            coachingVenueArray.append(str.value(forKey: "venue") as! String)
        }
        // concating all venues in single string
        var venueString = String()
        for i in 0..<coachingVenueArray.count {
            if i == coachingVenueArray.count-1{
                venueString.append(String(format:"%@" , coachingVenueArray[i]  as! String ))
            }
            else{
                venueString.append(String(format:"%@, " , coachingVenueArray[i]  as! String ))
            }
        }
        cell.coachingLabel.text = venueString

        teacherNameHeight = (cell.teacherNameLabel.text?.heightForView(text: cell.teacherNameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: teacherNameWidth))!
        expertiseStaticHeight = (cell.expertiseStaticLabel.text?.heightForView(text: cell.expertiseStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: expertiseStaticWidth))!
        expertiseHeight = (cell.expertiseLabel.text?.heightForView(text: (cell.expertiseLabel.text)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: expertiseWidth))!
        coachingStaticHeight = (cell.coachingStaticLabel.text?.heightForView(text: cell.coachingStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: coachingStaticWidth))!
        
        coachingHeight = (cell.coachingLabel.text?.heightForView(text: cell.coachingLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:coachingWidth))!
        
        feeStaticHeight = (cell.feeStaticLabel.text?.heightForView(text: cell.feeStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:feeStaticWidth))!
        feeHeight = (cell.feeLabel.text?.heightForView(text: cell.feeLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: feeWidth))!
        locationStaticHeight = (cell.locationStaticLabel.text?.heightForView(text: cell.locationStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationStaticWidth))!
        locationHeight = (cell.locationLabel.text?.heightForView(text: cell.locationLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationWidth))!
        
        cell.teacherNameLabel.removeConstraints(cell.teacherNameLabel.constraints)
        cell.starView.removeConstraints(cell.starView.constraints)
        cell.expertiseStaticLabel.removeConstraints(cell.expertiseStaticLabel.constraints)
        cell.expertiseLabel.removeConstraints(cell.expertiseLabel.constraints)
        cell.coachingStaticLabel.removeConstraints(cell.coachingStaticLabel.constraints)
        cell.coachingLabel.removeConstraints(cell.coachingLabel.constraints)
        cell.feeStaticLabel.removeConstraints(cell.feeStaticLabel.constraints)
        cell.feeLabel.removeConstraints(cell.feeLabel.constraints)
        cell.locationStaticLabel.removeConstraints(cell.locationStaticLabel.constraints)
        cell.locationLabel.removeConstraints(cell.locationLabel.constraints)

        self.setConstraints(actualView: cell.teacherNameLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 13, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setConstraints(actualView: cell.starView, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: 25, width: 90, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.expertiseStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 16, height: expertiseStaticHeight, width: expertiseStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.expertiseLabel, leadingView: cell.expertiseStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 16, height: expertiseHeight, width: expertiseWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if expertiseHeight > expertiseStaticHeight {
            self.setConstraints(actualView: cell.coachingStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: cell.coachingStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: cell.coachingLabel, leadingView: cell.coachingStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingHeight, width: coachingWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if coachingHeight > coachingStaticHeight {
            self.setConstraints(actualView: cell.feeStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: cell.feeStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: cell.feeLabel, leadingView: cell.feeStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeHeight, width: feeWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setConstraints(actualView: cell.locationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.feeStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.locationLabel, leadingView: cell.locationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.feeLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationHeight, width: locationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
       
        self.setECTableViewCellShadowTheme(view: cell.mainView)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let height = (28)+(teacherNameHeight)+(10)+(25)+(16)+(expertiseHeight)+(4)+(coachingHeight)+(4)+(feeHeight)+(4)+(locationHeight)+(59)
        return height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    // MARK: Request Button Click method
    func requestButtonClicked(button: UIButton) {
        self.view.endEditing(true)
        let index = button.tag
        let dic : NSDictionary = teacherListArray[index] as! NSDictionary
        self.requestId = dic.value(forKey: "user_id") as! String
        self.expertId = dic.value(forKey: "expert_id") as! String
        
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Processing".localized(in: "SignUp")
        self.displayProgress(message: message)
        
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        let sendRequestModel = SendRequestDomainModel.init(fromId: self.userId, toId: self.requestId, type: "request", expertId: self.expertId)
        self.tempExpertId = Int(self.expertId)!
        let APIDataManager : SendRequestProtocols = SendRequestApiDataManager()
        APIDataManager.sendRequest(data: sendRequestModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onSendRequestFailed(error: error)
            case .Success(let data as SendRequestOutputDomainModel):
                do {
                  
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
                    self.onRequSendestSucceeded(data: data)
                } catch {
                    self.onSendRequestFailed(data: data)
                }
            default:
                break
            }
        })
    }
    
    // MARK: Request API Response methods
    func onRequSendestSucceeded(data: SendRequestOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            let alertMessage = "Your request has been sent successfully.".localized(in: "Localizable")
            alertView.containerView = createContainerView(requestSuccessMessage: alertMessage)
            alertView.catchString(withString: "AlertForRequest/Accept/Reject")
            alertView.show()
            
//            if (!self.isInternetAvailable()) {
//                let message = "No Internet Connection".localized(in: "ExpertDetails")
//                self.displayErrorMessage(message: message)
//                return
//            }
//            let message = "Processing".localized(in: "SignUp")
//            self.displayProgress(message: message)
//            print(UserDefaults.standard.value(forKey: "UserId") as! String)
//            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
//            let teacherListModel = TeacherListDomainModel.init(userId: self.userId, categoryId: self.categoryId, subCategoryId: self.subCategoryId, level: self.expertLevel)
//            let defaults = UserDefaults.standard
//            var array = defaults.array(forKey: "ExpertIdArray")  as? [Int] ?? [Int]()
//            array.append(self.tempExpertId)
//            defaults.set(array, forKey: "ExpertIdArray")
//            
//            let APIDataManager : TeacherListProtocols = TeacherListApiDataManager()
//            APIDataManager.getTeacherList(data: teacherListModel, callback:{(result) in
//                print("result : ", result)
//                switch result {
//                case .Failure(let error):
//                    self.ongetTeacherListFailed(error: error)
//                case .Success(let data as TeacherListOutputDomainModel):
//                    do {
//                        self.ongetTeacherListSucceeded(data: data)
//                    } catch {
//                        self.ongetTeacherListFailed(data: data)
//                    }
//                default:
//                    break
//                }
//            })
//            self.tableview.reloadData()
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
        
        label.font =  UIFont(name: "Raleway-Light", size: 18)
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
//        NSLayoutConstraint(it)
        let heightConstraint = NSLayoutConstraint(item: actualView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(height))
        
        print("heightConstraint : %d", heightConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: actualView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
        
        
//        NSLayoutConstraint.activate([heightConstraint,widthConstraint])
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
//        actualView.addConstraints([leadingMargin, trailingMargin, upperSpace, widthConstraint, heightConstraint])
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
        self.showSuccessMessage(message: message)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
