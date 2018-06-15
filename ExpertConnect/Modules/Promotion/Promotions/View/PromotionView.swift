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
import GooglePlacePicker
import GoogleMaps
import GooglePlaces

class PromotionView: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomIOS7AlertViewDelegate, UITextViewDelegate, AddExpertiseProtocol, AddPromotionDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var tableview: UITableView!
    var promotionArray = NSMutableArray()
    var userId = String()
    var receiverId = String()
    var location = String()
    var expertId = String()
    var requestId = String()
    var categoryId = String()
    var subCategoryId = String()
    let alertView = CustomIOS7AlertView()
    var tempExpertId = Int()
    var noDataLabel = UILabel()
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
    let teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+40+10+44+33))
    
    let expertiseStaticWidth : CGFloat = 62
    let expertiseWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+62+8+22))
    
    let feeStaticWidth : CGFloat = 28
    let feeWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+28+8+130+12))
    
    let genderStaticWidth : CGFloat = 51
    let genderWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+51+8+22))
    
    let locationStaticWidth : CGFloat = 58
    let locationWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+58+8+22))
    
    var cityName : String = ""
    var command: String = ""
    
    var alertActionType = String()
    let buttonsForSendMessage = ["SEND"]
    var messageTextView = UITextView()
    var isShowAlert: Bool = false
    var alertMessage: String = ""

    //Teacher Outut Model
    var teacherUserId = String()
    var teacherName = String()
    var teacherProfilePic = String()
    var teachergender = String()
    var teacherCoachingDetails: NSArray = [NSMutableDictionary]() as NSArray
    var teacherRating: NSArray = [NSMutableDictionary]() as NSArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeTableSeperatorColorClear()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Promotions"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.activateBackIcon()
        self.activateAddPromotionIcon(delegate:self)

        self.segmentedControl.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Raleway-Light", size: 18.0)! ], for: .normal)
        let sortedViews = segmentedControl.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        for (index, view) in sortedViews.enumerated() {
            if index == segmentedControl.selectedSegmentIndex {
                view.tintColor = UIColor.ExpertConnectRed
            } else {
                view.tintColor = UIColor.ExpertConnectBlack
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(isShowAlert) {
            let message = self.alertMessage
            self.displaySuccessMessage(message: message)
            self.isShowAlert = false
        }
        if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            let message = "PromotionsUnavailable".localized(in: "PromotionView")
            self.noDataLabel = self.showStickyErrorMessage(message: message)
        } else {
            let message = "LoginRequest".localized(in: "MessagesView")
            self.noDataLabel = self.showStickyErrorMessage(message: message)
        }

        self.getPromotions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    // MARK: tableview datasource methods
    func getPromotions() {
        self.promotionArray.removeAllObjects()
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "PromotionView")
            self.displayErrorMessage(message: message)
            return
        }
        
        if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            self.location = UserDefaults.standard.value(forKey: "Location") as! String
        } else {
            self.userId = "0"
            self.location = self.cityName
        }
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.command = "getPromotionList"
        } else {
            self.command = "getMyPromotionList"
        }
        let message = "Loading".localized(in: "PromotionView")
        self.displayProgress(message: message)
        let promotionDomainModel = PromotionDomainModel.init(userId: self.userId, location: self.location, command: self.command)
        let APIDataManager : PromotionProtocols = PromotionApiDataManager()
        APIDataManager.getPromotionList(data: promotionDomainModel, callback:{(result) in
            print("result : ", result)
            if self.segmentedControl.selectedSegmentIndex == 0 {
                switch result {
                case .Failure(let error):
                    self.onGetPromotionListFailed(error: error)
                case .Success(let data as PromotionOutputDomainModel):
                    do {
                        self.onGetPromotionListSucceeded(data: data)
                    } catch {
                        self.onGetPromotionListFailed(data: data)
                    }
                default:
                    break
                }
                
            } else {
                switch result {
                case .Failure(let error):
                    self.onGetMyPromotionFailed(error: error)
                case .Success(let data as MyPromotionOutputDomainModel):
                    do {
                        self.onGetMyPromotionSucceeded(data: data)
                    } catch {
                        self.onGetMyPromotionFailed(data: data)
                    }
                default:
                    break
                }
                
            }
        })
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "TeacherListCell"
        var cell: TeacherListCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TeacherListCell
        if cell == nil {
            tableView.register(TeacherListCell.self, forCellReuseIdentifier: "TeacherListCell")
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TeacherListCell
        }
        
        cell.requestButton.tag = indexPath.row
        cell.requestButton.addTarget(self, action: #selector(sendMessageButtonClicked(button:)), for: .touchUpInside)
        
        let apiConverter = PromotionApiModelConverter()
        if self.segmentedControl.selectedSegmentIndex == 1 {
            cell.requestButton.isHidden = true
            let tempDic : NSDictionary = promotionArray[indexPath.row] as! NSDictionary
            let dic: NSMutableDictionary = tempDic.mutableCopy() as! NSMutableDictionary
            
            dic["user_id"] = self.teacherUserId
            dic["teacher_name"] = self.teacherName
            dic["profile_pic"] = self.teacherProfilePic
            dic["gender"] = self.teachergender
            dic["coaching_details"] = self.teacherCoachingDetails
            dic["teacher_rating"] = self.teacherRating
            let promotionDetail = apiConverter.fromJson(json: dic) as PromotionModel
            
            cell.teacherNameLabel.text = promotionDetail.userName
            cell.profileImageview.image = UIImage(named: "profile_rectangle_img")
            if (promotionDetail.profilePic != "") {
                let url = URL(string: promotionDetail.profilePic )
                cell.profileImageview.kf.setImage(with: url)
            }
            cell.expertiseLabel.text = promotionDetail.subcategoryName
            cell.locationLabel.text = promotionDetail.location
            cell.genderLabel.text = promotionDetail.gender
            //Attributed Fee String
            let basePrice = Double(promotionDetail.basePrice)!
            let discountPrice = Double(promotionDetail.discountPrice)!
            let percentage = Double((basePrice-discountPrice)/basePrice*100)
            let percentageStr = String(format: "%.0f",percentage)
            
            let feesString = "AU$ \(promotionDetail.discountPrice)   \(promotionDetail.basePrice) \(percentageStr)% off"
            var feeMutableString = NSMutableAttributedString()
            
            feeMutableString = NSMutableAttributedString(string: feesString, attributes: [NSFontAttributeName:UIFont(name: "Raleway-medium", size: 14)!])
            feeMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.ExpertConnectTabbarIconColor, range: NSRange(location:promotionDetail.discountPrice.characters.count + 4,length:promotionDetail.basePrice.characters.count + 9 + percentageStr.characters.count))
            
            feeMutableString.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.styleSingle, range: NSRange(location:promotionDetail.discountPrice.characters.count + 4,length:promotionDetail.basePrice.characters.count + 9 + percentageStr.characters.count))
            
            // set label Attribute
            cell.feeLabel.attributedText = feeMutableString
            // collecting Ratings in ratingArray
            let ratingDetails : NSArray = promotionDetail.teacherRating
            var ratingArray = Array<Any>()
            for rating in ratingDetails {
                let str:NSDictionary = rating as! NSDictionary
                ratingArray.append(str.value(forKey: "overallTeacherRating") as! String)
            }
            if(ratingArray.count > 0) {
                cell.starView.rating = Double(ratingArray[0]  as! String)!
                cell.starView.settings.fillMode = .precise
            } else {
                cell.starView.rating = Double("0")!
                cell.starView.settings.fillMode = .precise
            }
            
        } else {
            cell.requestButton.isHidden = false
            let promotionDetail = apiConverter.fromJson(json: promotionArray[indexPath.row] as! NSDictionary) as PromotionModel
            cell.teacherNameLabel.text = promotionDetail.userName
            cell.profileImageview.image = UIImage(named: "profile_rectangle_img")
            if (promotionDetail.profilePic != "") {
                let url = URL(string: promotionDetail.profilePic )
                cell.profileImageview.kf.setImage(with: url)
            }
            cell.expertiseLabel.text = promotionDetail.subcategoryName
            cell.locationLabel.text = promotionDetail.location
            cell.genderLabel.text = promotionDetail.gender
            
            //Attributed Fee String
            let basePrice = Double(promotionDetail.basePrice)!
            let discountPrice = Double(promotionDetail.discountPrice)!
            let percentage = Double((basePrice-discountPrice)/basePrice*100)
            let percentageStr = String(format: "%.0f",percentage)
            
            let feesString = "AU$ \(promotionDetail.discountPrice)   \(promotionDetail.basePrice) \(percentageStr)% off"
            var feeMutableString = NSMutableAttributedString()
            
            feeMutableString = NSMutableAttributedString(string: feesString, attributes: [NSFontAttributeName:UIFont(name: "Raleway-medium", size: 14)!])
            feeMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.ExpertConnectTabbarIconColor, range: NSRange(location:promotionDetail.discountPrice.characters.count + 4,length:promotionDetail.basePrice.characters.count + 9 + percentageStr.characters.count))
            
            feeMutableString.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.styleSingle, range: NSRange(location:promotionDetail.discountPrice.characters.count + 4,length:promotionDetail.basePrice.characters.count + 9 + percentageStr.characters.count))
            
            // set label Attribute
            cell.feeLabel.attributedText = feeMutableString
            // collecting Ratings in ratingArray
            let ratingDetails : NSArray = promotionDetail.teacherRating
            var ratingArray = Array<Any>()
            for rating in ratingDetails {
                let str:NSDictionary = rating as! NSDictionary
                ratingArray.append(str.value(forKey: "overallTeacherRating") as! String)
            }
            if(ratingArray.count > 0) {
                cell.starView.rating = Double(ratingArray[0]  as! String)!
                cell.starView.settings.fillMode = .precise
            } else {
                cell.starView.rating = Double("0")!
                cell.starView.settings.fillMode = .precise
            }
        }
        
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
        
        self.setConstraints(actualView: cell.teacherNameLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 40, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 75, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 10, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setConstraints(actualView: cell.starView, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 39, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 8, height: 20, width: 50, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.expertiseStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: expertiseStaticHeight, width: expertiseStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: cell.expertiseLabel, leadingView: cell.expertiseStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: expertiseHeight, width: expertiseWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if expertiseHeight > expertiseStaticHeight {
            self.setConstraints(actualView: cell.feeStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: cell.feeLabel, leadingView: cell.feeStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 130, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeHeight, width: feeWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            //Gender
            self.setConstraints(actualView: cell.genderStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: screenSize.size.width - screenWidth, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderStaticHeight, width: genderStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            
            self.setConstraints(actualView: cell.genderLabel, leadingView: cell.genderStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderHeight, width: genderWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
        } else {
            self.setConstraints(actualView: cell.feeStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: cell.feeLabel, leadingView: cell.feeStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 130, upperView: cell.expertiseStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeHeight, width: feeWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (22)+(teacherNameHeight)+(8)+(20)+(10)+(expertiseHeight)+(4)+(feeHeight)+(4)+(locationHeight)+(22)
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            //Go to login screen
            // self.navigationController!.pushViewController(LoginWireFrame.setupLoginModule() as UIViewController, animated: false)
            let loginView = LoginWireFrame.setupLoginModule() as UIViewController
            let navController = UINavigationController(rootViewController: loginView)
            self.present(navController, animated: true, completion: nil)
            loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        } else {
            let promotionDetailView : PromotionDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PromotionDetailView") as UIViewController as! PromotionDetailView
            
            let apiConverter = PromotionApiModelConverter()
            if self.segmentedControl.selectedSegmentIndex == 1 {
                let tempDic : NSDictionary = promotionArray[indexPath.row] as! NSDictionary
                let dic: NSMutableDictionary = tempDic.mutableCopy() as! NSMutableDictionary
                
                dic["user_id"] = self.teacherUserId
                dic["teacher_name"] = self.teacherName
                dic["profile_pic"] = self.teacherProfilePic
                dic["gender"] = self.teachergender
                dic["coaching_details"] = self.teacherCoachingDetails
                dic["teacher_rating"] = self.teacherRating
                let promotionDetail = apiConverter.fromJson(json: dic) as PromotionModel
                promotionDetailView.promotionDetail = promotionDetail
                
            } else {
                let promotionDetail = apiConverter.fromJson(json: promotionArray[indexPath.row] as! NSDictionary) as PromotionModel
                promotionDetailView.promotionDetail = promotionDetail
            }
            self.navigationController?.pushViewController(promotionDetailView, animated: true)
        }
    }
    
    // MARK: Segmented Control Button Click method
    @IBAction func segmentedControlClicked(_ sender: Any) {
        let sortedViews = (sender as AnyObject).subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        for (index, view) in sortedViews.enumerated() {
            if index == (sender as AnyObject).selectedSegmentIndex {
                view.tintColor = UIColor.ExpertConnectRed
            } else {
                view.tintColor = UIColor.ExpertConnectBlack
            }
        }
        self.getPromotions()
    }
    
    // MARK: PromotionList API response methods
    func onGetPromotionListSucceeded(data: PromotionOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.promotionArray = NSMutableArray.init(array: data.promotions as! [Any])
            self.tableview.reloadData()
            noDataLabel.isHidden = self.promotionArray.count == 0 ? false : true
        } else {
            self.promotionArray.removeAllObjects()
            self.tableview.reloadData()
            //            self.displayErrorMessage(message: data.message)
            noDataLabel.isHidden = self.promotionArray.count == 0 ? false : true
        }
    }
    
    func onGetPromotionListFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.promotionArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: "No updated teacher list found in the database")
        noDataLabel.isHidden = self.promotionArray.count == 0 ? false : true
    }
    
    func onGetPromotionListFailed(data:PromotionOutputDomainModel) {
        self.dismissProgress()
        self.promotionArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: data.message)
        noDataLabel.isHidden = self.promotionArray.count == 0 ? false : true
    }
    
    // MARK: My PromotionList API response methods
    func onGetMyPromotionSucceeded(data: MyPromotionOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.promotionArray = NSMutableArray.init(array: data.promotions as! [Any])
            self.teacherUserId = data.userId
            self.teacherName = data.userName
            self.teacherProfilePic = data.profilePic
            self.teachergender = data.gender
            self.teacherCoachingDetails = data.coachingDetails
            self.teacherRating = data.teacherRating
            self.tableview.reloadData()
            noDataLabel.isHidden = self.promotionArray.count == 0 ? false : true
        } else {
            self.promotionArray.removeAllObjects()
            self.tableview.reloadData()
            //            self.displayErrorMessage(message: data.message)
            noDataLabel.isHidden = self.promotionArray.count == 0 ? false : true
        }
    }
    
    func onGetMyPromotionFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.promotionArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: "No updated teacher list found in the database")
        noDataLabel.isHidden = self.promotionArray.count == 0 ? false : true
    }
    
    func onGetMyPromotionFailed(data:MyPromotionOutputDomainModel) {
        self.dismissProgress()
        self.promotionArray.removeAllObjects()
        self.tableview.reloadData()
        //self.displayErrorMessage(message: data.message)
        noDataLabel.isHidden = self.promotionArray.count == 0 ? false : true
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
        self.showStylishSuccessMessage(message: message)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let apiConverter = PromotionApiModelConverter()
            let promotionDetail = apiConverter.fromJson(json: promotionArray[button.tag] as! NSDictionary) as PromotionModel
            self.receiverId = promotionDetail.userId
            
            alertActionType = "sendMesageAction"
            alertView.buttonTitles = buttonsForSendMessage
            // Set a custom container view
            alertView.containerView = createContainerViewForMessage()
            // Set self as the delegate
            alertView.delegate = self
            // Show time!
            alertView.catchString(withString: "4")
            alertView.show()
        }
    }
    
    // MARK: Add Promotion Button Click
    func addPromotionButtonClicked() {
        if !UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            //Go to login screen
            let loginView = LoginWireFrame.setupLoginModule() as UIViewController
            let navController = UINavigationController(rootViewController: loginView)
            self.present(navController, animated: true, completion: nil)
            loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
            
        } else {
            let userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
            if(userType == "2") {
                alertView.containerView = createContainerView(acceptOrRejectSuccessMessage: "Please Upgrade to Teacher to Avail these Services")
                alertView.catchString(withString: "AlertUpgradeTeacher")
                alertView.buttonTitles = ["UPGRADE"]
                alertActionType = "UpgradeToTeacher"
                alertView.delegate = self
                alertView.show()
                return
            }
            
            let addPromotionView : AddPromotionView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPromotionView") as UIViewController as! AddPromotionView
            addPromotionView.delegate = self
            let navController = UINavigationController(rootViewController: addPromotionView)
            self.present(navController, animated: true, completion: nil)
            addPromotionView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        }
    }
    // MARK: Custom Alert Delegates
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        //  print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        if alertActionType == "UpgradeToTeacher" {
            let addExpertiseView : ExpertDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpertDetailsVC") as UIViewController as! ExpertDetailsVC
            addExpertiseView.isUpgradeToTeacherFromBlogView = true
            addExpertiseView.delegate = self
            //self.navigationController?.pushViewController(addExpertiseView, animated: true)
            
            let navController = UINavigationController(rootViewController: addExpertiseView)
            self.present(navController, animated: true, completion: nil)
            addExpertiseView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
            alertView.close()
        }
        
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
    
    // MARK: Custom Alert view method
    func createContainerView(acceptOrRejectSuccessMessage: String) -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 150))
        let label = UILabel(frame: CGRect(x: 20, y: 40, width: 240, height: 50))
        label.text = acceptOrRejectSuccessMessage
        //label.text = "Your request has been sent successfully."
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        
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
        
        return View
    }
    
    func createContainerViewForMessage() -> UIView {
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
    // MARK: - Add Upgrade to Teacher Delegate
    //@@@Vikas
    func addPromotionSucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }
}
