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

@objc protocol DeleteBlogDelegate {
    @objc optional func deleteBlogSucceded(showAlert:Bool, message: String) -> Void
}

class BlogDetailView: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomIOS7AlertViewDelegate, UITextViewDelegate {
    var delegate:DeleteBlogDelegate!
    
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var starView: CosmosView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var titleStaticLabel: UILabel!
    @IBOutlet var categoryStaticLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet weak var urlStaticLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var blogUrlButton: UIButton!
    @IBOutlet weak var descriptionStaticLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let alertView = CustomIOS7AlertView()
    var alertActionType = String()
    let buttonsForSendMessage = ["SUBMIT"]
    var messageTextView = UITextView()
    var ratingView = CosmosView()
    var userId: String = ""
    
    var teacherNameHeight = CGFloat()
    var titleStaticHeight = CGFloat()
    var titleHeight = CGFloat()
    var categoryStaticHeight = CGFloat()
    var categoryHeight = CGFloat()
    var detailContentStaticHeight = CGFloat()
    var detailContentHeight = CGFloat()
    var descriptionStaticHeight = CGFloat()
    var descriptionHeight = CGFloat()
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)
    let teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+40+22))
    let titleStaticWidth : CGFloat = 31
    let titleWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+31+8+22))
    let categoryStaticWidth : CGFloat = 62
    let categoryWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+62+8+22))
    let detailContentStaticWidth : CGFloat = 111
    let detailContentWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+111+8+22))
    let descriptionStaticWidth : CGFloat = 75
    let descriptionWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+75+8+22))
    
    var reviewLabelHeight = CGFloat()
    let reviewLabelWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+22))
    
    var blogDetail: BlogViewOutputDomainModel = BlogViewOutputDomainModel()
    var commentsArray = NSMutableArray()
    var commentedByArray = Array<Any>()
    var command: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.makeTableSeperatorColorClear()
        self.makeProfileImageCircular()
        self.setECTableViewCellShadowTheme(view: self.mainView)
        self.setBlogDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Blog Detail"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.configureTopView()
        self.tableview.frame = CGRect(x: self.tableview.frame.origin.x, y: self.mainView.frame.origin.y + self.mainView.frame.size.height+10, width: self.tableview.frame.size.width, height: self.view.frame.size.height-(self.mainView.frame.origin.y + self.mainView.frame.size.height + 60))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setBlogDetails() {
        self.teacherNameLabel.text = blogDetail.authorName
        if blogDetail.rating.isEmpty {
            self.starView.rating = Double("0")!
            self.starView.settings.fillMode = .precise
        } else {
            self.starView.rating = Double(blogDetail.rating)!
            self.starView.settings.fillMode = .precise
        }
        self.titleLabel.text = blogDetail.blogTitle
        self.categoryLabel.text = blogDetail.categoryName
        self.descriptionLabel.text = blogDetail.blogDescription
        self.profileImageview.image = UIImage(named: "profile_rectangle_img")
        if (blogDetail.profilePic != "") {
            let url = URL(string: blogDetail.profilePic)
            self.profileImageview.kf.setImage(with: url)
        }
        let attributes = [
            NSFontAttributeName : UIFont(name: "Raleway-Light", size: 14)!,
            NSForegroundColorAttributeName : UIColor.ExpertConnectURL,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
            ] as [String : Any]
        let attributedString = NSAttributedString(string: blogDetail.blogUrl, attributes: attributes)
        self.blogUrlButton.setAttributedTitle(attributedString,for: .normal)
        
        self.rateButton.titleLabel!.font =  UIFont(name: "Raleway-SemoBold", size: 18)
        self.rateButton.backgroundColor = UIColor(red: 236/255.0, green: 61/255.0, blue: 3/255.0, alpha: 1.0)
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        if self.userId == blogDetail.teacherId {
            self.rateButton.setTitle("DELETE THIS BLOG", for: UIControlState.normal)
        } else {
            self.rateButton.setTitle("RATE & WRITE A REVIEW", for: UIControlState.normal)
        }
        
        
        //User Rating and Reviews
        self.commentsArray = NSMutableArray.init(array: blogDetail.comments as! [Any])
        self.tableview.reloadData()
    }
    
    private func makeProfileImageCircular() {
        self.profileImageview.layer.cornerRadius = 15.0
        self.profileImageview.clipsToBounds = true
        self.profileImageview.layer.borderWidth = CGFloat(0.0)
        self.profileImageview.layer.borderColor = UIColor.ExpertConnectBlack.cgColor
    }
    
    private func configureTopView() {
        teacherNameHeight = (self.teacherNameLabel.text?.heightForView(text: self.teacherNameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: teacherNameWidth))!
        titleStaticHeight = (self.titleStaticLabel.text?.heightForView(text: self.titleStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: titleStaticWidth))!
        titleHeight = (self.titleLabel.text?.heightForView(text: (self.titleLabel.text)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: titleWidth))!
        categoryStaticHeight = (self.categoryStaticLabel.text?.heightForView(text: self.categoryStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:categoryStaticWidth))!
        categoryHeight = (self.categoryLabel.text?.heightForView(text: self.categoryLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: categoryWidth))!
        descriptionStaticHeight = (self.descriptionStaticLabel.text?.heightForView(text: self.descriptionStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:descriptionStaticWidth))!
        descriptionHeight = (self.descriptionLabel.text?.heightForView(text: self.descriptionLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: descriptionWidth))!
        detailContentStaticHeight = (self.urlStaticLabel.text?.heightForView(text: self.urlStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:detailContentStaticWidth))!
        detailContentHeight = (self.blogUrlButton.titleLabel?.text?.heightForView(text: (self.blogUrlButton.titleLabel?.text!)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: detailContentWidth))!
        
        self.teacherNameLabel.removeConstraints(self.teacherNameLabel.constraints)
        self.starView.removeConstraints(self.starView.constraints)
        self.titleStaticLabel.removeConstraints(self.titleStaticLabel.constraints)
        self.titleLabel.removeConstraints(self.titleLabel.constraints)
        self.categoryStaticLabel.removeConstraints(self.categoryStaticLabel.constraints)
        self.categoryLabel.removeConstraints(self.categoryLabel.constraints)
        self.descriptionStaticLabel.removeConstraints(self.categoryStaticLabel.constraints)
        self.descriptionLabel.removeConstraints(self.categoryLabel.constraints)
        self.urlStaticLabel.removeConstraints(self.urlStaticLabel.constraints)
        self.blogUrlButton.removeConstraints(self.blogUrlButton.constraints)
        
        self.setConstraints(actualView: self.teacherNameLabel, leadingView: self.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 40, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 10, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setConstraints(actualView: self.starView, leadingView: self.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 39, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 8, height: 20, width: 50, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        //        if teacherNameHeight > 20.0 {
        self.setConstraints(actualView: self.titleStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: titleStaticHeight, width: titleStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
        self.setConstraints(actualView: self.titleLabel, leadingView: self.titleStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: titleHeight, width: titleWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        //        } else {
        //            self.setConstraints(actualView: cell.titleStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 28, height: titleStaticHeight, width: titleStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        //
        //            self.setConstraints(actualView: cell.titleLabel, leadingView: cell.titleStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 28, height: titleHeight, width: titleWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        //        }
        
        if titleHeight > titleStaticHeight {
            self.setConstraints(actualView: self.categoryStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.titleLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: categoryStaticHeight, width: categoryStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: self.categoryStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.titleLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: categoryStaticHeight, width: categoryStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: self.categoryLabel, leadingView: self.categoryStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.titleLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: categoryHeight, width: categoryWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if categoryHeight > categoryStaticHeight {
            self.setConstraints(actualView: self.descriptionStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.categoryLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: descriptionStaticHeight, width: descriptionStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: self.descriptionStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.categoryLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: descriptionStaticHeight, width: descriptionStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: self.descriptionLabel, leadingView: self.descriptionStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.categoryLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: descriptionHeight, width: descriptionWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        if descriptionHeight > descriptionStaticHeight {
            self.setConstraints(actualView: self.urlStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.descriptionLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: detailContentStaticHeight, width: detailContentStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        else {
            self.setConstraints(actualView: self.urlStaticLabel, leadingView: self.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: self.descriptionLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: detailContentStaticHeight, width: detailContentStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        }
        
        self.setConstraints(actualView: self.blogUrlButton, leadingView: self.urlStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: self.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: self.descriptionLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: detailContentHeight, width: detailContentWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.blogUrlButton.layoutIfNeeded()
        let height = (10)+(teacherNameHeight)+(8)+(20)+(10)+(titleHeight)+(4)+(categoryHeight)+(descriptionHeight)+(4)+(detailContentHeight)+(10)
        self.mainView.frame = CGRect(x: self.mainView.frame.origin.x, y: self.mainView.frame.origin.y, width: self.mainView.frame.size.width, height: height)
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "ReviewCustomCell"
        var cell: ReviewCustomCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ReviewCustomCell
        if cell == nil {
            tableView.register(ReviewCustomCell.self, forCellReuseIdentifier: "ReviewCustomCell")
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ReviewCustomCell
        }
        let apiConverter = BlogViewApiModelConverter()
        let commentDetail = apiConverter.fromJson(json: self.commentsArray[indexPath.row] as! NSDictionary) as CommentsDomainModel
        cell.nameLabel.text = commentDetail.commentedBy
        cell.dateLabel.text = commentDetail.commentedOn
        cell.rateLabel.text = String(format: "%@ ★", commentDetail.indRating)
        cell.rateLabel.layer.cornerRadius = 3.0
        cell.rateLabel.clipsToBounds = true
        cell.reviewLabel.text = commentDetail.comment

        let ratingValue = Double(commentDetail.indRating)!
        switch Int(ratingValue) {
        case 1:
            cell.rateLabel.backgroundColor = UIColor.ExpertConnectRatingOrange
            break
        case 2:
            cell.rateLabel.backgroundColor = UIColor.ExpertConnectRatingYellow
            break
        case 3:
            cell.rateLabel.backgroundColor = UIColor.ExpertConnectRatingGreen
            break
        case 4:
            cell.rateLabel.backgroundColor = UIColor.ExpertConnectRatingGreen
            break
        case 5:
            cell.rateLabel.backgroundColor = UIColor.ExpertConnectRatingGreen
            break
        default:
            break
        }
        let ratingDetails : NSArray = self.commentsArray as NSArray
        var ratingArray = Array<Any>()
        for rating in ratingDetails {
            let str:NSDictionary = rating as! NSDictionary
            ratingArray.append(str.value(forKey: "commentorId") as! String)
            self.commentedByArray = ratingArray
        }
        
        reviewLabelHeight = (cell.reviewLabel.text?.heightForView(text: cell.reviewLabel.text!, font: UIFont(name: "Raleway-Light", size: 13)!, width: reviewLabelWidth))!
        
        cell.reviewLabel.removeConstraints(cell.reviewLabel.constraints)
        
        self.setConstraints(actualView: cell.reviewLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 10, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 32, height: reviewLabelHeight, width: reviewLabelWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        return cell
    }
    
    // MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (32)+(reviewLabelHeight)+(10)
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            if(self.commentsArray.count == 0) {return "No Reviews Yet."}
            else if(self.commentsArray.count == 1) {return "1 Review"}
            else {return String(format: "%d Reviews", self.commentsArray.count)}
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Raleway-Light", size: 18)!
        header.textLabel?.textColor = UIColor.ExpertConnectBlack
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
        let url = (sender.titleLabel?.text)!.trimmingCharacters(in: .whitespacesAndNewlines) as String!
        if url?.characters.count == 0 {
            return
        }
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
    
    // MARK: Rate And Review Button Click method
    @IBAction func rateAndReviewButtonClicked(_ sender: UIButton) {
        if !UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            //Go to login screen
            let loginView = LoginWireFrame.setupLoginModule() as UIViewController
            let navController = UINavigationController(rootViewController: loginView)
            self.present(navController, animated: true, completion: nil)
            loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        } else {
            
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            if(self.commentedByArray.contains(obj: self.userId)) {
                self.showErrorMessage(message: "You have already commented on this blog.")
                return
            }
            
            if self.userId == blogDetail.teacherId {
                alertView.containerView = createContainerView(acceptOrRejectSuccessMessage: "Do You Really Want To Delete This Blog?")
                alertView.catchString(withString: "AlertUpgradeTeacher")
                alertView.buttonTitles = ["DELETE"]
                alertActionType = "DeleteBlog"
                alertView.delegate = self
                alertView.show()
            } else {
                alertActionType = "RateAndReview"
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
    }
    
    // MARK: Custom Alert Delegates
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        //  print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        if alertActionType == "RateAndReview" {
            if (self.ratingView.rating == 0) {
                let message = "Please add your rating"
                alertView.close()
                self.displayErrorMessageWithCallback(message: message)
                return
            }
            if (self.messageTextView.text == nil || (self.messageTextView.text?.characters.count)! == 0) {
                let message = "Please write your review"
                alertView.close()
                self.displayErrorMessageWithCallback(message: message)
                return
            }
            
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let rating = String(format: "%.1f", self.ratingView.rating)
            let review = self.messageTextView.text!
            self.command = "rateAndCommentBlog"
            
            if (!self.isInternetAvailable()) {
                let message = "No Internet Connection".localized(in: "ManageExpertise")
                self.displayErrorMessage(message: message)
                return
            }

            let message = "Posting Review".localized(in: "BlogDetailView")
            self.displayProgress(message: message)
            let blogRatingInputDomainModel = BlogRatingInputDomainModel.init(userId: self.userId, blogId: blogDetail.blogId, rating: rating, review: review.trimmingCharacters(in: .whitespacesAndNewlines), command : self.command)
            let APIDataManager : BlogDetailViewProtocol = BlogDetailViewApiDataManager()
            APIDataManager.addReview(data: blogRatingInputDomainModel, callback:{(result) in
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
            
            //presenter?.notifyForgotPasswordButtonTapped()
            print("send email code")
            alertView.close()
            
        } else if alertActionType == "DeleteBlog" {
                self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
                self.command = "deleteBlogByBlogId"
                
                let message = "Deleting Blog".localized(in: "BlogDetailView")
                self.displayProgress(message: message)
                let blogRatingInputDomainModel = BlogRatingInputDomainModel.init(userId: self.userId, blogId: blogDetail.blogId, rating: "", review: "", command : self.command)
                let APIDataManager : BlogDetailViewProtocol = BlogDetailViewApiDataManager()
                APIDataManager.addReview(data: blogRatingInputDomainModel, callback:{(result) in
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
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
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

    func createContainerViewForForgotPassword() -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 280))
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 240, height: 30))
        label.text = "Rate and write a review"
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
        
        self.ratingView = CosmosView(frame: CGRect(x: 20, y: 55, width: 80, height: 40))
        self.ratingView.rating = 0
        self.ratingView.settings.fillMode = .precise
        self.ratingView.settings.emptyBorderColor = UIColor.init(colorLiteralRed: 137/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1.0)
        self.ratingView.settings.emptyColor = UIColor.init(colorLiteralRed: 137/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1.0)
        self.ratingView.settings.filledBorderColor = UIColor.init(colorLiteralRed: 255/255.0, green: 152/255.0, blue: 0, alpha: 1.0)
        self.ratingView.settings.filledColor = UIColor.init(colorLiteralRed: 255/255.0, green: 152/255.0, blue: 0, alpha: 1.0)
        View.addSubview(self.ratingView)
        
        messageTextView = UITextView(frame: CGRect(x: 20, y: 82, width: 250.00, height: 170.00))
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
    
    // MARK: Verify OTP Methods
    func onAddReviewSucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            
            if alertActionType == "DeleteBlog" {
                self.delegate.deleteBlogSucceded!(showAlert: true, message: data.message)
                _ = self.navigationController?.popViewController(animated: true)
                
            } else if alertActionType == "RateAndReview" {
                self.displaySuccessMessage(message: data.message)
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)

            }
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onAddReviewFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Blog Comment Post Failed")
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
}
