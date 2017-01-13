//
//  MyAssignmentVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 09/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class MyAssignmentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
    var myAssignmentArray = NSMutableArray()
    var userId = String()
    var expertId = String()
    var requestId = String()
    let alertView = CustomIOS7AlertView()
    var tempExpertId = Int()

    var studentNameHeight = CGFloat()
    var inProgressStaticHeight = CGFloat()
    var subjectStaticHeight = CGFloat()
    var subjectHeight = CGFloat()
    var locationStaticHeight = CGFloat()
    var locationHeight = CGFloat()
    var coachingStaticHeight = CGFloat()
    var coachingHeight = CGFloat()
    var contactNoStaticHeight = CGFloat()
    var contactNoHeight = CGFloat()
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)

    let studentNameWidth : CGFloat =  (UIScreen.main.bounds.size.width-(32+24+60+59))
    let inProgressStaticWidth : CGFloat =  111
    let subjectStaticWidth : CGFloat =  52
    let subjectWidth : CGFloat =  (UIScreen.main.bounds.size.width-(32+24+8+52))
    let locationStaticWidth : CGFloat =  58
    let locationWidth : CGFloat =  (UIScreen.main.bounds.size.width-(32+24+8+58))
    let coachingStaticWidth : CGFloat =  64
    let coachingWidth : CGFloat =  (UIScreen.main.bounds.size.width-(32+24+8+64))
    let contactNoStaticWidth : CGFloat =  73
    let contactNoWidth : CGFloat =  (UIScreen.main.bounds.size.width-(32+24+8+73))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Assignment"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        self.makeTableSeperatorColorClear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Processing".localized(in: "SignUp")
        self.displayProgress(message: message)
        
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        let myAssignmentModel = MyAssignmentDomainModel.init(userId: self.userId)
        let APIDataManager : MyAssignmentProtocols = MyAssignmentAPIDataManager()
        APIDataManager.getMyAssignmentDetails(model: myAssignmentModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onGetMyAssignmentDetailsFailed(error: error)
            case .Success(let data as MyAssignmentOutputDomainModel):
                do {
                    self.onGetMyAssignmentDetailsSucceeded(data: data)
                } catch {
                    self.onGetMyAssignmentDetailsFailed(data: data)
                }
            default:
                break
            }
        })
    }

    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.myAssignmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let  cell:MyAssignmentCustomCell = tableView.dequeueReusableCell(withIdentifier: "MyAssignmentCustomCell", for: indexPath) as! MyAssignmentCustomCell
 
        let identifier = "MyAssignmentCustomCell"
        var cell: MyAssignmentCustomCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyAssignmentCustomCell
        if cell == nil {
            tableView.register(MyAssignmentCustomCell.self, forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyAssignmentCustomCell
        }

        var dic = NSDictionary()
        dic = self.myAssignmentArray[indexPath.row] as! NSDictionary

        cell.confirmButton.tag = indexPath.row
        cell.rejectButton.tag = indexPath.row
        self.setExpertConnectRedButtonTheme(button: cell.confirmButton)
        self.setExpertConnectRedButtonTheme(button: cell.rejectButton)
        cell.confirmButton.addTarget(self, action: #selector(confirmButtonClicked(button:)), for: .touchUpInside)
        cell.rejectButton.addTarget(self, action: #selector(rejectButtonClicked(button:)), for: .touchUpInside)
      
        if(dic.value(forKey: "type") != nil) {
            let type = dic.value(forKey: "type") as! String
            
            if (type == "accept") {
                cell.completeButton.isHidden = true
                cell.confirmButton.isHidden = false
                cell.rejectButton.isHidden = false
                self.setExpertConnectRedButtonTheme(button: cell.confirmButton)
                self.setExpertConnectRedButtonTheme(button: cell.rejectButton)
            }
            else if (type == "confirm") {
                cell.confirmButton.isHidden = true
                cell.rejectButton.isHidden = true
                cell.completeButton.isHidden = false
                
                self.setExpertConnectRedButtonTheme(button: cell.completeButton)
                cell.completeButton.setTitle("COMPLETE", for: UIControlState.normal)
                
            }
            else if (type == "reject") {
                cell.confirmButton.isHidden = true
                cell.rejectButton.isHidden = true
                cell.completeButton.isHidden = false
                self.setExpertConnectGrayButtonTheme(button: cell.completeButton)
                cell.completeButton.setTitle("REJECTED", for: UIControlState.normal)
            }
        }
        
        let firstName: String = dic.value(forKey: "firstname") as! String
        let lastName: String = dic.value(forKey: "lastname") as! String
        let firstNameWithSpace = firstName.appending(" ")
        let name = firstNameWithSpace.appending(lastName)
        cell.studentNameLabel.text = name
        cell.profileImageview.image = UIImage(named: "profile_rectangle_img")
        if (dic.value(forKey: "profile_pic") as! String != "") {
            let url = URL(string: dic.value(forKey: "profile_pic") as! String)
            cell.profileImageview.kf.setImage(with: url)
        }
        
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
        let countryCode: String = dic.value(forKey: "country_code") as! String
        let mobileNo: String = dic.value(forKey: "mobile_no") as! String
        let countryCodeWithSpace = countryCode.appending(" ")
        let mobileNoWithCountryCode = countryCodeWithSpace.appending(mobileNo)
        cell.contactNoLabel.text = mobileNoWithCountryCode

        cell.studentNameLabel.removeConstraints(cell.studentNameLabel.constraints)
        cell.inProgressStaticLabel.removeConstraints(cell.inProgressStaticLabel.constraints)
        cell.subjectStaticLabel.removeConstraints(cell.subjectStaticLabel.constraints)
        cell.subjectLabel.removeConstraints(cell.subjectLabel.constraints)
        cell.locationStaticLabel.removeConstraints(cell.locationStaticLabel.constraints)
        cell.locationLabel.removeConstraints(cell.locationLabel.constraints)
        cell.coachingStaticLabel.removeConstraints(cell.coachingStaticLabel.constraints)
        cell.coachingLabel.removeConstraints(cell.coachingLabel.constraints)
        cell.contactNoStaticLabel.removeConstraints(cell.contactNoStaticLabel.constraints)
        cell.contactNoLabel.removeConstraints(cell.contactNoLabel.constraints)
        
        studentNameHeight = (cell.studentNameLabel.text?.heightForView(text: cell.studentNameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: studentNameWidth))!
        inProgressStaticHeight = (cell.inProgressStaticLabel.text?.heightForView(text: cell.inProgressStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: inProgressStaticWidth))!
        subjectStaticHeight = (cell.subjectStaticLabel.text?.heightForView(text: cell.subjectStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: subjectStaticWidth))!
        subjectHeight = (cell.subjectLabel.text?.heightForView(text: cell.subjectLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: subjectWidth))!
        locationStaticHeight = (cell.locationStaticLabel.text?.heightForView(text: cell.locationStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationStaticWidth))!
        locationHeight = (cell.locationLabel.text?.heightForView(text: cell.locationLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationWidth))!
        coachingStaticHeight = locationStaticHeight
        coachingHeight = (cell.coachingLabel.text?.heightForView(text: cell.coachingLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:coachingWidth))!
        contactNoStaticHeight = (cell.contactNoStaticLabel.text?.heightForView(text: cell.contactNoStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: contactNoStaticWidth))!
        contactNoHeight = (cell.contactNoLabel.text?.heightForView(text: cell.contactNoLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:contactNoWidth))!
        
        
        self.setConstraints(actualView: cell.studentNameLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 13, height: studentNameHeight, width: studentNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setConstraints(actualView: cell.inProgressStaticLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.studentNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: inProgressStaticHeight, width: inProgressStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.subjectStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.inProgressStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 16, height: subjectStaticHeight, width: subjectStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.subjectLabel, leadingView: cell.subjectStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.inProgressStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 16, height: subjectHeight, width: subjectWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if subjectHeight > subjectStaticHeight {
            self.setConstraints(actualView: cell.locationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.subjectLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else{
            self.setConstraints(actualView: cell.locationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.subjectLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: cell.locationLabel, leadingView: cell.locationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.subjectLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationHeight, width: locationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if locationHeight > locationStaticHeight {
            self.setConstraints(actualView: cell.coachingStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else{
            self.setConstraints(actualView: cell.coachingStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: cell.coachingLabel, leadingView: cell.coachingStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingHeight, width: coachingWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if coachingHeight > coachingStaticHeight {
            self.setConstraints(actualView: cell.contactNoStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: contactNoStaticHeight, width: contactNoStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else{
            self.setConstraints(actualView: cell.contactNoStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: contactNoStaticHeight, width: contactNoStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: cell.contactNoLabel, leadingView: cell.contactNoStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: contactNoHeight, width: contactNoWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        let verticalLineView = UIView()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        if(screenWidth == 320) {
            verticalLineView.frame = CGRect(x: 2, y: 0, width: 1, height: 40)
            verticalLineView.backgroundColor = UIColor.white
            cell.rejectButton.addSubview(verticalLineView)
        }

        self.setECTableViewCellShadowTheme(view: cell.mainView)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    // MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 28+studentNameHeight+10+inProgressStaticHeight+16+subjectHeight+4+locationHeight+4+coachingHeight+4+contactNoHeight+59
    }
    
    // MARK: Set Constraints method
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
    
    // MARK: Accept Button Click methods
    func confirmButtonClicked(button: UIButton) {
        self.view.endEditing(true)
        let index = button.tag
        var dic = NSDictionary()
        dic = self.myAssignmentArray[index] as! NSDictionary
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
        let sendConfirmRejectDomainModel = SendConfirmRejectDomainModel.init(fromId: self.userId, toId: self.requestId, type: "confirm", expertId: self.expertId)
        self.tempExpertId = Int(self.expertId)!
        let APIDataManager : ConfirmRequestProtocols = SendConfirmRejectAPIDataManager()
        APIDataManager.sendConfirmRejectRequest(data: sendConfirmRejectDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onConfirmedOrRejectFailed(error: error)
            case .Success(let data as SendConfirmRejectOutputDomainModel):
                do {
                    //self.setExpertConnectGrayButtonTheme(button: button)
                    let dic : NSDictionary = self.myAssignmentArray[index] as! NSDictionary
                    let foundationDictionary = NSMutableDictionary(dictionary: dic)
                    foundationDictionary["type"] = "confirm"
                    self.myAssignmentArray[index] = foundationDictionary
                    self.tableview.reloadData()
                    
                    self.onConfirmOrRejectSucceeded(data: data)
                } catch {
                    self.onConfirmedOrRejectFailed(data: data)
                }
            default:
                break
            }
        })
 
    }
    
    // MARK: Reject Button Click methods
    func rejectButtonClicked(button: UIButton) {
        self.view.endEditing(true)
        let index = button.tag
        var dic = NSDictionary()
        dic = self.myAssignmentArray[index] as! NSDictionary
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
        let sendConfirmRejectDomainModel = SendConfirmRejectDomainModel.init(fromId: self.userId, toId: self.requestId, type: "reject", expertId: self.expertId)
        self.tempExpertId = Int(self.expertId)!
        let APIDataManager : ConfirmRequestProtocols = SendConfirmRejectAPIDataManager()
        APIDataManager.sendConfirmRejectRequest(data: sendConfirmRejectDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onConfirmedOrRejectFailed(error: error)
            case .Success(let data as SendConfirmRejectOutputDomainModel):
                do {
                    //self.setExpertConnectGrayButtonTheme(button: button)
                    let dic : NSDictionary = self.myAssignmentArray[index] as! NSDictionary
                    let foundationDictionary = NSMutableDictionary(dictionary: dic)
                    foundationDictionary["type"] = "reject"
                    self.myAssignmentArray[index] = foundationDictionary
                    self.tableview.reloadData()
                    
                    self.onConfirmOrRejectSucceeded(data: data)
                } catch {
                    self.onConfirmedOrRejectFailed(data: data)
                }
            default:
                break
            }
        })
    }
    // MARK: MyAssignment API Response methods
    func onGetMyAssignmentDetailsSucceeded(data: MyAssignmentOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.myAssignmentArray = NSMutableArray.init(array: data.myAssignments as! [Any])
            self.tableview.reloadData()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onGetMyAssignmentDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.myAssignmentArray.removeAllObjects()
        self.tableview.reloadData()
        self.displayErrorMessage(message: "Notifications are not available")
    }
    
    func onGetMyAssignmentDetailsFailed(data: MyAssignmentOutputDomainModel) {
        self.dismissProgress()
        self.myAssignmentArray.removeAllObjects()
        self.tableview.reloadData()
        self.displayErrorMessage(message: data.message)
    }

    //hide accept & reject and unhide main button and title them on request success
    // MARK: AcceptOrReject API Response methods
    func onConfirmOrRejectSucceeded(data: SendConfirmRejectOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            alertView.containerView = createContainerView(acceptOrRejectSuccessMessage: data.message)
            alertView.catchString(withString: "AlertForRequest/Accept/Reject")
            alertView.show()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onConfirmedOrRejectFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed To Confirm Or Reject Request")
    }
    
    func onConfirmedOrRejectFailed(data:SendConfirmRejectOutputDomainModel) {
        self.dismissProgress()
        self.displayErrorMessage(message: data.message)
    }

    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage(message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }

    // MARK: Custom Alert view method
    func createContainerView(acceptOrRejectSuccessMessage: String) -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 150))
        let label = UILabel(frame: CGRect(x: 20, y: 80, width: 240, height: 50))
        label.text = acceptOrRejectSuccessMessage
        //label.text = "Your request has been sent successfully."
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        
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
        
        return View
    }
    
    // MARK: Custom Alert view close button method
    func alertViewCloseButtonClicked(button: UIButton) {
        alertView.close()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 }
