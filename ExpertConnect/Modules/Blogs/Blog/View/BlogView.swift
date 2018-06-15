//
//  AddBlogView.swift
//  ExpertConnect
//
//  Created by Redbytes on 06/02/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class BlogView: UIViewController, UITableViewDelegate, UITableViewDataSource, AddBlogDelegate, CustomIOS7AlertViewDelegate, AddExpertiseProtocol, DeleteBlogDelegate {

    @IBOutlet var tableview: UITableView!
    var teacherNameHeight = CGFloat()
    var titleStaticHeight = CGFloat()
    var titleHeight = CGFloat()
    var categoryStaticHeight = CGFloat()
    var categoryHeight = CGFloat()
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)
    let teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+40+22))
    let titleStaticWidth : CGFloat = 31
    let titleWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+31+8+22))
    let categoryStaticWidth : CGFloat = 62
    let categoryWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+62+8+22))
    var userId: String = ""
    var location: String = ""
    var command: String = ""

    var isShowAlert: Bool = false
    var alertMessage: String = ""
    var blogListArray = NSMutableArray()
    var noDataLabel = UILabel()
    var cityName : String = ""
    let alertView = CustomIOS7AlertView()
    var alertActionType = String()

    var isFromMyBlogs: Bool = false

    override func viewDidLoad() {
        if(isFromMyBlogs) {
            self.activateBackIcon()
            self.navigationItem.title = "My Blogs"
            let message = "MyBlogsUnavailable".localized(in: "BlogView")
            self.noDataLabel = self.showStickyErrorMessage(message: message)
        } else {
            self.activateAddBlogIcon(delegate:self)
            self.navigationItem.title = "Blogs"
            let message = "BlogsUnavailable".localized(in: "BlogView")
            self.noDataLabel = self.showStickyErrorMessage(message: message)
        }
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.makeTableSeperatorColorClear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(isFromMyBlogs) {
            appDelegate.objTabbarMain.tabBar.isHidden = true
        } else {
            appDelegate.objTabbarMain.tabBar.isHidden = false
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.cityName = appDelegate.cityName
        
        if(isShowAlert) {
            let message = self.alertMessage
            self.displaySuccessMessage(message: message)
            self.isShowAlert = false
        }
        
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ManageExpertise")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Loading Blog Details".localized(in: "BlogView")
        self.displayProgress(message: message)
        if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            self.location = UserDefaults.standard.value(forKey: "Location") as! String
        } else {
            self.userId = "0"
            self.location = self.cityName
        }
        
        if(isFromMyBlogs) {
            self.command = "getBlogById"
        } else {
            self.command = "getBlogList"
        }
        
        let blogViewInputDomainModel = BlogViewInputDomainModel.init(userId: self.userId, blogCity:self.location, command: self.command)
        let APIDataManager : BlogViewProtocol = BlogViewApiDataManager()
        APIDataManager.getBlogList(data: blogViewInputDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onGetBlogListFailed(error: error)
            case .Success(let data as [BlogViewOutputDomainModel]):
                do {
                    self.onGetBlogListSucceeded(data: data)
                } catch {
//                    self.onGetBlogListFailed(data: data)
                }
            default:
                break
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //isFromMyBlogs = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    // MARK: Add Blog Button Click
    func addBlogButtonClicked() {
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
            
            let addBlogView : AddBlogView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddBlogView") as UIViewController as! AddBlogView
            addBlogView.delegate = self
            let navController = UINavigationController(rootViewController: addBlogView)
            self.present(navController, animated: true, completion: nil)
            addBlogView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        }
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "BlogViewCustomCell"
        var cell: BlogViewCustomCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BlogViewCustomCell
        if cell == nil {
            tableView.register(BlogViewCustomCell.self, forCellReuseIdentifier: "BlogViewCustomCell")
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BlogViewCustomCell
        }
        
        let blogDetail = self.blogListArray[indexPath.row] as! BlogViewOutputDomainModel
        cell.teacherNameLabel.text = blogDetail.authorName
        if blogDetail.rating.isEmpty {
            cell.starView.rating = Double("0")!
            cell.starView.settings.fillMode = .precise
        } else {
            cell.starView.rating = Double(blogDetail.rating)!
            cell.starView.settings.fillMode = .precise
        }
        cell.titleLabel.text = blogDetail.blogTitle
        cell.categoryLabel.text = blogDetail.categoryName
        cell.profileImageview.image = UIImage(named: "profile_rectangle_img")
        if (blogDetail.profilePic != "") {
            let url = URL(string: blogDetail.profilePic)
            cell.profileImageview.kf.setImage(with: url)
        }

        teacherNameHeight = (cell.teacherNameLabel.text?.heightForView(text: cell.teacherNameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: teacherNameWidth))!
        titleStaticHeight = (cell.titleStaticLabel.text?.heightForView(text: cell.titleStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: titleStaticWidth))!
        titleHeight = (cell.titleLabel.text?.heightForView(text: (cell.titleLabel.text)!, font: UIFont(name: "Raleway-Light", size: 14)!, width: titleWidth))!
        categoryStaticHeight = (cell.categoryStaticLabel.text?.heightForView(text: cell.categoryStaticLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width:categoryStaticWidth))!
        categoryHeight = (cell.categoryLabel.text?.heightForView(text: cell.categoryLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: categoryWidth))!
        
        cell.teacherNameLabel.removeConstraints(cell.teacherNameLabel.constraints)
        cell.starView.removeConstraints(cell.starView.constraints)
        cell.titleStaticLabel.removeConstraints(cell.titleStaticLabel.constraints)
        cell.titleLabel.removeConstraints(cell.titleLabel.constraints)
        cell.categoryStaticLabel.removeConstraints(cell.categoryStaticLabel.constraints)
        cell.categoryLabel.removeConstraints(cell.categoryLabel.constraints)
        
        self.setConstraints(actualView: cell.teacherNameLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 40, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 10, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        
        self.setConstraints(actualView: cell.starView, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 39, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 8, height: 20, width: 50, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
        
//        if teacherNameHeight > 20.0 {
            self.setConstraints(actualView: cell.titleStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: titleStaticHeight, width: titleStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: cell.titleLabel, leadingView: cell.titleStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 10, height: titleHeight, width: titleWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
//        } else {
//            self.setConstraints(actualView: cell.titleStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 28, height: titleStaticHeight, width: titleStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
//            
//            self.setConstraints(actualView: cell.titleLabel, leadingView: cell.titleStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.starView, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 28, height: titleHeight, width: titleWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
//        }
        
        if titleHeight > titleStaticHeight {
            self.setConstraints(actualView: cell.categoryStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.titleLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: categoryStaticHeight, width: categoryStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: cell.categoryLabel, leadingView: cell.categoryStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.titleLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: categoryHeight, width: categoryWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        }
        else {
            self.setConstraints(actualView: cell.categoryStaticLabel, leadingView: cell.mainView, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.leading, leadingViewConstant: 10, trailingView: blankView, trailingAttributeForActualView: blankAttribute!, trailingAttributeForTrailingView: blankAttribute!, trailingViewConstant: 0, upperView: cell.titleStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: categoryStaticHeight, width: categoryStaticWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: false)
            
            self.setConstraints(actualView: cell.categoryLabel, leadingView: cell.categoryStaticLabel, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 8, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.titleStaticLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: categoryHeight, width: categoryWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
        }
        
        
        self.setECTableViewCellShadowTheme(view: cell.mainView)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //teacherNameHeight = teacherNameHeight > 20.0 ? teacherNameHeight+8 : teacherNameHeight+28
        let height = (22)+(teacherNameHeight)+(8)+(20)+(10)+(titleHeight)+(4)+(categoryHeight)+(22)
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
            let blogDetailView : BlogDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlogDetailView") as UIViewController as! BlogDetailView
            blogDetailView.delegate = self
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
    
    // MARK: - Add Blog Delegate
    func addBlogSucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }

    // MARK: - Delete Blog Delegate
    func deleteBlogSucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }

    // MARK: - Add Category Detail Delegate
    func upgradeSucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }

    // MARK: MyAssignment API Response methods
    func onGetBlogListSucceeded(data: [BlogViewOutputDomainModel]) {
        self.dismissProgress()
        self.blogListArray = NSMutableArray.init(array: data as [Any])
        print("blogList Array : ", self.blogListArray)
        self.tableview.reloadData()
        noDataLabel.isHidden = self.blogListArray.count == 0 ? false : true
    }
    
    func onGetBlogListFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.tableview.reloadData()
//        self.displayErrorMessage(message: "No blog list found in the database")
        noDataLabel.isHidden = self.blogListArray.count == 0 ? false : true
    }
    
//    func onGetBlogListFailed(data: ManageExpertiseOutputDomainModel) {
//        self.dismissProgress()
//        self.myExpertiseFilteredArray.removeAllObjects()
//        self.tableview.reloadData()
//        self.displayErrorMessage(message: data.message)
//    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage(message: message)
    }

    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
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
    // MARK: Custom Alert Delegates
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        //  print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        alertView.close()
        if alertActionType == "UpgradeToTeacher" {
            let addExpertiseView : ExpertDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpertDetailsVC") as UIViewController as! ExpertDetailsVC
            addExpertiseView.isUpgradeToTeacherFromBlogView = true
            addExpertiseView.delegate = self
            //self.navigationController?.pushViewController(addExpertiseView, animated: true)
            
            let navController = UINavigationController(rootViewController: addExpertiseView)
            self.present(navController, animated: true, completion: nil)
            addExpertiseView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        }
    }
    
    // MARK: Custom Alert view close button method
    func alertViewCloseButtonClicked(button: UIButton) {
        alertView.close()
    }
}
