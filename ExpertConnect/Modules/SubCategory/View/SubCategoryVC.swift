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
        self.expertLevelButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        self.expertLevelButton.setTitle("BEGINNER", for: UIControlState.normal)
        
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
        //cell.selectionStyle = UITableViewCellSelectionStyle.none;
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

        alertView.buttonTitles = buttonTitleArray
        alertView.containerView = createContainerViewForExpertLevel()
        alertView.delegate = self
        alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
        }
        alertView.catchString(withString: "AlertWithSlider")
        alertView.show()
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
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
        print("Hey you logged in: \(data.subCategories[0])")
        self.subCategoryArray = data.subCategories.mutableCopy() as! NSMutableArray
        tableview.reloadData()
        self.dismissProgress()
    }
    
    func onSubcategoryDataFailed(error: EApiErrorType) {
        // Update the view
        self.dismissProgress()
         let message = "No sub categories found in the database".localized(in: "Login")
         self.displayErrorMessage(message: message)
    }
    
    func displayErrorMessage(message: String) {
        self.showErrorMessage(message: message)
    }
    
    func createContainerViewForExpertLevel() -> UIView {
        let View = UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 170))
        let label = UILabel(frame: CGRect(x: 10, y: 50, width: 110, height: 25))
        label.text = "Expert Level"
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.left;
        
        label.font =  UIFont(name: "Raleway-Light", size: 15)
        label.textColor = UIColor.ExpertConnectBlack
        View.addSubview(label)
        
        expertLevelButton = UIButton(frame: CGRect(x: 180, y: 50, width: 100, height: 27))
        expertLevelButton.setTitle("BEGINNER",for: .normal)
        expertLevelButton.backgroundColor = UIColor.ExpertConnectRed
        expertLevelButton.layer.cornerRadius = 3;
        expertLevelButton.layer.masksToBounds = true;
        expertLevelButton.layer.backgroundColor = UIColor.ExpertConnectRed.cgColor
        expertLevelButton.setTitleColor(UIColor.white, for:.normal);
        expertLevelButton.titleLabel!.font =  UIFont(name: "Raleway-Light", size: 15)
        View.addSubview(expertLevelButton)
        
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 246, y: 0, width: 44, height: 44)
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        closeButton.layer.cornerRadius = 3
        View.addSubview(closeButton)
        
        expertLevelSliderView = UIView(frame: CGRect(x: 0, y: 70, width: 290.00, height: 50.00))
        self.setUpExpertLevelSlider()
        View.addSubview(expertLevelSliderView)
        
        return View;
    }
    
    func pressButton(button: UIButton) {
        alertView.close()
    }
    
    func setUpExpertLevelSlider(){
        let tempXPosition : Float = Float((self.expertLevelSliderView.frame.width * 6)/100)
        let xPosition : Int = Int(tempXPosition)
        let yPosition = 30
        
        let tempWidth : Float = Float((self.expertLevelSliderView.frame.width * 94)/100)
        let width : Int = Int(tempWidth)
        let height = 20
        
        let tempSpaceBetweenPoints : Float = Float((self.expertLevelSliderView.frame.width * 37)/100)
        let spaceBetweenPoints = tempSpaceBetweenPoints
        let radiusPoint = 8
        let sliderLineWidth = 5
        
        var sliderConrolFrame: CGRect = CGRect.null
        sliderConrolFrame = CGRect(x: xPosition-4, y: (yPosition), width: width, height: height)
        //let sliderControl :  AKSSegmentedSliderControl = AKSSegmentedSliderControl(frame: sliderConrolFrame)
        let sliderControl :  AKSSegmentedSliderControl = AKSSegmentedSliderControl.init(frame: sliderConrolFrame)
        sliderControl.delegate = self
        sliderControl.move(to: 0)
        sliderControl.spaceBetweenPoints = Float(spaceBetweenPoints)
        sliderControl.radiusPoint = Float(radiusPoint)
        sliderControl.heightLine = Float(sliderLineWidth)
        sliderControl.numberOfPoints = 3
        expertLevelSliderView.addSubview(sliderControl)
       // sliderControl.backgroundColor = UIColor.red
    }
    
    func timeSlider(_ timeSlider: AKSSegmentedSliderControl! , didSelectPointAtIndex index:Int) -> Void  {
        if index == 0 {
            self.expertLevelButton.frame = CGRect(x: 180, y: 50, width: 100, height: 25)
            self.expertLevelButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
            self.expertLevelButton.setTitle("BEGINNER",for: .normal)
            
        }
        else if index == 1 {
            self.expertLevelButton.frame = CGRect(x: 142, y: 50, width: 138, height: 25)
            self.expertLevelButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
            self.expertLevelButton.setTitle("INTERMEDIATE", for: UIControlState.normal)
        }
        else if index == 2 {
            self.expertLevelButton.frame = CGRect(x: 180, y: 50, width: 100, height: 25)
            self.expertLevelButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
            self.expertLevelButton.setTitle("ADVANCE", for: UIControlState.normal)
        }
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
//            print(UserDefaults.standard.value(forKey: "UserId") as! String)
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let teacherListModel = TeacherListDomainModel.init(userId: self.userId, categoryId: self.categoryId, subCategoryId: self.subCategoryId, level: (self.expertLevelButton.titleLabel?.text?.capitalized)!)
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
            TeacherListVC.expertLevel = (self.expertLevelButton.titleLabel?.text?.capitalized)!
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
