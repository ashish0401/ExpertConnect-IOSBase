//
//  HomeVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 09/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController, VKSideMenuDelegate, VKSideMenuDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UpdateProfileDelegate, AddCategoryDelegate, AddExpertiseProtocol {
    
    var menuLeft = VKSideMenu()
    var menuTop = VKSideMenu()
    var COLLECTION_CELL_EDGE_INTET = CGFloat()
    var rightNotificationBarButton: ENMBadgedBarButtonItem?
    var rightPromotionBarButton: ENMBadgedBarButtonItem?
    var count = 0
    var userId = String()
    private var mySearchBar: UISearchBar!
    var model = LoginOutputDomainModel()
    var categoryArray: NSArray = [NSDictionary]() as NSArray
    var subCategoryArray: NSArray = [NSDictionary]() as NSArray
    var filteredArray = NSMutableArray()
    var filteredCategoryArray: NSArray = [NSDictionary]() as NSArray
    var filteredSubCategoryArray: NSArray = [NSDictionary]() as NSArray
    var searchActive = false
    var noDataLabel = UILabel()
    var userType: String = ""
    let alertView = CustomIOS7AlertView()
    var isShowAlert: Bool = false
    var alertMessage: String = ""
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet var _collectionFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setUpCollectionView()
        self.activateHamburgerIcon(delegate: self)
        mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.frame = CGRect(x:0,y:0,width:300,height:65)
        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 100)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUserAuthenticationStatusChanged), name: NSNotification.Name(rawValue: "com.ExpertConnect.loggedIn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUserSignupStatusChanged), name: NSNotification.Name(rawValue: "com.ExpertConnect.Signup"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(isShowAlert) {
            let message = self.alertMessage
            self.showStylishSuccessMessage(message: message)
            self.isShowAlert = false
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = false

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Expert Connect"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        setUpNotificationBarButton()

        self.menuLeft = VKSideMenu(size: (self.view.frame.size.width-(self.view.frame.size.width*20)/100), andDirection: VKSideMenuDirection.fromLeft)
        self.menuLeft.dataSource = self;
        self.menuLeft.delegate   = self;
        self.menuLeft.addSwipeGestureRecognition(self.view)
        
        COLLECTION_CELL_EDGE_INTET = 0.0;
        
        self.collectionview.delegate = self;
        self.collectionview.dataSource = self;
        self.noDataLabel = self.showStickyErrorMessage(message: "No Results".localized(in: "Login"))

        let isAccountDeleted = UserDefaults.standard.value(forKey: "isAccountDeleted")
        if(isAccountDeleted == nil) {
            UserDefaults.standard.set(false, forKey: "isAccountDeleted")
        }
        if(UserDefaults.standard.bool(forKey: "isAccountDeleted")) {
            let loginView = LoginWireFrame.setupLoginModule() as UIViewController
            let navController = UINavigationController(rootViewController: loginView)
            self.present(navController, animated: true, completion: nil)
            loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        }

        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        
        let message = "Loading Categories".localized(in: "Login")
        self.displayProgress(message: message)
        
        let APIDataManager: HomeProtocols = HomeAPIDataManager()
        APIDataManager.getCategoryDetails(callback: { (result) in
            switch result {
            case .Failure(let error):
                self.onUserLoginFailed(error: error)
            case .Success(let data as HomeOutputDomainModel):
                do {
                    self.onUserLoginSucceeded(data: data)
                } catch {
                    self.onUserLoginFailed(error: EApiErrorType.InternalError)
                }
            default:
                break
            }
        })
        
        if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let notificationsDomainModel = NotificationsDomainModel.init(userId: self.userId)
            let notificationAPIDataManager : NotificationCountProtocols = NotificationsAPIDataManager()
            notificationAPIDataManager.getNotificationCount(model: notificationsDomainModel, callback:{(result) in
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUpdateNotificationBadge), name: NSNotification.Name(rawValue: "com.ExpertConnect.UpdateBadge"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUpdateNotificationBadgeFromBackground), name: NSNotification.Name(rawValue: "com.ExpertConnect.UpdateBadgeFromBackground"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.setExpertConnectHomeSeacrhBarTheme(searchBar: self.searchBar)
        self.setExpertConnectHomeSeacrhBarTheme(searchBar: self.mySearchBar)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        searchBar.text = ""
        searchActive = false
        noDataLabel.isHidden = true
        searchBar.setShowsCancelButton(false, animated: true)
        self.collectionview.reloadData()
        self.setExpertConnectHomeSeacrhBarTheme(searchBar: self.searchBar)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "com.ExpertConnect.UpdateBadgeFromBackground"), object: nil)
    }
    
    func setUpNotificationBarButton() {
        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpace.width = -3.0
        let fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 17.0
        let image = UIImage(named: "notification_btn")
        let button = UIButton(type: .custom)
        if let knownImage = image {
            button.frame = CGRect(x: 0.0, y: 0.0, width: 23, height: 25)
        } else {
            button.frame = CGRect.zero;
        }
        button.setBackgroundImage(image, for: UIControlState())
        button.addTarget(self,
                         action: #selector(self.notificationButtonPressed(_:)),
                         for: UIControlEvents.touchUpInside)
        let newBarButton = ENMBadgedBarButtonItem(customView: button, value: "0")
        rightNotificationBarButton = newBarButton
        
        let image1 = UIImage(named: "promotion_btn")
        let button1 = UIButton(type: .custom)
        if let knownImage1 = image1 {
            button1.frame = CGRect(x: 0.0, y: 0.0, width: 32, height: 25)
        } else {
            button1.frame = CGRect.zero;
        }
        
        button1.setBackgroundImage(image1, for: UIControlState())
        button1.addTarget(self,
                          action: #selector(self.promotionButtonPressed(_:)),
                          for: UIControlEvents.touchUpInside)
        let newBarButton1 = ENMBadgedBarButtonItem(customView: button1, value: "0")
        rightPromotionBarButton = newBarButton1
        if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            self.navigationItem.rightBarButtonItems = [negativeSpace, rightNotificationBarButton!, fixedSpace, rightPromotionBarButton!]
        } else {
            self.navigationItem.rightBarButtonItems = [negativeSpace, rightPromotionBarButton!]
        }
    }
    
    func setUpDummyBarButton() {
        let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpace.width = -7.0
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(negativeSpace)
            self.navigationItem.rightBarButtonItems = items
        } else {
            self.navigationItem.rightBarButtonItem = negativeSpace
        }
    }
    
    func setUpFixedSpaceBarButton() {
        let fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 26.0
        
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(fixedSpace)
            self.navigationItem.rightBarButtonItems = items
        } else {
            self.navigationItem.rightBarButtonItem = fixedSpace
        }
    }
    
    func setUpPromotionBarButton() {
        let image = UIImage(named: "promotion_btn")
        let button = UIButton(type: .custom)
        if let knownImage = image {
            button.frame = CGRect(x: 20.0, y: 0.0, width: 30, height: 23)
        } else {
            button.frame = CGRect.zero;
        }
        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        
        button.setBackgroundImage(image, for: UIControlState())
        button.addTarget(self,
                         action: #selector(self.promotionButtonPressed(_:)),
                         for: UIControlEvents.touchUpInside)
        let newBarButton = ENMBadgedBarButtonItem(customView: button, value: "0")
        rightPromotionBarButton = newBarButton
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(rightPromotionBarButton!)
            self.navigationItem.rightBarButtonItems = items
        } else {
            self.navigationItem.rightBarButtonItem = rightPromotionBarButton
        }
    }
    
    func notificationButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        rightNotificationBarButton?.badgeValue = "0"
        let notificationsView : NotificationsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsView") as UIViewController as! NotificationsView
        self.navigationController?.pushViewController(notificationsView, animated: true)
    }
    
    func promotionButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        rightPromotionBarButton?.badgeValue = "0"
        let promotionView : PromotionView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PromotionView") as UIViewController as! PromotionView
        self.navigationController?.pushViewController(promotionView, animated: true)
    }
    
    func sideMenuButtonClicked(button: UIButton) {
        self.view.endEditing(true)
        self.menuLeft.show()
    }
    
    func notificationButtonClicked(button: UIButton) {
        self.view.endEditing(true)
    }
    
    func promotionButtonClicked(button: UIButton) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UiCollectionView DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return self.filteredArray.count
        }
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var categoryDict = [String: AnyObject]()
        if searchActive {
            categoryDict = (self.filteredArray[indexPath.row] as? [String:AnyObject])!
        } else {
            categoryDict = (self.categoryArray[indexPath.row] as? [String:AnyObject])!
        }
        var categoryName = categoryDict["category_name"]
        var categoryImageUrl = categoryDict["category_icon"]
        if categoryDict["sub_category_name"] != nil {
            categoryName = categoryDict["sub_category_name"]
            categoryImageUrl = "" as AnyObject
        }
        var cellidentifier = String()
        cellidentifier = "HomeViewCell"
        collectionView.register(UINib.init(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: cellidentifier)
        var cell = HomeViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as! HomeViewCell
        cell.categoryNameLabel.text = categoryName as? String
        cell.iconView.image = UIImage(named: "subcategory_dummy_image")
        if (categoryImageUrl as! String != "") {
            let url = URL(string: categoryImageUrl! as! String)
            cell.iconView.kf.setImage(with: url)
        }
        cell.categoryNameLabel.textColor = UIColor.ExpertConnectTabbarIconColor
        cell.baseView.layer.shadowColor = UIColor.black.cgColor
        cell.baseView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cell.baseView.layer.shadowOpacity = 0.4
        cell.baseView.layer.shadowRadius = 0.3
        cell.baseView.layer.cornerRadius = 3
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let subCategoryVC : SubCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryVC") as UIViewController as! SubCategoryVC
        var categoryDict = [String: AnyObject]()
        if searchActive {
            categoryDict = (self.filteredArray[indexPath.row] as? [String:AnyObject])!
        } else {
            categoryDict = (self.categoryArray[indexPath.row] as? [String:AnyObject])!
        }
        subCategoryVC.categoryDictionary = categoryDict as [String : AnyObject]
        searchBar.text = ""
        searchActive = false
        noDataLabel.isHidden = true
        self.collectionview.reloadData()
        self.navigationController?.pushViewController(subCategoryVC, animated: true)
    }
    
    func setUpCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 2, left: 12, bottom: 12, right: 12)
        var countItems = CGFloat()
        countItems = 2
        var countItemSpasing = CGFloat()
        countItemSpasing = 12 * 3
        width = (self.view.frame.size.width - countItemSpasing)/countItems
        var height = CGFloat()
        height = width * (7/9.5)
        let size = CGSize(width: width + 2, height: height - 15)
        layout.itemSize = size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        self.collectionview.collectionViewLayout = layout
    }
    
    // MARK: - VKSideMenuDataSource
    func numberOfSections(in sideMenu: VKSideMenu!) -> Int {
        return 1
    }
    
    func sideMenu(_ sideMenu: VKSideMenu!, numberOfRowsInSection section: Int) -> Int {
        if (sideMenu == self.menuLeft || sideMenu == self.menuTop){
            if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
                self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
                if(self.userType == "2") {
                    return 6
                } else {
                    return 10
                }
            } else {
                return 2
            }
        }
        return section == 0 ? 1 : 2
    }
    
    func sideMenu(_ sideMenu: VKSideMenu!, itemForRowAt indexPath: IndexPath!) -> VKSideMenuItem! {
        let item = VKSideMenuItem()
        
        if (sideMenu == self.menuLeft || sideMenu == self.menuTop) // All LEFT and TOP menu items
        {
            if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
                self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
                if(self.userType == "2") {
                    switch (indexPath.row)
                    {
                    case 0:
                        item.title = "Teacher Name";
                        //                item.icon = UIImage.animatedImageNamed("boy_red_cap", duration: 0)
                        item.icon = UIImage(named: "default_profile_pic")
                        
                        if let userFullName = UserDefaults.standard.value(forKey: "UserFullName") as? String {
                            item.title = userFullName;
                        }
                        
                        if let userProfileData = UserDefaults.standard.value(forKey: "UserProfileData") as? Data {
                            item.icon = UIImage(data: userProfileData as Data)
                        }
                        break;
                        
                    case 1:
                        item.title = "Notification";
                        item.icon = UIImage(named: "notification_icon")
                        break;
                        
//                    case 2:
//                        item.title = "My Categories";
//                        item.icon = UIImage(named: "my_category_icon")
//                        break;
                        
//                    case 2:
//                        item.title = "Refer Friend";
//                        item.icon = UIImage(named: "refer_friend_icon")
//                        break;
//
//                    case 4:
//                        item.title = "Add Category";
//                        item.icon = UIImage(named: "add_category_icon")
//                        break;
//                        
//                    case 5:
//                        item.title = "Manage Expertise";
//                        item.icon = UIImage(named: "manage_expertise_icon")
//                        break;
                        
//                    case 6:
//                        item.title = "My Account";
//                        item.icon = UIImage(named: "my_account_icon")
//                        break;
                        
                    case 2:
                        item.title = "Upgrade To Teacher";
                        item.icon = UIImage(named: "upgrade_teacher_icon")
                        break;
                        
                    case 3:
                        item.title = "Settings";
                        item.icon = UIImage(named: "settings_icon")
                        break;
                        
                    case 4:
                        item.title = "Refer Friend";
                        item.icon = UIImage(named: "refer_friend_icon")
                        break;

                    case 5:
                        item.title = "Logout";
                        item.icon = UIImage(named: "logout_icon")
                        break;
                        
                    default:
                        break;
                    }
                } else {
                    switch (indexPath.row)
                    {
                    case 0:
                        item.title = "Teacher Name";
                        item.icon = UIImage(named: "default_profile_pic")
                        
                        if let userFullName = UserDefaults.standard.value(forKey: "UserFullName") as? String {
                            item.title = userFullName;
                        }
                        
                        if let userProfileData = UserDefaults.standard.value(forKey: "UserProfileData") as? Data {
                            item.icon = UIImage(data: userProfileData as Data)
                        }
                        break;
                        
                    case 1:
                        item.title = "Notification";
                        item.icon = UIImage(named: "notification_icon")
                        break;
                        
                    case 2:
                        item.title = "General Enquiries";
                        item.icon = UIImage(named: "sidemenu_general_enquiry_icon")
                        break;
                        
                    case 3:
                        item.title = "My Blogs";
                        item.icon = UIImage(named: "sidemenu_myblog_icon")
                        break;
                        
                    case 4:
                        item.title = "My Categories";
                        item.icon = UIImage(named: "my_category_icon")
                        break;

//                        
//                    case 5:
//                        item.title = "Refer Friend";
//                        item.icon = UIImage(named: "refer_friend_icon")
//                        break;
                        
                    case 5:
                        item.title = "Add Category";
                        item.icon = UIImage(named: "add_category_icon")
                        break;
                        
                    case 6:
                        item.title = "Manage Expertise";
                        item.icon = UIImage(named: "manage_expertise_icon")
                        break;
                        
//                    case 6:
//                        item.title = "My Account";
//                        item.icon = UIImage(named: "my_account_icon")
//                        break;
                        
                    case 7:
                        item.title = "Settings";
                        item.icon = UIImage(named: "settings_icon")
                        break;
                        
                    case 8:
                        item.title = "Refer Friend";
                        item.icon = UIImage(named: "refer_friend_icon")
                        break;

                    case 9:
                        item.title = "Logout";
                        item.icon = UIImage(named: "logout_icon")
                        break;
                        
                    default:
                        break;
                    }
                }
            } else {
                switch (indexPath.row)
                {
                case 1:
                    item.title = "Sign Up / Sign In";
                    item.icon = UIImage(named: "sidemenu_login_icon")
                    break;
                default:
                    break;
                }
            }
        }
        return item
    }
    
    // MARK: - VKSideMenuDelegate
    func sideMenu(_ sideMenu: VKSideMenu!, didSelectRowAt indexPath: IndexPath!) {
        if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
            if(self.userType == "2") {
                switch indexPath.row {
                case 0:
                    let updateProfileView : UpdateProfileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileView") as UIViewController as! UpdateProfileView
                    updateProfileView.delegate = self
                    self.navigationController?.pushViewController(updateProfileView, animated: true)
                    break;
                    
                case 1:
                    let notificationsView : NotificationsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsView") as UIViewController as! NotificationsView
                    self.navigationController?.pushViewController(notificationsView, animated: true)
                    break;
//                    
//                case 2:
//                    let myCategoryView : MyCategoryView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCategoryView") as UIViewController as! MyCategoryView
//                    self.navigationController?.pushViewController(myCategoryView, animated: true)
//                    break;
                    
//                case 2:
//                    break;
                    
//                case 4:
//                    self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
//                    if(self.userType == "2") {
//                        alertView.containerView = createContainerView(acceptOrRejectSuccessMessage: "Please Upgrade to Teacher to Avail these Services")
//                        alertView.catchString(withString: "AlertForRequest/Accept/Reject")
//                        alertView.show()
//                        return
//                    }
//                    
//                    let addCategoryView : AddCategoryView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCategoryView") as UIViewController as! AddCategoryView
//                    addCategoryView.delegate = self
//                    self.navigationController?.pushViewController(addCategoryView, animated: true)
//                    
//                    break;
//                    
//                case 5:
//                    self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
//                    if(self.userType == "2") {
//                        alertView.containerView = createContainerView(acceptOrRejectSuccessMessage: "Please Upgrade to Teacher to Avail these Services")
//                        alertView.catchString(withString: "AlertForRequest/Accept/Reject")
//                        alertView.show()
//                        return
//                    }
//                    let manageExpertiseView : ManageExpertiseView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManageExpertiseView") as UIViewController as! ManageExpertiseView
//                    self.navigationController?.pushViewController(manageExpertiseView, animated: true)
//                    break;
//
//                case 6:
//                    break;
//                    
                case 2:
                    let addExpertiseView : ExpertDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpertDetailsVC") as UIViewController as! ExpertDetailsVC
                    addExpertiseView.isUpgradeToTeacher = true
                    addExpertiseView.delegate = self
                    self.navigationController?.pushViewController(addExpertiseView, animated: true)
                    break;
                    
                case 3:
                    let settingsView : SettingsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsView") as UIViewController as! SettingsView
                    self.navigationController?.pushViewController(settingsView, animated: true)
                    break;
                    
                case 4:
//                    let settingsView : SettingsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsView") as UIViewController as! SettingsView
//                    self.navigationController?.pushViewController(settingsView, animated: true)
                    break;
                    
                case 5:
                    self.view.endEditing(true)
                    self.askForLogoutIfUserIsSure()
                    break;
                    
                default:
                    break;
                }
            } else {
                switch indexPath.row {
                case 0:
                    let updateProfileView : UpdateProfileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileView") as UIViewController as! UpdateProfileView
                    updateProfileView.delegate = self
                    self.navigationController?.pushViewController(updateProfileView, animated: true)
                    break;
                    
                case 1:
                    let notificationsView : NotificationsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsView") as UIViewController as! NotificationsView
                    self.navigationController?.pushViewController(notificationsView, animated: true)
                    break;
                    
                case 2:
                    let generalEnquiryView : MessagesView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessagesView") as UIViewController as! MessagesView
                    generalEnquiryView.isFromGeneralEnquiry = true
                    self.navigationController?.pushViewController(generalEnquiryView, animated: true)
                    break;

                case 3:
                    let myBlogView : BlogView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlogView") as UIViewController as! BlogView
                    myBlogView.isFromMyBlogs = true
                    self.navigationController?.pushViewController(myBlogView, animated: true)
                    break;
                    
                case 4:
                    let myCategoryView : MyCategoryView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCategoryView") as UIViewController as! MyCategoryView
                    self.navigationController?.pushViewController(myCategoryView, animated: true)
                    break;
                    
//                case 5:
//                    break;
                    
                case 5:
                    let addCategoryView : AddCategoryView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCategoryView") as UIViewController as! AddCategoryView
                    addCategoryView.delegate = self
                    self.navigationController?.pushViewController(addCategoryView, animated: true)
                    
                    break;
                    
                case 6:
                    self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
                    if(self.userType == "2") {
                        alertView.containerView = createContainerView(acceptOrRejectSuccessMessage: "Please Upgrade to Teacher to Avail these Services")
                        alertView.catchString(withString: "AlertForRequest/Accept/Reject")
                        alertView.show()
                        return
                    }
                    let manageExpertiseView : ManageExpertiseView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManageExpertiseView") as UIViewController as! ManageExpertiseView
                    self.navigationController?.pushViewController(manageExpertiseView, animated: true)
                    break;
                    
//                case 6:
//                    break;
//                    
                case 7:
                    let settingsView : SettingsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsView") as UIViewController as! SettingsView
                    self.navigationController?.pushViewController(settingsView, animated: true)
                    break;
                    
                case 8:
                    break;
                    
                case 9:
                    self.view.endEditing(true)
                    self.askForLogoutIfUserIsSure()
                    break;
                    
                default:
                    break;
                }
            }
        } else {
            switch (indexPath.row)
            {
            case 1:
                let loginView = LoginWireFrame.setupLoginModule() as UIViewController
                let navController = UINavigationController(rootViewController: loginView)
                self.present(navController, animated: true, completion: nil)
                loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
                break;
            default:
                break;
            }
        }
    }
    
    func askForLogoutIfUserIsSure() {
        let message = "Are you sure?".localized(in: "Menu")
        let cancel = "Cancel".localized(in: "Cancel")
        let logout = "Log out".localized(in: "Log out")
        let logoutAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        logoutAlert.addAction(UIAlertAction(title: cancel, style: .default, handler: nil))
        logoutAlert.addAction(UIAlertAction(title: logout, style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.set(false, forKey: "UserLoggedInStatus")
            let loginView = LoginWireFrame.setupLoginModule() as UIViewController
            let navController = UINavigationController(rootViewController: loginView)
            self.present(navController, animated: true, completion: nil)
            loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        }))
        self.present(logoutAlert, animated: true, completion: nil)
    }
     
    func showLoginController() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "teacherStudentValue")
        let loginVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        let navigationController = UINavigationController(rootViewController: loginVC)
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func sideMenuDidShow(_ sideMenu: VKSideMenu!) {
        var menu = String()
        if sideMenu == self.menuLeft {
            menu = "LEFT"
            print("%@ VKSideMenue did show", menu)
        }
    }
    
    func sideMenuDidHide(_ sideMenu: VKSideMenu!) {
        var menu = String()
        if sideMenu == self.menuLeft {
            menu = "LEFT"
            print("%@ VKSideMenue did hide", menu)
        }
    }
    
    func sideMenu(_ sideMenu: VKSideMenu!, titleForHeaderInSection section: Int) -> String! {
        if sideMenu == self.menuLeft{
            return nil;
        }
        switch (section)
        {
        case 0:
            return "Profile";
            
        case 1:
            return "Actions";
            
        default:
            return nil;
        }
    }
    
    func onUserLoginSucceeded(data: HomeOutputDomainModel) {
        self.categoryArray = data.categories
        self.subCategoryArray = data.subCategories
        let mainCategory = data.categories as NSArray
        UserDefaults.standard.set(mainCategory, forKey: "MainCategory")
        collectionview.reloadData()
        self.dismissProgress()
    }
    
    func onUserLoginFailed(error: EApiErrorType) {
        print("Ooops, there is a problem with your creditantials")
        self.dismissProgress()
        let message = "No categories found in the database".localized(in: "Login")
        self.displayErrorMessage(message: message)
    }
    
    func displayErrorMessage(message: String) {
        self.showErrorMessage(message: message)
    }
    
    @objc func onUserAuthenticationStatusChanged(notification: Notification) {
        if let userInfo = notification.userInfo as NSDictionary? as? [String: Any] {
            let model = userInfo["LoginOutputDomainModel"] as! LoginOutputDomainModel
            UserDefaults.standard.setValue(String(format: "%@ %@", model.firstName, model.lastName), forKey: "UserFullName")
            
            if ((model.profilePic.characters.count) == 0) {
                UserDefaults.standard.removeObject(forKey: "UserProfileData")
            } else {
                let url = URL(string: model.profilePic)
                do {
                    let imageData = try NSData(contentsOf: url!, options: NSData.ReadingOptions())
                    UserDefaults.standard.setValue( imageData, forKey: "UserProfileData")
                } catch {
                    print(error)
                }
                print("Hey you logged in: \(model.firstName)")
            }
        }
    }
    
    @objc func onUserSignupStatusChanged(notification: Notification) {
        if let userInfo = notification.userInfo as NSDictionary? as? [String: Any] {
            let model = userInfo["CoachingDetailsOutputDomainModel"] as! CoachingDetailsOutputDomainModel
            UserDefaults.standard.setValue(String(format: "%@ %@", model.firstName, model.lastName), forKey: "UserFullName")
            let firstname = String(model.firstName)
            UserDefaults.standard.set(firstname, forKey: "firstname")
            let lastname = String(model.lastName)
            UserDefaults.standard.set(lastname, forKey: "lastname")
            let email = String(model.email)
            UserDefaults.standard.set(email, forKey: "email_id")
            let dob = String(model.dob)
            UserDefaults.standard.set(dob, forKey: "dob")
            let location = String(model.location)
            UserDefaults.standard.set(location, forKey: "Location")
            if ((model.profilePic.characters.count) == 0) {
                UserDefaults.standard.removeObject(forKey: "UserProfileData")
            } else {
                let url = URL(string: model.profilePic)
                do {
                    let imageData = try NSData(contentsOf: url!, options: NSData.ReadingOptions())
                    UserDefaults.standard.setValue( imageData, forKey: "UserProfileData")
                } catch {
                    print(error)
                }
                print("Hey you logged in: \(model.firstName)")
            }
        }
    }
    
    @objc func onUpdateNotificationBadge(notification: Notification) {
        if let badgeValue = rightNotificationBarButton?.badgeValue {
            rightNotificationBarButton?.badgeValue = String((Int(badgeValue) ?? 0) + 1)
        } else {
            rightNotificationBarButton?.badgeValue = "1"
        }
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
            rightNotificationBarButton?.badgeValue = "\(data.notificationHistoryCount)"
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
    
    // MARK: SearchBar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        self.setExpertConnectHomeSeacrhBarTheme(searchBar: self.searchBar)
        self.setExpertConnectHomeSeacrhBarTheme(searchBar: self.mySearchBar)
        
        for subview in searchBar.subviews {
            if (subview.isKind(of:UIView.self)) {
                for subviewOfSubview in subview.subviews {
                    if let cancelButton = subviewOfSubview as? UIButton {
                        let btn: UIButton = cancelButton
                        btn.setTitleColor(UIColor.ExpertConnectRed, for: .normal)
                    }
                }
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let namePredicate = NSPredicate(format: "(category_name BEGINSWITH[c] %@) OR (category_name CONTAINS[c] %@)",  String(searchText),String(format: " %@",searchText));
        self.filteredCategoryArray = self.categoryArray.filter { namePredicate.evaluate(with: $0) } as NSArray;
        
        let subcategoryPredicate = NSPredicate(format: "(sub_category_name BEGINSWITH[c] %@) OR (sub_category_name CONTAINS[c] %@)",  String(searchText),String(format: " %@",searchText));
        self.filteredSubCategoryArray = self.subCategoryArray.filter { subcategoryPredicate.evaluate(with: $0) } as NSArray;
        
        self.filteredArray.removeAllObjects()
        self.filteredArray.addObjects(from: self.filteredCategoryArray as! [Any])
        self.filteredArray.addObjects(from: self.filteredSubCategoryArray as! [Any])
        
        if !searchText.isEmpty {
            searchActive = true
            noDataLabel.isHidden = self.filteredArray.count == 0 ? false : true
        } else {
            searchActive = false
            noDataLabel.isHidden = true
        }
        self.collectionview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = ""
        searchActive = false
        noDataLabel.isHidden = true
        self.collectionview.reloadData()
        self.setExpertConnectHomeSeacrhBarTheme(searchBar: self.searchBar)
        self.setExpertConnectHomeSeacrhBarTheme(searchBar: self.mySearchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.setExpertConnectHomeSeacrhBarTheme(searchBar: self.searchBar)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.collectionview.reloadData()
        return true
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
    
    // MARK: Custom Alert view close button method
    func alertViewCloseButtonClicked(button: UIButton) {
        alertView.close()
    }
    
    // MARK: - Update Profile Detail Delegate
    func updateProfileSucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }
    
    // MARK: - Add Category Detail Delegate
    func addCategorySucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }
    
    // MARK: - Add Category Detail Delegate
    func upgradeSucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }
}


