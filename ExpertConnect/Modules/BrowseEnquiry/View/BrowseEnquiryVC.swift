//
//  BrowseEnquiryVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 09/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class BrowseEnquiryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchBrowseListTransferProtocol {
    
    @IBOutlet var browseEnquirySegmentedControl: UISegmentedControl!
    @IBOutlet var tableview: UITableView!
    
    var receivedNotificationListArray = NSMutableArray()
    var receivedNotificationfilteredListArray = NSMutableArray()
    var sentNotificationListArray = NSMutableArray()
    var noDataLabel = UILabel()
    var categoryId = String()
    var subCategoryId = String()
    var userId = String()
    var location = String()
    var expertId = String()
    var requestId = String()
    let alertView = CustomIOS7AlertView()
    var tempExpertId = Int()
    var selectedSegment = String()
    var isFiltered: Bool = false
    var isBackFromSearch: Bool = false
    var nameHeight = CGFloat()
    var locationStaticHeight = CGFloat()
    var locationHeight = CGFloat()
    var coachingStaticHeight = CGFloat()
    var coachingHeight = CGFloat()
    var subCategoryHeight = CGFloat()
    var feeStaticHeight = CGFloat()
    var feeHeight = CGFloat()
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)
    let nameWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+60+59))
    let locationStaticWidth : CGFloat = 58
    let locationWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+58))
    let coachingStaticWidth : CGFloat = 64
    let coachingWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+64))
    let feeStaticWidth : CGFloat = 28
    let feeWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+28))
    let subCategoryWidth : CGFloat =  (UIScreen.main.bounds.size.width-(32+24))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Browse Enquiry"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.browseEnquirySegmentedControl.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Raleway-Light", size: 18.0)! ], for: .normal)
        self.makeTableSeperatorColorClear()
        self.makeProfileImageCircular()
        self.makeProfileImageTappable()
        let message = "EnquiriesUnavailable".localized(in: "BrowseEnquiryVC")
        self.noDataLabel = self.showStickyErrorMessage(message: message)
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    private func makeProfileImageTappable() {
    }
    
    private func makeProfileImageCircular() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let browseEnquiryTabItem = tabArray?.object(at: 2) as! UITabBarItem
        browseEnquiryTabItem.badgeValue = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if(self.receivedNotificationfilteredListArray.count == 0 && isFiltered) {
            //self.displayErrorMessage(message: "Notifications are not available")
            noDataLabel.isHidden = self.receivedNotificationfilteredListArray.count == 0 ? false : true
            self.isFiltered = false
        }
        else if(!isFiltered) {
            if(isBackFromSearch) {
                self.isBackFromSearch = false
                return
            }
            
            self.browseEnquirySegmentedControl.selectedSegmentIndex = 0
            selectedSegment = "First"
            let sortedViews = browseEnquirySegmentedControl.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
            for (index, view) in sortedViews.enumerated() {
                if index == browseEnquirySegmentedControl.selectedSegmentIndex {
                    view.tintColor = UIColor.ExpertConnectRed
                } else {
                    view.tintColor = UIColor.ExpertConnectBlack
                }
            }
            
            if (!self.isInternetAvailable()) {
                let message = "No Internet Connection".localized(in: "BrowseEnquiryVC")
                self.displayErrorMessage(message: message)
                return
            }
            let message = "Getting Enquiries".localized(in: "BrowseEnquiryVC")
            self.displayProgress(message: message)
            
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            self.location = UserDefaults.standard.value(forKey: "Location") as! String
            let BrowseEnquiryReceivedNotificationModel = BrowseEnquiryReceivedNotificationDomainModel.init(userId: self.userId, categoryId: "0", subCategoryId: "0", isFilter: "no", ammount: "00")
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
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUpdateNotificationBadgeFromBackground), name: NSNotification.Name(rawValue: "com.ExpertConnect.UpdateBadgeFromBackground"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: browseEnquirySegmentedControl method
    @IBAction func browseEnquirySegmentedControlClicked(_ sender: UISegmentedControl) {
        // hit api according to segment selected
        let sortedViews = sender.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        for (index, view) in sortedViews.enumerated() {
            if index == sender.selectedSegmentIndex {
                view.tintColor = UIColor.ExpertConnectRed
            } else {
                view.tintColor = UIColor.ExpertConnectBlack
            }
        }
        switch browseEnquirySegmentedControl.selectedSegmentIndex
        {
        case 0:
            self.selectedSegment = "First"
            if (!self.isInternetAvailable()) {
                let message = "No Internet Connection".localized(in: "BrowseEnquiryVC")
                self.displayErrorMessage(message: message)
                return
            }
            let message = "Getting Enquiries".localized(in: "BrowseEnquiryVC")
            self.displayProgress(message: message)
            
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            self.location = UserDefaults.standard.value(forKey: "Location") as! String
            let BrowseEnquiryReceivedNotificationModel = BrowseEnquiryReceivedNotificationDomainModel.init(userId: self.userId, categoryId: "0", subCategoryId: "0", isFilter: "no", ammount: "00")
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
            self.tableview.reloadData()
        case 1:
            self.selectedSegment = "Second"
            if (!self.isInternetAvailable()) {
                let message = "No Internet Connection".localized(in: "BrowseEnquiryVC")
                self.displayErrorMessage(message: message)
                return
            }
            let message = "Getting Enquiries".localized(in: "BrowseEnquiryVC")
            self.displayProgress(message: message)
            
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let BrowseEnquirySentNotificationModel = BrowseEnquirySentNotificationDomainModel.init(userId: self.userId)
            let APIDataManager : BrowseEnquirySentNotificationProtocols = BrowseEnquirySentNotificationAPIDataManager()
            APIDataManager.getBrowseEnquirySentNotificationDetails(model: BrowseEnquirySentNotificationModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onGetBrowseEnquirySentNotificationDetailsFailed(error: error)
                case .Success(let data as BrowseEnquirySentNotificationOutputDomainModel):
                    do {
                        self.onGetBrowseEnquirySentNotificationDetailsSucceeded(data: data)
                    } catch {
                        self.onGetBrowseEnquirySentNotificationDetailsFailed(data: data)
                    }
                default:
                    break
                }
            })
            self.tableview.reloadData()
        default:
            break
        }
    }
    
    // MARK: Search Browse ListTransferProtocol delegate method
    func searchBrowseSucceded(SearchBrowseListArray:NSArray, isFiltered:Bool) {
        if SearchBrowseListArray.count != 0 {
            self.receivedNotificationfilteredListArray = NSMutableArray.init(array: SearchBrowseListArray)
            self.isFiltered = isFiltered
            self.tableview.reloadData()
        } else {
            self.receivedNotificationfilteredListArray.removeAllObjects()
            self.isFiltered = isFiltered
            self.tableview.reloadData()
            //self.displayErrorMessage(message: "Notifications are not available")
        }
    }
    
    func searchBrowseFailed(isFiltered:Bool) {
        self.receivedNotificationfilteredListArray.removeAllObjects()
        self.isFiltered = isFiltered
        self.tableview.reloadData()
        //self.displayErrorMessage(message: "Notifications are not available")
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if selectedSegment == "First" {
            if isFiltered {
                return receivedNotificationfilteredListArray.count
            }
            else{
                return receivedNotificationListArray.count
            }
        }
        return sentNotificationListArray.count
    }
    
    func searchBrouseBackMenuBarTapped() {
        self.isBackFromSearch = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if selectedSegment == "First" {
            let identifier = "BEReceivedNotification"
            var receivedNotificationCell: BrowseEnquiryReceivedNotificationCustomCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BrowseEnquiryReceivedNotificationCustomCell
            if receivedNotificationCell == nil {
                tableView.register(BrowseEnquiryReceivedNotificationCustomCell.self, forCellReuseIdentifier: identifier)
                receivedNotificationCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BrowseEnquiryReceivedNotificationCustomCell
            }
            
            var dic = NSDictionary()
            if isFiltered {
                dic = receivedNotificationfilteredListArray[indexPath.row] as! NSDictionary
            }
            else{
                dic = receivedNotificationListArray[indexPath.row] as! NSDictionary
            }
            self.setECTableViewCellShadowTheme(view: receivedNotificationCell.mainView)
            receivedNotificationCell.acceptButton.tag = indexPath.row
            receivedNotificationCell.rejectButton.tag = indexPath.row
            
            self.setExpertConnectRedButtonTheme(button: receivedNotificationCell.acceptButton)
            self.setExpertConnectRedButtonTheme(button: receivedNotificationCell.rejectButton)
            receivedNotificationCell.acceptButton.addTarget(self, action: #selector(acceptButtonClicked(button:)), for: .touchUpInside)
            receivedNotificationCell.rejectButton.addTarget(self, action: #selector(rejectButtonClicked(button:)), for: .touchUpInside)
            if(dic.value(forKey: "type") != nil) {
                let type = dic.value(forKey: "type") as! String
                
                if (type == "request") {
                    receivedNotificationCell.mainButton.isHidden = true
                    receivedNotificationCell.acceptButton.isHidden = false
                    receivedNotificationCell.rejectButton.isHidden = false
                    self.setExpertConnectRedButtonTheme(button: receivedNotificationCell.acceptButton)
                    self.setExpertConnectRedButtonTheme(button: receivedNotificationCell.rejectButton)
                }
                else if (type == "accept") {
                    receivedNotificationCell.acceptButton.isHidden = true
                    receivedNotificationCell.rejectButton.isHidden = true
                    receivedNotificationCell.mainButton.isHidden = false
                    
                    self.setExpertConnectGrayButtonTheme(button: receivedNotificationCell.mainButton)
                    receivedNotificationCell.mainButton.setTitle("ACCEPTED", for: UIControlState.normal)
                    
                }
                else if (type == "reject") {
                    receivedNotificationCell.acceptButton.isHidden = true
                    receivedNotificationCell.rejectButton.isHidden = true
                    receivedNotificationCell.mainButton.isHidden = false
                    self.setExpertConnectGrayButtonTheme(button: receivedNotificationCell.mainButton)
                    receivedNotificationCell.mainButton.setTitle("REJECTED", for: UIControlState.normal)
                }
            }
            
            let firstName: String = dic.value(forKey: "firstname") as! String
            let lastName: String = dic.value(forKey: "lastname") as! String
            let firstNameWithSpace = firstName.appending(" ")
            let name = firstNameWithSpace.appending(lastName)
            receivedNotificationCell.nameLabel.text = name
            receivedNotificationCell.profileImageview.image = UIImage(named: "profile_rectangle_img")
            if (dic.value(forKey: "profile_pic") as! String != "") {
                let url = URL(string: dic.value(forKey: "profile_pic") as! String)
                receivedNotificationCell.profileImageview.kf.setImage(with: url)
            }
            
            receivedNotificationCell.locationLabel.text = dic.value(forKey: "location") as! String?
            
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
            receivedNotificationCell.coachingLabel.text = venueString
            
            receivedNotificationCell.nameLabel.removeConstraints(receivedNotificationCell.nameLabel.constraints)
            receivedNotificationCell.starView.removeConstraints(receivedNotificationCell.starView.constraints)
            receivedNotificationCell.locationStaticLabel.removeConstraints(receivedNotificationCell.locationStaticLabel.constraints)
            receivedNotificationCell.locationLabel.removeConstraints(receivedNotificationCell.locationLabel.constraints)
            receivedNotificationCell.coachingStaticLabel.removeConstraints(receivedNotificationCell.coachingStaticLabel.constraints)
            receivedNotificationCell.coachingLabel.removeConstraints(receivedNotificationCell.coachingLabel.constraints)
            
            // set constraints for BrowseEnquiryReceivedNotificationCustomCell
            nameHeight = (receivedNotificationCell.nameLabel.text?.heightForView(text: receivedNotificationCell.nameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: nameWidth))!
            locationStaticHeight = (receivedNotificationCell.locationStaticLabel.text?.heightForView(text: receivedNotificationCell.locationStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationStaticWidth))!
            locationHeight = (receivedNotificationCell.locationLabel.text?.heightForView(text: receivedNotificationCell.locationLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationWidth))!
            coachingStaticHeight = (receivedNotificationCell.coachingStaticLabel.text?.heightForView(text: receivedNotificationCell.coachingStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: coachingStaticWidth))!
            coachingHeight = (receivedNotificationCell.coachingLabel.text?.heightForView(text: receivedNotificationCell.coachingLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:coachingWidth))!
            
            self.setConstraints(actualView: receivedNotificationCell.nameLabel, leadingView: receivedNotificationCell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: receivedNotificationCell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: receivedNotificationCell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 13, height: nameHeight, width: nameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            self.setConstraints(actualView: receivedNotificationCell.starView, leadingView: receivedNotificationCell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: receivedNotificationCell.nameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: 25, width: 90, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: receivedNotificationCell.locationStaticLabel, leadingView: receivedNotificationCell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: receivedNotificationCell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 16, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: receivedNotificationCell.locationLabel, leadingView: receivedNotificationCell.locationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: receivedNotificationCell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: receivedNotificationCell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 16, height: locationHeight, width: locationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            if locationHeight > locationStaticHeight {
                self.setConstraints(actualView: receivedNotificationCell.coachingStaticLabel, leadingView: receivedNotificationCell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: receivedNotificationCell.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            }
            else{
                self.setConstraints(actualView: receivedNotificationCell.coachingStaticLabel, leadingView: receivedNotificationCell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: receivedNotificationCell.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            }
            
            self.setConstraints(actualView: receivedNotificationCell.coachingLabel, leadingView: receivedNotificationCell.coachingStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: receivedNotificationCell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: receivedNotificationCell.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingHeight, width: coachingWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            let verticalLineView = UIView()
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            //let screenHeight = screenSize.height
            if(screenWidth == 320) {
                verticalLineView.frame = CGRect(x: 2, y: 0, width: 1, height: 40)
                verticalLineView.backgroundColor = UIColor.white
                receivedNotificationCell.rejectButton.addSubview(verticalLineView)
            }
            receivedNotificationCell.selectionStyle = UITableViewCellSelectionStyle.none
            return receivedNotificationCell
        }
        else {
            
            let identifier = "BESentNotification"
            var sentNotificationCell: BrowseEnquirySentNotificationCustomCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BrowseEnquirySentNotificationCustomCell
            if sentNotificationCell == nil {
                tableView.register(BrowseEnquirySentNotificationCustomCell.self, forCellReuseIdentifier: identifier)
                sentNotificationCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BrowseEnquirySentNotificationCustomCell
            }
            
            let dic : NSDictionary = sentNotificationListArray[indexPath.row] as! NSDictionary
            self.setECTableViewCellShadowTheme(view: sentNotificationCell.mainView)
            self.setExpertConnectGrayButtonTheme(button: sentNotificationCell.requestSentButton)
            
            let firstName: String = dic.value(forKey: "firstname") as! String
            let lastName: String = dic.value(forKey: "lastname") as! String
            let firstNameWithSpace = firstName.appending(" ")
            let name = firstNameWithSpace.appending(lastName)
            sentNotificationCell.nameLabel.text = name
            sentNotificationCell.profileImageview.image = UIImage(named: "profile_rectangle_img")
            if (dic.value(forKey: "profile_pic") as! String != "") {
                let url = URL(string: dic.value(forKey: "profile_pic") as! String)
                sentNotificationCell.profileImageview.kf.setImage(with: url)
            }
            
            sentNotificationCell.subCategoryNameLabel.text = dic.value(forKey: "sub_category") as! String?
            sentNotificationCell.locationLabel.text = dic.value(forKey: "location") as! String?
            let rateDetails = dic.value(forKey: "rate_details") as! NSArray
            let rate = rateDetails[0] as! NSDictionary
            sentNotificationCell.feeLabel.text = rate.value(forKey: "rate") as! String
            
            sentNotificationCell.nameLabel.removeConstraints(sentNotificationCell.nameLabel.constraints)
            sentNotificationCell.starView.removeConstraints(sentNotificationCell.starView.constraints)
            sentNotificationCell.subCategoryNameLabel.removeConstraints(sentNotificationCell.subCategoryNameLabel.constraints)
            sentNotificationCell.locationStaticLabel.removeConstraints(sentNotificationCell.locationStaticLabel.constraints)
            sentNotificationCell.locationLabel.removeConstraints(sentNotificationCell.locationLabel.constraints)
            sentNotificationCell.feeStaticLabel.removeConstraints(sentNotificationCell.feeStaticLabel.constraints)
            sentNotificationCell.feeLabel.removeConstraints(sentNotificationCell.feeLabel.constraints)
            
            nameHeight = (sentNotificationCell.nameLabel.text?.heightForView(text: sentNotificationCell.nameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: nameWidth))!
            subCategoryHeight = (sentNotificationCell.subCategoryNameLabel.text?.heightForView(text: sentNotificationCell.subCategoryNameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: subCategoryWidth))!
            locationStaticHeight = (sentNotificationCell.locationStaticLabel.text?.heightForView(text: sentNotificationCell.locationStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationStaticWidth))!
            locationHeight = (sentNotificationCell.locationLabel.text?.heightForView(text: sentNotificationCell.locationLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationWidth))!
            feeStaticHeight = (sentNotificationCell.feeStaticLabel.text?.heightForView(text: sentNotificationCell.feeStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: feeStaticWidth))!
            feeHeight = (sentNotificationCell.feeLabel.text?.heightForView(text: sentNotificationCell.feeLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:feeWidth))!
            
            self.setConstraints(actualView: sentNotificationCell.nameLabel, leadingView: sentNotificationCell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: sentNotificationCell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: sentNotificationCell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 13, height: nameHeight, width: nameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            self.setConstraints(actualView: sentNotificationCell.starView, leadingView: sentNotificationCell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: sentNotificationCell.nameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: 25, width: 90, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: sentNotificationCell.subCategoryNameLabel, leadingView: sentNotificationCell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: sentNotificationCell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 16, height: subCategoryHeight, width: subCategoryWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: sentNotificationCell.locationStaticLabel, leadingView: sentNotificationCell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: sentNotificationCell.subCategoryNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 8, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: sentNotificationCell.locationLabel, leadingView: sentNotificationCell.locationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: sentNotificationCell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: sentNotificationCell.subCategoryNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 8, height: locationHeight, width: locationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            if locationHeight > locationStaticHeight {
                self.setConstraints(actualView: sentNotificationCell.feeStaticLabel, leadingView: sentNotificationCell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: sentNotificationCell.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            }
            else{
                self.setConstraints(actualView: sentNotificationCell.feeStaticLabel, leadingView: sentNotificationCell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: sentNotificationCell.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            }
            
            self.setConstraints(actualView: sentNotificationCell.feeLabel, leadingView: sentNotificationCell.feeStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: sentNotificationCell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: sentNotificationCell.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeHeight, width: feeWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            sentNotificationCell.selectionStyle = UITableViewCellSelectionStyle.none
            return sentNotificationCell
        }
    }
    
    // MARK: tableview Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if selectedSegment == "First" {
            return 28+nameHeight+10+25+16+locationHeight+4+coachingHeight+59
        }
        return 28+nameHeight+10+25+16+subCategoryHeight+8+locationHeight+4+feeHeight+59
    }
    
    // MARK: Accept Button Click methods
    func acceptButtonClicked(button: UIButton) {
        self.view.endEditing(true)
        let index = button.tag
        var dic = NSDictionary()
        if isFiltered {
            dic = receivedNotificationfilteredListArray[index] as! NSDictionary
        }
        else{
            dic = receivedNotificationListArray[index] as! NSDictionary
        }
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
        let sendRequestModel = SendRequestDomainModel.init(fromId: self.userId, toId: self.requestId, type: "accept", expertId: self.expertId, categoryId: self.categoryId, subCategoryId: self.subCategoryId)
        self.tempExpertId = Int(self.expertId)!
        let APIDataManager : SendRequestProtocols = SendRequestApiDataManager()
        APIDataManager.sendAcceptRejectRequest(data: sendRequestModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onAcceptOrRejectFailed(error: error)
            case .Success(let data as SendRequestOutputDomainModel):
                do {
                    // self.setExpertConnectGrayButtonTheme(button: button)
                    if self.isFiltered {
                        let dic : NSDictionary = self.receivedNotificationfilteredListArray[index] as! NSDictionary
                        let foundationDictionary = NSMutableDictionary(dictionary: dic)
                        foundationDictionary["type"] = "accept"
                        self.receivedNotificationfilteredListArray[index] = foundationDictionary
                    }
                    else {
                        let dic : NSDictionary = self.receivedNotificationListArray[index] as! NSDictionary
                        let foundationDictionary = NSMutableDictionary(dictionary: dic)
                        foundationDictionary["type"] = "accept"
                        self.receivedNotificationListArray[index] = foundationDictionary
                    }
                    self.tableview.reloadData()
                    
                    self.onAcceptOrRejectSucceeded(data: data)
                } catch {
                    self.onAcceptOrRejectFailed(data: data)
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
        if isFiltered {
            dic = receivedNotificationfilteredListArray[index] as! NSDictionary
        }
        else{
            dic = receivedNotificationListArray[index] as! NSDictionary
        }
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
        let sendRequestModel = SendRequestDomainModel.init(fromId: self.userId, toId: self.requestId, type: "reject", expertId: self.expertId, categoryId: self.categoryId, subCategoryId: self.subCategoryId)
        self.tempExpertId = Int(self.expertId)!
        let APIDataManager : SendRequestProtocols = SendRequestApiDataManager()
        APIDataManager.sendAcceptRejectRequest(data: sendRequestModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onAcceptOrRejectFailed(error: error)
            case .Success(let data as SendRequestOutputDomainModel):
                do {
                    if self.isFiltered {
                        let dic : NSDictionary = self.receivedNotificationfilteredListArray[index] as! NSDictionary
                        let foundationDictionary = NSMutableDictionary(dictionary: dic)
                        foundationDictionary["type"] = "reject"
                        self.receivedNotificationfilteredListArray[index] = foundationDictionary
                    }
                    else {
                        let dic : NSDictionary = self.receivedNotificationListArray[index] as! NSDictionary
                        let foundationDictionary = NSMutableDictionary(dictionary: dic)
                        foundationDictionary["type"] = "reject"
                        self.receivedNotificationListArray[index] = foundationDictionary
                    }
                    self.tableview.reloadData()
                    
                    self.onAcceptOrRejectSucceeded(data: data)
                } catch {
                    self.onAcceptOrRejectFailed(data: data)
                }
            default:
                break
            }
        })
    }
    
    // MARK: BrowseEnquiryReceivedNotification API Response methods
    func onGetBrowseEnquiryReceivedNotificationDetailsSucceeded(data: BrowseEnquiryReceivedNotificationOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.receivedNotificationListArray = NSMutableArray.init(array: data.browsedEnquiries as! [Any])
            noDataLabel.isHidden = self.receivedNotificationListArray.count == 0 ? false : true
            self.tableview.reloadData()
        } else {
            self.displayErrorMessage(message: data.message)
            noDataLabel.isHidden = self.receivedNotificationListArray.count == 0 ? false : true
        }
    }
    
    func onGetBrowseEnquiryReceivedNotificationDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.receivedNotificationListArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: "Notifications are not available")
        noDataLabel.isHidden = self.receivedNotificationListArray.count == 0 ? false : true
    }
    
    func onGetBrowseEnquiryReceivedNotificationDetailsFailed(data: BrowseEnquiryReceivedNotificationOutputDomainModel) {
        self.dismissProgress()
        self.receivedNotificationListArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: data.message)
        noDataLabel.isHidden = self.receivedNotificationListArray.count == 0 ? false : true
    }
    
    //hide accept & reject and unhide main button and title them on request success
    // MARK: AcceptOrReject API Response methods
    func onAcceptOrRejectSucceeded(data: SendRequestOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            alertView.containerView = createContainerView(acceptOrRejectSuccessMessage: data.message)
            alertView.catchString(withString: "AlertForRequest/Accept/Reject")
            alertView.show()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onAcceptOrRejectFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed To Accept Or Reject Request")
    }
    
    func onAcceptOrRejectFailed(data:SendRequestOutputDomainModel) {
        self.dismissProgress()
        self.displayErrorMessage(message: data.message)
    }
    
    // MARK: BrowseEnquirySentNotification API Response methods
    func onGetBrowseEnquirySentNotificationDetailsSucceeded(data: BrowseEnquirySentNotificationOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.sentNotificationListArray = NSMutableArray.init(array: data.browsedEnquiries as! [Any])
            noDataLabel.isHidden = self.sentNotificationListArray.count == 0 ? false : true
            self.tableview.reloadData()
        } else {
            self.displayErrorMessage(message: data.message)
            noDataLabel.isHidden = self.sentNotificationListArray.count == 0 ? false : true
        }
    }
    
    func onGetBrowseEnquirySentNotificationDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.sentNotificationListArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: "Notifications are not available")
        noDataLabel.isHidden = self.sentNotificationListArray.count == 0 ? false : true
    }
    
    func onGetBrowseEnquirySentNotificationDetailsFailed(data: BrowseEnquirySentNotificationOutputDomainModel) {
        self.dismissProgress()
        self.sentNotificationListArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: data.message)
        noDataLabel.isHidden = self.sentNotificationListArray.count == 0 ? false : true
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
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage(message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
    
    @objc func onUpdateNotificationBadgeFromBackground(notification: Notification) {
        if !UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            return
        }
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        let notificationsDomainModel = NotificationsDomainModel.init(userId: self.userId)
        let APIDataManager : NotificationCountProtocols = NotificationsAPIDataManager()
        APIDataManager.getNotificationCount(model: notificationsDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onGetNotificationsDetailsFailed(error: error)
            case .Success(let data as NotificationCountOutputDomainModel):
                do {
                    self.onGetNotificationsDetailsSucceeded(data: data)
                } catch {
                    self.onGetNotificationsDetailsFailed(data: data)
                }
            default:
                break
            }
        })
    }
    
    // MARK: BrowseEnquiryReceivedNotification API Response methods
    func onGetNotificationsDetailsSucceeded(data: NotificationCountOutputDomainModel) {
        //self.dismissProgress()
        if data.status {
            
            let tabArray = self.tabBarController?.tabBar.items as NSArray!
            let browseEnquiryTabItem = tabArray?.object(at: 2) as! UITabBarItem
            
            if(data.browseEnquiryCount != "0") {
                browseEnquiryTabItem.badgeValue = "\(data.browseEnquiryCount)"
            }
            
            let myAssignmentTabItem = tabArray?.object(at: 1) as! UITabBarItem
            if(data.myAssignmentCount != "0") {
                myAssignmentTabItem.badgeValue = "\(data.myAssignmentCount)"
            }
            
        } else {
        }
    }
    
    func onGetNotificationsDetailsFailed(error: EApiErrorType) {
        //self.dismissProgress()
    }
    
    func onGetNotificationsDetailsFailed(data: NotificationCountOutputDomainModel) {
        //self.dismissProgress()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
