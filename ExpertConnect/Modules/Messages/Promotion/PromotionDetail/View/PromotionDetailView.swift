//
//  AddDetailBlogView.swift
//  ExpertConnect
//
//  Created by Redbytes on 06/02/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import Cosmos
import SafariServices
import SwiftyJSON

class PromotionDetailView: UIViewController, CustomIOS7AlertViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet var starView: CosmosView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var mainCategoryStaticLabel: UILabel!
    @IBOutlet var subCategoryStaticLabel: UILabel!
    @IBOutlet var mainCategoryLabel: UILabel!
    @IBOutlet var subCategoryLabel: UILabel!
    @IBOutlet weak var urlStaticLabel: UILabel!
    @IBOutlet weak var blogUrlButton: UIButton!
    @IBOutlet weak var descriptionStaticLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feeStaticLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var offerDateStaticLabel: UILabel!
    @IBOutlet weak var offerDateLabel: UILabel!
    @IBOutlet weak var locationStaticLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    let alertView = CustomIOS7AlertView()
    var alertActionType = String()
    let buttonsForSendMessage = ["SEND"]
    var messageTextView = UITextView()
    var ratingView = CosmosView()
    var userId: String = ""
    
    var teacherNameHeight = CGFloat()
    var mainCategoryStaticHeight = CGFloat()
    var mainCategoryHeight = CGFloat()
    var subCategoryStaticHeight = CGFloat()
    var subCategoryHeight = CGFloat()
    var feeStaticHeight = CGFloat()
    var feeHeight = CGFloat()
    var offerDateStaticHeight = CGFloat()
    var offerDateHeight = CGFloat()
    var locationStaticHeight = CGFloat()
    var locationHeight = CGFloat()
    
    var detailContentStaticHeight = CGFloat()
    var detailContentHeight = CGFloat()
    var descriptionStaticHeight = CGFloat()
    var descriptionHeight = CGFloat()
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)
    let teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+40+22))
    
    let mainCategoryStaticWidth : CGFloat = 97
    let mainCategoryWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+97+8+22))
    
    let subCategoryStaticWidth : CGFloat = 91
    let subCategoryWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+91+8+22))
    
    let feeStaticWidth : CGFloat = 28
    let feeWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+28+8+22))
    
    let offerDateStaticWidth : CGFloat = 91
    let offerDateWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+91+8+22))
    
    let locationStaticWidth : CGFloat = 58
    let locationWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+58+8+22))
    
    let detailContentStaticWidth : CGFloat = 87
    let detailContentWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+87+8+22))
    
    let descriptionStaticWidth : CGFloat = 75
    let descriptionWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+75+8+22))
    
    var reviewLabelHeight = CGFloat()
    let reviewLabelWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+22))
    
    var promotionDetail: PromotionModel = PromotionModel()
    var commentsArray = NSMutableArray()
    var commentedByArray = Array<Any>()
    var command: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.makeProfileImageCircular()
        self.setECTableViewCellShadowTheme(view: self.mainView)
        self.setBlogDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Promotion Detail"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.configureTopView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setBlogDetails() {
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String

        if promotionDetail.userId == self.userId {
            self.messageButton.isHidden = true
        } else {
            self.messageButton.isHidden = false
        }
        self.teacherNameLabel.text = promotionDetail.userName
        // collecting Ratings in ratingArray
        let ratingDetails : NSArray = promotionDetail.teacherRating
        var ratingArray = Array<Any>()
        for rating in ratingDetails {
            let str:NSDictionary = rating as! NSDictionary
            ratingArray.append(str.value(forKey: "overallTeacherRating") as! String)
        }
        if(ratingArray.count > 0) {
            self.starView.rating = Double(ratingArray[0]  as! String)!
            self.starView.settings.fillMode = .precise
        } else {
            self.starView.rating = Double("0")!
            self.starView.settings.fillMode = .precise
        }

        self.mainCategoryLabel.text = promotionDetail.categoryName
        self.subCategoryLabel.text = promotionDetail.subcategoryName
        self.descriptionLabel.text = promotionDetail.descreption
        
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
        self.feeLabel.attributedText = feeMutableString
        self.offerDateLabel.text = promotionDetail.offerDate
        self.locationLabel.text = promotionDetail.location

        self.profileImageview.image = UIImage(named: "profile_rectangle_img")
        if (promotionDetail.profilePic != "") {
            let url = URL(string: promotionDetail.profilePic)
            self.profileImageview.kf.setImage(with: url)
        }
        let attributes = [
            NSFontAttributeName : UIFont(name: "Raleway-Light", size: 14)!,
            NSForegroundColorAttributeName : UIColor.ExpertConnectURL,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
            ] as [String : Any]
        let attributedString = NSAttributedString(string: "http://www.dummyUrl.com", attributes: attributes)
        self.blogUrlButton.setAttributedTitle(attributedString,for: .normal)
    }
    
    private func makeProfileImageCircular() {
        self.profileImageview.layer.cornerRadius = 15.0
        self.profileImageview.clipsToBounds = true
        self.profileImageview.layer.borderWidth = CGFloat(0.0)
        self.profileImageview.layer.borderColor = UIColor.ExpertConnectBlack.cgColor
    }
    
    private func configureTopView() {
        teacherNameHeight = (self.teacherNameLabel.text?.heightForView(text: self.teacherNameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: teacherNameWidth))!
        mainCategoryStaticHeight = (self.mainCategoryStaticLabel.text?.heightForView(text: self.mainCategoryStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: mainCategoryStaticWidth))!
        mainCategoryHeight = (self.mainCategoryLabel.text?.heightForView(text: (self.mainCategoryLabel.text)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: mainCategoryWidth))!
        subCategoryStaticHeight = (self.subCategoryStaticLabel.text?.heightForView(text: self.subCategoryStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:subCategoryStaticWidth))!
        subCategoryHeight = (self.subCategoryLabel.text?.heightForView(text: self.subCategoryLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: subCategoryWidth))!
        
        
        feeStaticHeight = (self.feeStaticLabel.text?.heightForView(text: self.feeStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:feeStaticWidth))!
        feeHeight = (self.feeLabel.text?.heightForView(text: self.feeLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: feeWidth))!
        
        offerDateStaticHeight = (self.offerDateStaticLabel.text?.heightForView(text: self.offerDateStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: offerDateStaticWidth))!
        offerDateHeight = (self.offerDateLabel.text?.heightForView(text: self.offerDateLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: offerDateWidth))!
        
        locationStaticHeight = (self.locationStaticLabel.text?.heightForView(text: self.locationStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationStaticWidth))!
        locationHeight = (self.locationLabel.text?.heightForView(text: self.locationLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: locationWidth))!
        

        descriptionStaticHeight = (self.descriptionStaticLabel.text?.heightForView(text: self.descriptionStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:descriptionStaticWidth))!
        descriptionHeight = (self.descriptionLabel.text?.heightForView(text: self.descriptionLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: descriptionWidth))!
        detailContentStaticHeight = (self.urlStaticLabel.text?.heightForView(text: self.urlStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:detailContentStaticWidth))!
        detailContentHeight = (self.blogUrlButton.titleLabel?.text?.heightForView(text: (self.blogUrlButton.titleLabel?.text!)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: detailContentWidth))!
        
        self.teacherNameLabel.removeConstraints(self.teacherNameLabel.constraints)
        self.starView.removeConstraints(self.starView.constraints)
        self.mainCategoryStaticLabel.removeConstraints(self.mainCategoryStaticLabel.constraints)
        self.mainCategoryLabel.removeConstraints(self.mainCategoryLabel.constraints)
        self.subCategoryStaticLabel.removeConstraints(self.subCategoryStaticLabel.constraints)
        self.subCategoryLabel.removeConstraints(self.subCategoryLabel.constraints)
        
        self.feeStaticLabel.removeConstraints(self.feeStaticLabel.constraints)
        self.feeLabel.removeConstraints(self.feeLabel.constraints)
        self.offerDateStaticLabel.removeConstraints(self.offerDateStaticLabel.constraints)
        self.offerDateLabel.removeConstraints(self.offerDateLabel.constraints)
        self.locationStaticLabel.removeConstraints(self.locationStaticLabel.constraints)
        self.locationLabel.removeConstraints(self.locationLabel.constraints)

        self.descriptionStaticLabel.removeConstraints(self.descriptionStaticLabel.constraints)
        self.descriptionLabel.removeConstraints(self.descriptionLabel.constraints)
        self.urlStaticLabel.removeConstraints(self.urlStaticLabel.constraints)
        self.blogUrlButton.removeConstraints(self.blogUrlButton.constraints)
        
        self.setConstraints(actualView: self.teacherNameLabel, leadingView: self.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 40, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 10, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setConstraints(actualView: self.starView, leadingView: self.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 39, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 8, height: 20, width: 50, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        //        if teacherNameHeight > 20.0 {
        self.setConstraints(actualView: self.mainCategoryStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: mainCategoryStaticHeight, width: mainCategoryStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: self.mainCategoryLabel, leadingView: self.mainCategoryStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: mainCategoryHeight, width: mainCategoryWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        //        } else {
        //            self.setConstraints(actualView: cell.titleStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 28, height: titleStaticHeight, width: titleStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        //
        //            self.setConstraints(actualView: cell.titleLabel, leadingView: cell.titleStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 28, height: titleHeight, width: titleWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        //        }
        
        if mainCategoryHeight > mainCategoryStaticHeight {
            self.setConstraints(actualView: self.subCategoryStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.mainCategoryLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: subCategoryStaticHeight, width: subCategoryStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: self.subCategoryStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.mainCategoryLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: subCategoryStaticHeight, width: subCategoryStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: self.subCategoryLabel, leadingView: self.subCategoryStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.mainCategoryLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: subCategoryHeight, width: subCategoryWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        //Fee
        if subCategoryHeight > subCategoryStaticHeight {
            self.setConstraints(actualView: self.feeStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.subCategoryLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: self.feeStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.subCategoryLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeStaticHeight, width: feeStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: self.feeLabel, leadingView: self.feeStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.subCategoryLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: feeHeight, width: feeWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
       
        //Offer Date
        if feeHeight > feeStaticHeight {
            self.setConstraints(actualView: self.offerDateStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.feeLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: offerDateStaticHeight, width: offerDateStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: self.offerDateStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.feeLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: offerDateStaticHeight, width: offerDateStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: self.offerDateLabel, leadingView: self.offerDateStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.feeLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: offerDateHeight, width: offerDateWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        //Location
        if offerDateHeight > offerDateStaticHeight {
            self.setConstraints(actualView: self.locationStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.offerDateLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: self.locationStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.offerDateLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationStaticHeight, width: locationStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: self.locationLabel, leadingView: self.locationStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.offerDateLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: locationHeight, width: locationWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)

        //Descreption
        if locationHeight > locationStaticHeight {
            self.setConstraints(actualView: self.descriptionStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: descriptionStaticHeight, width: descriptionStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: self.descriptionStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: descriptionStaticHeight, width: descriptionStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: self.descriptionLabel, leadingView: self.descriptionStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.locationLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: descriptionHeight, width: descriptionWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if descriptionHeight > descriptionStaticHeight {
            self.setConstraints(actualView: self.urlStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.descriptionLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: detailContentStaticHeight, width: detailContentStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: self.urlStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.descriptionLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: detailContentStaticHeight, width: detailContentStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: self.blogUrlButton, leadingView: self.urlStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.descriptionLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: detailContentHeight, width: detailContentWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.blogUrlButton.layoutIfNeeded()
        let height = (10)+(teacherNameHeight)+(8)+(20)+(10)+(mainCategoryHeight)+(4)+(subCategoryHeight)+(4)+(feeHeight)+(4)+(offerDateHeight)+(4)+(locationHeight)+(descriptionHeight)+(10)+(detailContentHeight)+(10)
        self.mainView.frame = CGRect(x: self.mainView.frame.origin.x, y: self.mainView.frame.origin.y, width: self.mainView.frame.size.width, height: height)
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
    
    @IBAction func blogButtonClicked(_ sender: UIButton) {
        if (!self.verifyUrl(urlString: (sender.titleLabel?.text)!)) {
            let message = "IncorrectURL".localized(in: "BlogDetailView")
            self.displayErrorMessage(message: message)
            return
        }
        
        let safariVC = SFSafariViewController(url: NSURL(string: (sender.titleLabel?.text)!)! as URL)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    // MARK: Send Message Button Click method
     @IBAction func sendMessageButtonClicked(button: UIButton) {
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
            let sendMessageInputModel = SendMessageInputModel.init(senderId: self.userId, receiverId: promotionDetail.userId, message: textMessage.trimmingCharacters(in: .whitespacesAndNewlines))
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
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
}
