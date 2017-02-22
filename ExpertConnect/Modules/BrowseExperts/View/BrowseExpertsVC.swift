//
//  BrowseExpertsVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 09/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos
class BrowseExpertsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var expertsSegmentedControl: UISegmentedControl!
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var totalExpertsLabel: UILabel!
    @IBOutlet weak var totalCountBaseView: UIView!
    var categoryArray = NSMutableArray()
    var userId = String()
    var location = String()
    var expertId = String()
    var requestId = String()
    var categoryId = String()
    var subCategoryId = String()
    let alertView = CustomIOS7AlertView()
    var nextOffset: Int = 0
    var totalCount = Int()
    var tempExpertId = Int()
    var noDataLabel = UILabel()
    var teacherNameHeight = CGFloat()
    var expertiseStaticHeight = CGFloat()
    var expertiseHeight = CGFloat()
    var coachingStaticHeight = CGFloat()
    var coachingHeight = CGFloat()
    var locationStaticHeight = CGFloat()
    var locationHeight = CGFloat()
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)
    let teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+60+59))
    let expertiseStaticWidth : CGFloat = 62
    let expertiseWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+146))
    let coachingStaticWidth : CGFloat = 64
    var coachingWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+64))
    let locationStaticWidth : CGFloat = 58
    let locationWidth : CGFloat = (UIScreen.main.bounds.size.width-(32+24+8+58))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(categoryArray)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.makeTableSeperatorColorClear()
        self.expertsSegmentedControl.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Raleway-Light", size: 18.0)! ], for: .normal)
        let sortedViews = expertsSegmentedControl.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        for (index, view) in sortedViews.enumerated() {
            if index == expertsSegmentedControl.selectedSegmentIndex {
                view.tintColor = UIColor.ExpertConnectRed
            } else {
                view.tintColor = UIColor.ExpertConnectBlack
            }
        }
        let message = "ExpertsUnavailable".localized(in: "BrowseExpertsVC")
        self.noDataLabel = self.showStickyErrorMessage(message: message)
        self.totalExpertsLabel.textColor = UIColor.ExpertConnectGray
        self.lineView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Browse Experts"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.categoryArray.removeAllObjects()
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "BrowseExpertsVC")
            self.displayErrorMessage(message: message)
            return
        }
        
        let message = "Loading".localized(in: "BrowseExpertsVC")
        self.displayProgress(message: message)
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        self.location = UserDefaults.standard.value(forKey: "Location") as! String
        let BrowseExpertListModel = BrowseExpertListDomainModel.init(userId: self.userId, location: self.location, offset:"0" , limit: "10")
        let APIDataManager : BrowseExpertListProtocols = BrowseExpertListApiDataManager()
        APIDataManager.getBrowseExpertList(data: BrowseExpertListModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onGetBrowseExpertListFailed(error: error)
            case .Success(let data as BrowseExpertListOutputDomainModel):
                do {
                    self.onGetBrowseExpertListSucceeded(data: data)
                } catch {
                    self.onGetBrowseExpertListFailed(data: data)
                }
            default:
                break
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coachingWidth = (UIScreen.main.bounds.size.width-(32+24+8+64))
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUpdateNotificationBadgeFromBackground), name: NSNotification.Name(rawValue: "com.ExpertConnect.UpdateBadgeFromBackground"), object: nil)
        self.setExpertConnectShadowTheme(view: self.totalCountBaseView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    @IBAction func browseExpertSegmentedControlClicked(_ sender: Any) {
        let sortedViews = (sender as AnyObject).subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        for (index, view) in sortedViews.enumerated() {
            if index == (sender as AnyObject).selectedSegmentIndex {
                view.tintColor = UIColor.ExpertConnectRed
            } else {
                view.tintColor = UIColor.ExpertConnectBlack
            }
        }
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "BrowseExpertsCustomCell"
        var cell: BrowseExpertsCustomCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BrowseExpertsCustomCell
        if cell == nil {
            tableView.register(BrowseExpertsCustomCell.self, forCellReuseIdentifier: "BrowseExpertsCustomCell")
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BrowseExpertsCustomCell
        }
        
        let dic : NSDictionary = categoryArray[indexPath.row] as! NSDictionary
        cell.requestButton.tag = indexPath.row
        
        if (dic.value(forKey: "flag") as! Int == 0) {
            self.setExpertConnectRedButtonTheme(button: cell.requestButton)
        }
        if (dic.value(forKey: "flag") as! Int == 1) {
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
        cell.expertiseLabel.text = dic.value(forKey: "sub_category") as? String
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
        
        cell.teacherNameLabel.removeConstraints(cell.teacherNameLabel.constraints)
        cell.starView.removeConstraints(cell.starView.constraints)
        cell.expertiseStaticLabel.removeConstraints(cell.expertiseStaticLabel.constraints)
        cell.expertiseLabel.removeConstraints(cell.expertiseLabel.constraints)
        cell.coachingStaticLabel.removeConstraints(cell.coachingStaticLabel.constraints)
        cell.coachingLabel.removeConstraints(cell.coachingLabel.constraints)
        cell.locationStaticLabel.removeConstraints(cell.locationStaticLabel.constraints)
        cell.locationLabel.removeConstraints(cell.locationLabel.constraints)
        
        // set constraints for BrowseExpertsCustomCell
        teacherNameHeight = 0
        expertiseHeight = 0
        coachingHeight = 0
        locationHeight = 0
        teacherNameHeight = (teacherName.heightForView(text: teacherName, font: UIFont(name: "Raleway-Light", size: 17)!, width: teacherNameWidth))
        expertiseStaticHeight = (cell.expertiseStaticLabel.text?.heightForView(text: cell.expertiseStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: expertiseStaticWidth))!
        expertiseHeight = (cell.expertiseLabel.text?.heightForView(text: (cell.expertiseLabel.text)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: expertiseWidth))!
        coachingStaticHeight = (cell.coachingStaticLabel.text?.heightForView(text: cell.coachingStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: coachingStaticWidth))!
        
        coachingHeight = (venueString.heightForView(text: venueString, font: UIFont(name: "Raleway-Light", size: 14)!, width:coachingWidth))
        
        locationStaticHeight = (cell.locationStaticLabel.text?.heightForView(text: cell.locationStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationStaticWidth))!
        locationHeight = ((dic.value(forKey: "location") as! String?)!.heightForView(text: (dic.value(forKey: "location") as! String?)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationWidth))
        
        self.setConstraints(actualView: cell.teacherNameLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 13, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setConstraints(actualView: cell.starView, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 59, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: 25, width: 90, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.expertiseStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 16, height: expertiseStaticHeight, width: expertiseStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.expertiseLabel, leadingView: cell.expertiseStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 16, height: expertiseHeight, width: expertiseWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if expertiseHeight > expertiseStaticHeight {
            self.setConstraints(actualView: cell.coachingStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else{
            self.setConstraints(actualView: cell.coachingStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: cell.coachingLabel, leadingView: cell.coachingStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingHeight, width: coachingWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if coachingHeight > coachingStaticHeight {
            self.setConstraints(actualView: cell.locationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else{
            self.setConstraints(actualView: cell.locationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 16, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: cell.locationLabel, leadingView: cell.locationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 16, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationHeight, width: locationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setECTableViewCellShadowTheme(view: cell.mainView)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if (indexPath.row == self.categoryArray.count-2 && self.nextOffset < self.totalCount ) {
            let message = "Loading".localized(in: "BrowseExpertsVC")
            self.displayProgress(message: message)
            
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            self.location = UserDefaults.standard.value(forKey: "Location") as! String
            let BrowseExpertListModel = BrowseExpertListDomainModel.init(userId: self.userId, location: self.location, offset:String(format:"%d", self.nextOffset) as String , limit: "10")
            //            capitalized
            let APIDataManager : BrowseExpertListProtocols = BrowseExpertListApiDataManager()
            APIDataManager.getBrowseExpertList(data: BrowseExpertListModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onGetBrowseExpertListFailed(error: error)
                case .Success(let data as BrowseExpertListOutputDomainModel):
                    do {
                        self.onGetBrowseExpertListSucceeded(data: data)
                    } catch {
                        self.onGetBrowseExpertListFailed(data: data)
                    }
                default:
                    break
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = 28+teacherNameHeight+10+25+16+expertiseHeight+4+coachingHeight+4+locationHeight+59
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: requestButton Click method
    func requestButtonClicked(button: UIButton) {
        self.view.endEditing(true)
        let index = button.tag
        let dic : NSDictionary = categoryArray[index] as! NSDictionary
        self.requestId = dic.value(forKey: "user_id") as! String
        self.expertId = dic.value(forKey: "expert_id") as! String
        self.categoryId = dic.value(forKey: "category_id") as! String
        self.subCategoryId = dic.value(forKey: "sub_category_id") as! String
        
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "BrowseExpertsVC")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Sending Request".localized(in: "BrowseExpertsVC")
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
    
    // MARK: BrowseExpertList API response methods
    func onGetBrowseExpertListSucceeded(data: BrowseExpertListOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            if nextOffset == 0 {
                self.categoryArray.removeAllObjects()
            }
            self.categoryArray.addObjects(from: data.categories as! [Any])
            self.totalCount =  Int(data.totalCount)!
            self.nextOffset = Int(data.nextOffset)!
            self.tableview.reloadData()
            noDataLabel.isHidden = self.categoryArray.count == 0 ? false : true
            self.totalExpertsLabel.isHidden = self.categoryArray.count == 0 ? true : false
            self.totalCountBaseView.isHidden = self.categoryArray.count == 0 ? true : false
            let aStr = String(format: "%@ Expert(s) available to connect with",data.totalCount)
            self.totalExpertsLabel.text = aStr
        } else {
            self.categoryArray.removeAllObjects()
            self.tableview.reloadData()
            //            self.displayErrorMessage(message: data.message)
            noDataLabel.isHidden = self.categoryArray.count == 0 ? false : true
            self.totalExpertsLabel.isHidden = self.categoryArray.count == 0 ? true : false
            self.totalCountBaseView.isHidden = self.categoryArray.count == 0 ? true : false
        }
    }
    
    func onGetBrowseExpertListFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.categoryArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: "No updated teacher list found in the database")
        noDataLabel.isHidden = self.categoryArray.count == 0 ? false : true
        self.totalExpertsLabel.isHidden = self.categoryArray.count == 0 ? true : false
        self.totalCountBaseView.isHidden = self.categoryArray.count == 0 ? true : false
    }
    
    func onGetBrowseExpertListFailed(data:BrowseExpertListOutputDomainModel) {
        self.dismissProgress()
        self.categoryArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: data.message)
        noDataLabel.isHidden = self.categoryArray.count == 0 ? false : true
        self.totalExpertsLabel.isHidden = self.categoryArray.count == 0 ? true : false
        self.totalCountBaseView.isHidden = self.categoryArray.count == 0 ? true : false
    }
    
    // MARK: Request API response methods
    func onRequSendestSucceeded(data: SendRequestOutputDomainModel, button: UIButton) {
        self.dismissProgress()
        if data.status {
            let index = button.tag
            self.setExpertConnectGrayButtonTheme(button: button)
            let dic : NSDictionary = self.categoryArray[index] as! NSDictionary
            let foundationDictionary = NSMutableDictionary(dictionary: dic)
            foundationDictionary["flag"] = 1
            self.categoryArray[index] = foundationDictionary
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
    
    func displaySuccessMessage(message: String) {
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
