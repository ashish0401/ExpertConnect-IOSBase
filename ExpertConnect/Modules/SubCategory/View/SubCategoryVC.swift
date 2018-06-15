//
//  SubCategoryVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 17/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class SubCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource,CustomIOS7AlertViewDelegate, AKSSegmentedSliderControlDelegate {
    
    @IBOutlet var tableview: UITableView!
    var model = SubCategoryOutputDomainModel()
    var categoryDictionary: [String: AnyObject] = [:]
    var subCategoryArray = NSMutableArray()
    let alertView = CustomIOS7AlertView()
    var expertLevelSliderView = UIView()
    let buttonTitleArray = ["SUBMIT"]
    var expertLevelButton = UIButton()
    var categoryId = String()
    var subCategoryId = String()
    var userId = String()
    var expertiseString = String()
    var expertiseLevelString = String()
    var cell = ExpertLevelCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableview.backgroundView = UIImageView(image: UIImage(named: "bg_1"))
        if categoryDictionary["sub_category_name"] != nil {
            self.subCategoryArray.add(categoryDictionary)
            tableview.reloadData()
        } else {
            if (!self.isInternetAvailable()) {
                let message = "No Internet Connection".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }
            let message = "Processing".localized(in: "Login")
            self.displayProgress(message: message)
            let viewModel = self.getSubCategoryViewModel()
            let APIDataManager: SubCategoryProtocols = SubCategoryAPIDataManager()
            APIDataManager.getSubCategoryDetails(model: viewModel, callback: { (result) in
                switch result {
                case .Failure(let error):
                    self.onSubcategoryDataFailed(error: error)
                case .Success(let data as SubCategoryOutputDomainModel):
                    do {
                        self.onSubcategoryDataSucceeded(data: data)
                    } catch {
                        self.onSubcategoryDataFailed(error: EApiErrorType.InternalError)
                    }
                default:
                    break
                }
            })
        }
        self.categoryId = categoryDictionary["category_id"] as! String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = categoryDictionary["category_name"] as? String
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.activateBackIcon()
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.subCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let identifier = "SubCategoryCell"
        var cell: SubCategoryCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SubCategoryCell
        if cell == nil {
            tableView.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SubCategoryCell
        }
        let subCategoryDict = self.subCategoryArray[indexPath.row] as? [String:AnyObject]
        let subCategoryName = subCategoryDict?["sub_category_name"] as? String
        cell.nameLabel.text = subCategoryName
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subCategoryDict = self.subCategoryArray[indexPath.row] as? [String:AnyObject]
        let subCategoryId = subCategoryDict?["sub_category_id"] as? String
        self.subCategoryId = subCategoryId!
        let expertiseString = subCategoryDict?["sub_category_name"] as? String
        self.expertiseString = expertiseString!
        
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Processing".localized(in: "SignUp")
        self.displayProgress(message: message)
        if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        } else {
            self.userId = "0"
        }
        let teacherListModel = TeacherListDomainModel.init(userId: self.userId, categoryId: self.categoryId, subCategoryId: self.subCategoryId)
        let APIDataManager : TeacherListProtocols = TeacherListApiDataManager()
        APIDataManager.getTeacherList(data: teacherListModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.ongetTeacherListFailed(error: error)
            case .Success(let data as TeacherListOutputDomainModel):
                do {
                    self.ongetTeacherListSucceeded(data: data)
                } catch {
                    self.ongetTeacherListFailed(data: data)
                }
            default:
                break
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 85
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: SubcategoryData delegate methods
    func getSubCategoryViewModel() -> SubCategoryDomainModel {
        return SubCategoryDomainModel(
            categoryId: categoryDictionary["category_id"] as! String
        )
    }
    
    func onSubcategoryDataSucceeded(data: SubCategoryOutputDomainModel) {
        print("Hey you logged in: \(data.subCategories[0])")
        self.subCategoryArray = data.subCategories.mutableCopy() as! NSMutableArray
        tableview.reloadData()
        self.dismissProgress()
    }
    
    func onSubcategoryDataFailed(error: EApiErrorType) {
        self.dismissProgress()
        let message = "No sub categories found in the database".localized(in: "Login")
        self.displayErrorMessage(message: message)
    }
    
    func displayErrorMessage(message: String) {
        self.showErrorMessage(message: message)
    }
    
    func createContainerViewForExpertLevel() -> UIView {
        let View = UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 170))
        let label = UILabel(frame: CGRect(x: 10, y: 20, width: 200, height: 25))
        label.text = "Select teacher's expert level"
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.left;
        
        label.font =  UIFont(name: "Raleway-Medium", size: 15)
        label.textColor = UIColor.ExpertConnectBlack
        View.addSubview(label)
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 246, y: 0, width: 44, height: 44)
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        closeButton.layer.cornerRadius = 3
        View.addSubview(closeButton)
        
        expertLevelSliderView = UIView(frame: CGRect(x: 0, y: 50, width: 290.00, height: 80.00))
        self.setUpExpertLevelSlider()
        View.addSubview(expertLevelSliderView)
        
        return View;
    }
    
    func pressButton(button: UIButton) {
        alertView.close()
    }
    
    func setUpExpertLevelSlider(){
        self.cell = Bundle.main.loadNibNamed("ExpertLevelCell", owner: nil, options: nil)?[0] as! ExpertLevelCell
        cell.beginnerButton.addTarget(self, action: #selector(beginnerButtonClicked), for: .touchUpInside)
        cell.intermediateButton.addTarget(self, action: #selector(intermediateButtonClicked), for: .touchUpInside)
        cell.advanceButton.addTarget(self, action: #selector(advanceButtonClicked), for: .touchUpInside)
        self.beginnerButtonClicked()
        expertLevelSliderView.addSubview(self.cell)
    }
    
    func beginnerButtonClicked() {
        self.setupBeginnerLevelButtons()
        self.expertiseLevelString = "BEGINNER"
    }
    
    func intermediateButtonClicked() {
        self.setupIntermediateLevelButtons()
        self.expertiseLevelString = "INTERMEDIATE"
    }
    
    func advanceButtonClicked() {
        self.setupAdvanceLevelButtons()
        self.expertiseLevelString = "ADVANCE"
    }
    
    func setupBeginnerLevelButtons() {
        self.cell.beginnerButton.setImage(UIImage(named:"selected_beginner_btn"), for: UIControlState.normal)
        self.cell.intermediateButton.setImage(UIImage(named:"unselected_intermediate_btn"), for: UIControlState.normal)
        self.cell.advanceButton.setImage(UIImage(named:"unselected_advance_btn"), for: UIControlState.normal)
        UIView.transition(with: self.cell.beginnerButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.beginnerButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
            self.cell.beginnerButton.setTitleColor(.ExpertConnectRed, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.intermediateButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.intermediateButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.intermediateButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.advanceButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.advanceButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.advanceButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
    }
    
    func setupIntermediateLevelButtons() {
        self.cell.beginnerButton.setImage(UIImage(named:"unselected_beginner_btn"), for: UIControlState.normal)
        self.cell.intermediateButton.setImage(UIImage(named:"selected_intermediate_btn"), for: UIControlState.normal)
        self.cell.advanceButton.setImage(UIImage(named:"unselected_advance_btn"), for: UIControlState.normal)
        UIView.transition(with: self.cell.beginnerButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.beginnerButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.beginnerButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.intermediateButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.intermediateButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
            self.cell.intermediateButton.setTitleColor(.ExpertConnectRed, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.advanceButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.advanceButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.advanceButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
    }
    
    func setupAdvanceLevelButtons() {
        self.cell.beginnerButton.setImage(UIImage(named:"unselected_beginner_btn"), for: UIControlState.normal)
        self.cell.intermediateButton.setImage(UIImage(named:"unselected_intermediate_btn"), for: UIControlState.normal)
        self.cell.advanceButton.setImage(UIImage(named:"selected_advance_btn"), for: UIControlState.normal)
        UIView.transition(with: self.cell.beginnerButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.beginnerButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.beginnerButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.intermediateButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.intermediateButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 14)
            self.cell.intermediateButton.setTitleColor(.ExpertConnectBlack, for: .normal)
        }, completion: nil)
        UIView.transition(with: self.cell.advanceButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.cell.advanceButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
            self.cell.advanceButton.setTitleColor(.ExpertConnectRed, for: .normal)
        }, completion: nil)
    }
    
    // MARK: Custom Alert Handle button touches
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        alertView.close()
        if (buttonIndex==0)
        {
            if (!self.isInternetAvailable()) {
                let message = "No Internet Connection".localized(in: "ExpertDetails")
                self.displayErrorMessage(message: message)
                return
            }
            let message = "Processing".localized(in: "SignUp")
            self.displayProgress(message: message)
            if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
                self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            } else {
                self.userId = "0"
            }
            let teacherListModel = TeacherListDomainModel.init(userId: self.userId, categoryId: self.categoryId, subCategoryId: self.subCategoryId)
            //            capitalized
            let APIDataManager : TeacherListProtocols = TeacherListApiDataManager()
            APIDataManager.getTeacherList(data: teacherListModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.ongetTeacherListFailed(error: error)
                case .Success(let data as TeacherListOutputDomainModel):
                    do {
                        self.ongetTeacherListSucceeded(data: data)
                    } catch {
                        self.ongetTeacherListFailed(data: data)
                    }
                default:
                    break
                }
            })
        }
    }
    
    // MARK: SignUp handelers for API Methods
    func ongetTeacherListSucceeded(data: TeacherListOutputDomainModel) {
        // navigate to teacher
        self.dismissProgress()
        if data.status {
            let TeacherListVC : TeacherListVC = UIStoryboard(name: "TeacherListVC", bundle: nil).instantiateViewController(withIdentifier: "TeacherListVC") as UIViewController as! TeacherListVC
            TeacherListVC.teacherListArray = NSMutableArray.init(array: data.categories as! [Any])
            TeacherListVC.categoryId = self.categoryId
            TeacherListVC.subCategoryId = self.subCategoryId
            TeacherListVC.expertiseString = self.expertiseString
            TeacherListVC.expertLevel = expertiseLevelString.capitalized
            self.navigationController?.pushViewController(TeacherListVC, animated: true)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func ongetTeacherListFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "No teacher list found in the database")
    }
    
    func ongetTeacherListFailed(data:TeacherListOutputDomainModel) {
        self.dismissProgress()
        self.displayErrorMessage(message: data.message)
    }
    
    // MARK: Alert methods
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
}
