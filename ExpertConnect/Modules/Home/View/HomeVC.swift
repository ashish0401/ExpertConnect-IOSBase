//
//  HomeVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 09/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController, VKSideMenuDelegate, VKSideMenuDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var menuLeft = VKSideMenu()
    var menuTop = VKSideMenu()
    var COLLECTION_CELL_EDGE_INTET = CGFloat()
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet var _collectionFlowLayout: UICollectionViewFlowLayout!
    var model = LoginOutputDomainModel()
    var categoryArray: NSArray = [NSDictionary]() as NSArray
    var subCategoryArray: NSArray = [NSDictionary]() as NSArray
    var filteredArray = NSMutableArray()
    var filteredCategoryArray: NSArray = [NSDictionary]() as NSArray
    var filteredSubCategoryArray: NSArray = [NSDictionary]() as NSArray
    var searchActive = false
    let noDataLabel = UILabel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.activateHamburgerIcon(delegate: self)
        self.activateNotificationIcon()
        self.activatePromotionIcon()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUserAuthenticationStatusChanged), name: NSNotification.Name(rawValue: "com.ExpertConnect.loggedIn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onUserSignupStatusChanged), name: NSNotification.Name(rawValue: "com.ExpertConnect.Signup"), object: nil)
        
        if !UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            self.navigationController!.pushViewController(LoginWireFrame.setupLoginModule() as UIViewController, animated: false)
        } else {
            let message = "Processing".localized(in: "Login")
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
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.objTabbarMain.tabBar.isHidden = false
            
            self.menuLeft = VKSideMenu(size: (self.view.frame.size.width-(self.view.frame.size.width*20)/100), andDirection: VKSideMenuDirection.fromLeft)
            self.menuLeft.dataSource = self;
            self.menuLeft.delegate   = self;
            self.menuLeft.addSwipeGestureRecognition(self.view)
            
            COLLECTION_CELL_EDGE_INTET = 0.0;
            
            self.collectionview.delegate = self;
            self.collectionview.dataSource = self;
            //        self.collectionview.delegateFlowLayout = self
            
            //self.searchBar.setImage(UIImage(named: "search_icon"), for: UISearchBarIcon.search, state:UIControlState.normal)
            self.collectionview.backgroundView = UIImageView(image: UIImage(named: "bg_1"))
            
            noDataLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 21)
            noDataLabel.center = self.view.center
            noDataLabel.textAlignment = .center
            noDataLabel.text = "No Results".localized(in: "Login")
            noDataLabel.font =  UIFont(name: "Raleway-Medium", size: 22)
            noDataLabel.textColor = UIColor.ExpertConnectBlack
            self.view.addSubview(noDataLabel)
            noDataLabel.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Expert Connect"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setExpertConnectSeacrhBarTheme(searchBar: self.searchBar)
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
        var categoryDict = [String: String]()
        if searchActive {
            categoryDict = (self.filteredArray[indexPath.row] as? [String:AnyObject])! as! [String : String]
        } else {
            categoryDict = (self.categoryArray[indexPath.row] as? [String:AnyObject])! as! [String : String]
        }
        
        var categoryName = categoryDict["category_name"]
        if categoryDict["sub_category_name"] != nil {
            categoryName = categoryDict["sub_category_name"]
        }
        
        if indexPath.row%2 == 0 {
            var cellidentifier = String()
            cellidentifier = "HomeCustomCell"
            collectionView.register(UINib.init(nibName: "HomeCustomCell", bundle: nil), forCellWithReuseIdentifier: cellidentifier)
            var cell = HomeCustomCell()
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as! HomeCustomCell
            cell.nameLabel.text = categoryName
            return cell
        } else {
            var cellidentifier2 = String()
            cellidentifier2 = "HomeSecondCustomCell"
            collectionView.register(UINib.init(nibName: "HomeSecondCustomCell", bundle: nil), forCellWithReuseIdentifier: cellidentifier2)
            var cell2 = HomeSecondCustomCell()
            cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier2, for: indexPath) as! HomeSecondCustomCell
            cell2.nameLabel.text = categoryName
            return cell2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subCategoryVC : SubCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryVC") as UIViewController as! SubCategoryVC
        var categoryDict = [String: String]()
        if searchActive {
            categoryDict = (self.filteredArray[indexPath.row] as? [String:AnyObject])! as! [String : String]
        } else {
            categoryDict = (self.categoryArray[indexPath.row] as? [String:AnyObject])! as! [String : String]
        }
        subCategoryVC.categoryDictionary = categoryDict as [String : AnyObject]
        
        self.navigationController?.pushViewController(subCategoryVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.setUpCollectionView()
        
        var countItems = CGFloat()
        countItems = 2
        
        var countItemSpasing = CGFloat()
        countItemSpasing = COLLECTION_CELL_EDGE_INTET * 3
        
        var width = CGFloat()
        width = (self.view.frame.size.width - countItemSpasing)/countItems
        var height = CGFloat()
        height = width * (7/9.5)
        
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func setUpCollectionView() {
        var countItems = CGFloat()
        countItems = 2
        var countItemSpasing = CGFloat()
        countItemSpasing = COLLECTION_CELL_EDGE_INTET * 3
        
        var width = CGFloat()
        width = (self.view.frame.size.width - countItemSpasing)/countItems
        
        
        
        _collectionFlowLayout.sectionInset = UIEdgeInsetsMake(COLLECTION_CELL_EDGE_INTET, 0, COLLECTION_CELL_EDGE_INTET, 0)
        let size = CGSize(width: width, height: 100)
        _collectionFlowLayout.itemSize = size
        _collectionFlowLayout.minimumInteritemSpacing = COLLECTION_CELL_EDGE_INTET
        _collectionFlowLayout.minimumLineSpacing = COLLECTION_CELL_EDGE_INTET
        
    }
    
    // MARK: - VKSideMenuDataSource
    
    func numberOfSections(in sideMenu: VKSideMenu!) -> Int {
        //        return (sideMenu == self.menuLeft || sideMenu == self.menuTop) ? 1 : 2
        return 1
    }
    
    func sideMenu(_ sideMenu: VKSideMenu!, numberOfRowsInSection section: Int) -> Int {
        if (sideMenu == self.menuLeft || sideMenu == self.menuTop){
            return 8;
        }
        return section == 0 ? 1 : 2;
    }
    
    func sideMenu(_ sideMenu: VKSideMenu!, itemForRowAt indexPath: IndexPath!) -> VKSideMenuItem! {
        let item = VKSideMenuItem()
        
        if (sideMenu == self.menuLeft || sideMenu == self.menuTop) // All LEFT and TOP menu items
        {
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
                
            case 2:
                item.title = "My Category";
                item.icon = UIImage(named: "my_category_icon")
                break;
                
            case 3:
                item.title = "Refer Friend";
                item.icon = UIImage(named: "refer_friend_icon")
                break;
                
            case 4:
                item.title = "Manage Expertise";
                item.icon = UIImage(named: "manage_expertise_icon")
                break;
                
            case 5:
                item.title = "My Account";
                item.icon = UIImage(named: "my_account_icon")
                break;
                
            case 6:
                item.title = "Settings";
                item.icon = UIImage(named: "settings_icon")
                break;
                
            case 7:
                item.title = "Logout";
                item.icon = UIImage(named: "logout_icon")
                break;
                
            default:
                break;
            }
        }
        return item
    }
    
    // MARK: - VKSideMenuDelegate
    func sideMenu(_ sideMenu: VKSideMenu!, didSelectRowAt indexPath: IndexPath!) {
       
        switch indexPath.row {
            case 0:
            break;
            
            case 1:
            break;
            
            case 2:
            break;
            
            case 3:
            break;
            
            case 4:
                let manageExpertiseView : ManageExpertiseView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManageExpertiseView") as UIViewController as! ManageExpertiseView
                self.navigationController?.pushViewController(manageExpertiseView, animated: true)

            break;
            
            case 5:
            break;
            
            case 6:
            break;
            
            case 7:
                self.view.endEditing(true)
                self.askForLogoutIfUserIsSure()
            break;
            
            default:
            break;
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
            self.navigationController!.pushViewController(LoginWireFrame.setupLoginModule() as UIViewController, animated: false)
        }))
        
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    func showLoginController() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let defaults = UserDefaults.standard
        //        defaults.set(str, forKey: "teacherStudentValue")
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
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
        print("Hey you logged in: \(data.categories[0])")
        self.categoryArray = data.categories
        self.subCategoryArray = data.subCategories
        let mainCategory = data.categories as NSArray
        UserDefaults.standard.set(mainCategory, forKey: "MainCategory")
        collectionview.reloadData()
        self.dismissProgress()
    }
    
    func onUserLoginFailed(error: EApiErrorType) {
        // Update the view
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
    
    // MARK: SearchBar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //(content BEGINSWITH[c] %@) OR (content CONTAINS[c] %@)
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
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.collectionview.reloadData()
        return true
    }
 }


