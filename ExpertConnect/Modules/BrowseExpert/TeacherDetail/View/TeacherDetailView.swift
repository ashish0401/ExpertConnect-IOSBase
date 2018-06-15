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
import SwiftyJSON
import MessageUI

class TeacherDetailView: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomIOS7AlertViewDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var tableview: UITableView!
    var techerDetail = NSDictionary()
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
    var ratingView = CosmosView()
    @IBOutlet weak var rateButton: UIButton!

    var teacherNameHeight = CGFloat()
    
    var expertiseStaticHeight = CGFloat()
    var expertiseHeight = CGFloat()
    
    var qualificationStaticHeight = CGFloat()
    var qualificationHeight = CGFloat()
    
    var coachingStaticHeight = CGFloat()
    var coachingHeight = CGFloat()
    
    var feeStaticHeight = CGFloat()
    var feeHeight = CGFloat()
    
    var genderStaticHeight = CGFloat()
    var genderHeight = CGFloat()
    
    var emailStaticHeight = CGFloat()
    var emailHeight = CGFloat()
    
    var mobileStaticHeight = CGFloat()
    var mobileHeight = CGFloat()
    
    var locationStaticHeight = CGFloat()
    var locationHeight = CGFloat()
    
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)
    let teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+40+10+44+33))
    
    let expertiseStaticWidth : CGFloat = 62
    let expertiseWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+62+8+22))
    
    let qualificationStaticWidth : CGFloat = 81
    let qualificationWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+81+8+22))
    
    let coachingStaticWidth : CGFloat = 64
    var coachingWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+64+8+22))
    
    let feeStaticWidth : CGFloat = 28
    let feeWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+28+8+22))
    
    let genderStaticWidth : CGFloat = 51
    let genderWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+51+8+22))
    
    let emailStaticWidth : CGFloat = 53
    let emailWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+53+8+22))
    
    let mobileStaticWidth : CGFloat = 70
    let mobileWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+70+8+22))
    
    let locationStaticWidth : CGFloat = 58
    let locationWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+58+8+22))
    
    
    var locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    var lattitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var cityName : String = ""
    
    var alertActionType = String()
    let buttonsForSendMessage = ["SEND"]
    let buttonsForRating = ["SUBMIT"]
    var messageTextView = UITextView()
    
    var ratedByArray = Array<Any>()
    var blogListArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.makeTableSeperatorColorClear()
        self.rateButton.titleLabel!.font =  UIFont(name: "Raleway-SemoBold", size: 18)
        self.rateButton.backgroundColor = UIColor(red: 236/255.0, green: 61/255.0, blue: 3/255.0, alpha: 1.0)

        let apiConverter = TeacherDetailApiModelConverter()
        let dic : NSDictionary = self.techerDetail
        self.blogListArray = apiConverter.fromJson(json: dic.value(forKey: "blogList") as! Array) as [BlogViewOutputDomainModel] as! NSMutableArray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Teacher Detail"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coachingWidth = (UIScreen.main.bounds.size.width-(32+24+8+64))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    // MARK: tableview datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 1
        } else {
            return self.blogListArray.count
        }
    }
        
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Raleway-Light", size: 18)!
        header.textLabel?.textColor = UIColor.ExpertConnectBlack
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let identifier = "TeacherDetailCustomCell"
            var cell: TeacherDetailCustomCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TeacherDetailCustomCell
            if cell == nil {
                tableView.register(TeacherDetailCustomCell.self, forCellReuseIdentifier: "TeacherDetailCustomCell")
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TeacherDetailCustomCell
            }
            
            cell.emailButton.tag = indexPath.row
            cell.emailButton.addTarget(self, action: #selector(sendEmailButtonClicked(button:)), for: .touchUpInside)
            
            cell.mobileButton.tag = indexPath.row
            cell.mobileButton.addTarget(self, action: #selector(mobileButtonClicked(button:)), for: .touchUpInside)
            
            cell.requestButton.tag = indexPath.row
            cell.requestButton.addTarget(self, action: #selector(sendMessageButtonClicked(button:)), for: .touchUpInside)

            let dic : NSDictionary = self.techerDetail
            
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
            cell.qualificationLabel.text = dic.value(forKey: "qualification") as? String
            cell.feeLabel.text = dic.value(forKey: "base_price") as? String
            cell.genderLabel.text = dic.value(forKey: "gender") as? String
            let attributes = [
                NSFontAttributeName : UIFont(name: "Raleway-Light", size: 14)!,
                NSForegroundColorAttributeName : UIColor.ExpertConnectURL,
                NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
                ] as [String : Any]
            let attributedEmailString = NSAttributedString(string: (dic.value(forKey: "email_id") as? String)!, attributes: attributes)
            let attributedMobileString = NSAttributedString(string: (dic.value(forKey: "mobile_no") as? String)!, attributes: attributes)
            cell.emailButton.setAttributedTitle(attributedEmailString,for: .normal)
            cell.mobileButton.setAttributedTitle(attributedMobileString,for: .normal)
            
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
            
            teacherNameHeight = (cell.teacherNameLabel.text?.heightForView(text: cell.teacherNameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: teacherNameWidth))!
            
            expertiseStaticHeight = (cell.expertiseStaticLabel.text?.heightForView(text: cell.expertiseStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: expertiseStaticWidth))!
            expertiseHeight = (cell.expertiseLabel.text?.heightForView(text: (cell.expertiseLabel.text)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: expertiseWidth))!
            
            qualificationStaticHeight = (cell.qualificationStaticLabel.text?.heightForView(text: cell.qualificationStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: qualificationStaticWidth))!
            qualificationHeight = (cell.qualificationLabel.text?.heightForView(text: (cell.qualificationLabel.text)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: qualificationWidth))!
            
            coachingStaticHeight = (cell.coachingStaticLabel.text?.heightForView(text: cell.coachingStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: coachingStaticWidth))!
            coachingHeight = (cell.coachingLabel.text?.heightForView(text: cell.coachingLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:coachingWidth))!
            
            feeStaticHeight = (cell.feeStaticLabel.text?.heightForView(text: cell.feeStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:feeStaticWidth))!
            feeHeight = (cell.feeLabel.text?.heightForView(text: cell.feeLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: feeWidth))!
            
            genderStaticHeight = (cell.genderStaticLabel.text?.heightForView(text: cell.genderStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:genderStaticWidth))!
            genderHeight = (cell.genderLabel.text?.heightForView(text: cell.genderLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: genderWidth))!
            
            emailStaticHeight = (cell.emailStaticLabel.text?.heightForView(text: cell.emailStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:emailStaticWidth))!
            emailHeight = (cell.emailButton.titleLabel?.text?.heightForView(text: (cell.emailButton.titleLabel?.text!)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: emailWidth))!
            
            mobileStaticHeight = (cell.mobileStaticLabel.text?.heightForView(text: cell.mobileStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:mobileStaticWidth))!
            mobileHeight = (cell.mobileButton.titleLabel?.text?.heightForView(text: (cell.mobileButton.titleLabel?.text!)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: mobileWidth))!
            
            locationStaticHeight = (cell.locationStaticLabel.text?.heightForView(text: cell.locationStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationStaticWidth))!
            locationHeight = (cell.locationLabel.text?.heightForView(text: cell.locationLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationWidth))!
            
            cell.teacherNameLabel.removeConstraints(cell.teacherNameLabel.constraints)
            cell.starView.removeConstraints(cell.starView.constraints)
            
            cell.expertiseStaticLabel.removeConstraints(cell.expertiseStaticLabel.constraints)
            cell.expertiseLabel.removeConstraints(cell.expertiseLabel.constraints)
            
            cell.qualificationStaticLabel.removeConstraints(cell.qualificationStaticLabel.constraints)
            cell.qualificationLabel.removeConstraints(cell.qualificationLabel.constraints)
            
            cell.coachingStaticLabel.removeConstraints(cell.coachingStaticLabel.constraints)
            cell.coachingLabel.removeConstraints(cell.coachingLabel.constraints)
            
            cell.feeStaticLabel.removeConstraints(cell.feeStaticLabel.constraints)
            cell.feeLabel.removeConstraints(cell.feeLabel.constraints)
            
            cell.genderStaticLabel.removeConstraints(cell.genderStaticLabel.constraints)
            cell.genderLabel.removeConstraints(cell.genderLabel.constraints)
            
            cell.emailStaticLabel.removeConstraints(cell.emailStaticLabel.constraints)
            cell.emailButton.removeConstraints(cell.emailButton.constraints)
            
            cell.mobileStaticLabel.removeConstraints(cell.mobileStaticLabel.constraints)
            cell.mobileButton.removeConstraints(cell.mobileButton.constraints)
            
            cell.locationStaticLabel.removeConstraints(cell.locationStaticLabel.constraints)
            cell.locationLabel.removeConstraints(cell.locationLabel.constraints)
            
            self.setConstraints(actualView: cell.teacherNameLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 40, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 75, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 10, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            self.setConstraints(actualView: cell.starView, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 39, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 8, height: 20, width: 50, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: cell.expertiseStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: expertiseStaticHeight, width: expertiseStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: cell.expertiseLabel, leadingView: cell.expertiseStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: expertiseHeight, width: expertiseWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            if expertiseHeight > expertiseStaticHeight {
                self.setConstraints(actualView: cell.qualificationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: qualificationStaticHeight, width: qualificationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                
                self.setConstraints(actualView: cell.qualificationLabel, leadingView: cell.qualificationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.expertiseLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: qualificationHeight, width: qualificationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
                
            }
            else {
                self.setConstraints(actualView: cell.qualificationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.expertiseStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: qualificationStaticHeight, width: qualificationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.qualificationLabel, leadingView: cell.qualificationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.expertiseStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: qualificationHeight, width: qualificationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            }
            
            //Coaching Detail
            if qualificationHeight > qualificationStaticHeight {
                self.setConstraints(actualView: cell.coachingStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.qualificationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.coachingLabel, leadingView: cell.coachingStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.qualificationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingHeight, width: coachingWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
                
            }
            else {
                self.setConstraints(actualView: cell.coachingStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.qualificationStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingStaticHeight, width: coachingStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.coachingLabel, leadingView: cell.coachingStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.qualificationStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: coachingHeight, width: coachingWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
                
            }
            
            //Fee Detail
            if coachingHeight > coachingStaticHeight {
                self.setConstraints(actualView: cell.feeStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.feeLabel, leadingView: cell.feeStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.coachingLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeHeight, width: feeWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
                
            }
            else {
                self.setConstraints(actualView: cell.feeStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.coachingStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.feeLabel, leadingView: cell.feeStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.coachingStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeHeight, width: feeWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            }
            
            //Gender Detail
            if feeHeight > feeStaticHeight {
                self.setConstraints(actualView: cell.genderStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.feeLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderStaticHeight, width: genderStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                
                self.setConstraints(actualView: cell.genderLabel, leadingView: cell.genderStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.feeLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderHeight, width: genderWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            }
            else {
                self.setConstraints(actualView: cell.genderStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.feeStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderStaticHeight, width: genderStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.genderLabel, leadingView: cell.genderStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.feeStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: genderHeight, width: genderWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            }
            
            //Email Detail
            if genderHeight > genderStaticHeight {
                self.setConstraints(actualView: cell.emailStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.genderLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: emailStaticHeight, width: emailStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.emailButton, leadingView: cell.emailStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.genderLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: emailHeight, width: emailWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            }
            else {
                self.setConstraints(actualView: cell.emailStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.genderStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: emailStaticHeight, width: emailStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.emailButton, leadingView: cell.emailStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.genderStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: emailHeight, width: emailWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            }
            
            
            //Mobile Detail
            if emailHeight > emailStaticHeight {
                self.setConstraints(actualView: cell.mobileStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.emailLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: mobileStaticHeight, width: mobileStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.mobileButton, leadingView: cell.mobileStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.emailLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: mobileHeight, width: mobileWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            }
            else {
                self.setConstraints(actualView: cell.mobileStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.emailStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: mobileStaticHeight, width: mobileStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.mobileButton, leadingView: cell.mobileStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.emailStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: mobileHeight, width: mobileWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            }
            
            
            //Location Detail
            if mobileHeight > mobileStaticHeight {
                self.setConstraints(actualView: cell.locationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.mobileLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.locationLabel, leadingView: cell.locationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.mobileLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationHeight, width: locationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
                
            }
            else {
                self.setConstraints(actualView: cell.locationStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.mobileStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
                
                self.setConstraints(actualView: cell.locationLabel, leadingView: cell.locationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.mobileStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationHeight, width: locationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            }
            
            
            self.setECTableViewCellShadowTheme(view: cell.mainView)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        } else {
            let identifier = "BlogCustomCell"
            var cell: BlogCustomCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BlogCustomCell
            if cell == nil {
                tableView.register(BlogCustomCell.self, forCellReuseIdentifier: "BlogCustomCell")
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BlogCustomCell
            }
            
            let blogDetail = self.blogListArray[indexPath.row] as! BlogViewOutputDomainModel
            cell.teacherNameLabel.text = blogDetail.authorName
            cell.titleLabel.text = blogDetail.blogTitle
            cell.categoryLabel.text = blogDetail.categoryName
            
            self.setECTableViewCellShadowTheme(view: cell.mainView)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    // MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            if(qualificationHeight < qualificationStaticHeight) {
                qualificationHeight = qualificationStaticHeight
            }
            let height = (22)+(teacherNameHeight)+(8)+(20)+(10)+(expertiseHeight)+(4)+(qualificationHeight)+(4)+(coachingHeight)+(4)+(feeHeight)+(4)+(genderHeight)+(4)+(emailHeight)+(4)+(mobileHeight)+(4)+(locationHeight)+(22)
            return height
        } else {
            return 103
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 1:
            if(self.blogListArray.count == 0) {return "No Blogs Written Yet."}
            else if(self.blogListArray.count == 1) {return "1 Blog Written"}
            else {return String(format: "%d Blogs Written", self.self.blogListArray.count)}
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1) {
            let blogDetailView : BlogDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlogDetailView") as UIViewController as! BlogDetailView
            blogDetailView.blogDetail = self.blogListArray[indexPath.row] as! BlogViewOutputDomainModel
            self.navigationController?.pushViewController(blogDetailView, animated: true)
        }
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
    
//    // MARK: Alert methods
//    func displayErrorMessage(message: String) {
//        self.showErrorMessage(message: message)
//    }
//    
//    func displaySuccessMessage(message: String) {
//        self.showSuccessMessage(message: message)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Call Button Click method
    func mobileButtonClicked(button: UIButton) {
        if let phoneCallURL = URL(string: "tel://\((button.titleLabel?.text)!)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                self.showErrorMessage(message: "There was an error")
            }
        }
    }
    
    // MARK: Send Email Button Click method
    func sendEmailButtonClicked(button: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController(email: (button.titleLabel?.text)!)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
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
            let sendMessageInputModel = SendMessageInputModel.init(senderId: self.userId, receiverId: self.techerDetail.value(forKey: "user_id") as! String, message: textMessage.trimmingCharacters(in: .whitespacesAndNewlines))
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
        } else if alertActionType == "rateTeacherAction" {
            if (self.ratingView.rating == 0) {
                let message = "Please add your rating"
                alertView.close()
                self.displayErrorMessageWithCallback(message: message)
                return
            }
            
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let rating = String(format: "%.1f", self.ratingView.rating)
            let dic : NSDictionary = self.techerDetail
            let teacherId: String = dic.value(forKey: "user_id") as! String
            let expertId: String = dic.value(forKey: "expert_id") as! String

            let message = "Posting Review".localized(in: "BlogDetailView")
            self.displayProgress(message: message)
            let teacherRatingInputDomainModel = TeacherRatingInputDomainModel.init(teacherId: teacherId, expertId: expertId,  ratedBy : self.userId, rating : rating)
            let APIDataManager : TeacherDetailProtocols = TeacherDetailApiDataManager()
            APIDataManager.addReview(data: teacherRatingInputDomainModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onAddReviewFailed(error: error)
                    break
                    
                case .Success(let data as OTPOutputDomainModel):
                    self.onAddReviewSucceed(data: data)
                    break
                    
                default:
                    break
                }
            })
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
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func configuredMailComposeViewController(email: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients([email])
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        self.showErrorMessage(message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateTecherButtonClicked(_ sender: UIButton) {
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String

        if(self.ratedByArray.contains(obj: self.userId)) {
            self.showErrorMessage(message: "You have already rated this teacher.")
            return
        }
        alertActionType = "rateTeacherAction"
        alertView.buttonTitles = buttonsForRating
        // Set a custom container view
        alertView.containerView = createContainerViewForTeacherRating()
        // Set self as the delegate
        alertView.delegate = self
        // Show time!
        alertView.catchString(withString: "5")
        alertView.show()  
    }
    
    func createContainerViewForTeacherRating() -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 140))
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 290, height: 30))
        label.text = "Rate This Teacher"
        label.textAlignment = NSTextAlignment.center
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
        
        self.ratingView = CosmosView.init(frame:CGRect(x: 85, y: 100, width: 100, height: 40))
        self.ratingView.rating = 0
        self.ratingView.settings.fillMode = .precise
        self.ratingView.settings.emptyBorderColor = UIColor.init(colorLiteralRed: 137/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1.0)
        self.ratingView.settings.emptyColor = UIColor.init(colorLiteralRed: 137/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1.0)
        self.ratingView.settings.filledBorderColor = UIColor.init(colorLiteralRed: 255/255.0, green: 152/255.0, blue: 0, alpha: 1.0)
        self.ratingView.settings.filledColor = UIColor.init(colorLiteralRed: 255/255.0, green: 152/255.0, blue: 0, alpha: 1.0)
        View.addSubview(self.ratingView)
        self.ratingView.update()

        return View;
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

    // MARK: Verify OTP Methods
    func onAddReviewSucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            self.displaySuccessMessage(message: data.message)
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onAddReviewFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Rating Post Failed")
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
}
