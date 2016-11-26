//
//  SubCategoryVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 17/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class SubCategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
    var model = SubCategoryOutputDomainModel()
    var categoryDictionary: [String: AnyObject] = [:]
    var subCategoryArray: NSArray = [NSDictionary]() as NSArray

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableview.backgroundView = UIImageView(image: UIImage(named: "bg_1"))
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = categoryDictionary["category_name"] as? String
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.addBackButtonOnNavigationBar()
    }
    
    func addBackButtonOnNavigationBar(){
        let settingsButton = UIButton()
        settingsButton.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        settingsButton.backgroundColor = UIColor.clear
        
        settingsButton.setImage(UIImage(named: "back_btn"), for: UIControlState.normal)
        settingsButton.addTarget(self, action: #selector(backButtonClicked(button:)), for: .touchUpInside)
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view1.backgroundColor = UIColor.clear
        view1.addSubview(settingsButton)
        
        
        let rightButtonItem = UIBarButtonItem(customView: view1)
        //        let barItems = Array[rightButtonItem]
        self.navigationItem.leftBarButtonItem = rightButtonItem
        
    }
    func backButtonClicked(button: UIButton) {
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
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
        return cell
    }
    
    // MARK: tableview delegate methods
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
        self.subCategoryArray = data.subCategories
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
}
