//
//  MyCategoryViewView.swift
//  ExpertConnect
//
//  Created by Redbytes on 09/02/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class MyCategoryView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
    var myCategoryArray = NSMutableArray()
    var userId = String()
    var noDataLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        
        self.activateBackIcon()
        self.navigationItem.title = "My Categories"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        self.makeTableSeperatorColorClear()
        
        let message = "MyCategoryUnavailable".localized(in: "MyCategoryView")
        self.noDataLabel = self.showStickyErrorMessage(message: message)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "MyCategoryView")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Loading your categories".localized(in: "MyCategoryView")
        self.displayProgress(message: message)
        
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        let myCategoryDomainModel = MyCategoryDomainModel.init(userId: self.userId)
        let APIDataManager : MyCategoryViewProtocols = MyCategoryAPIDataManager()
        APIDataManager.getMyCategoryDetails(model: myCategoryDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onGetMyCategoryDetailsFailed(error: error)
            case .Success(let data as MyCategoryOutputDomainModel):
                do {
                    self.onGetMyCategoryDetailsSucceeded(data: data)
                } catch {
                    self.onGetMyCategoryDetailsFailed(data: data)
                }
            default:
                break
            }
        })
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.myCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let identifier = "MyCategoryCell"
        var cell: MyCategoryCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyCategoryCell
        if cell == nil {
            tableView.register(MyCategoryCell.self, forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyCategoryCell
        }
        let dic : NSDictionary = self.myCategoryArray[indexPath.row] as! NSDictionary
        cell.mainCategoryLabel.text = dic.value(forKey: "category_name") as? String
        cell.subCategoryLabel.text = dic.value(forKey: "subcategory_name") as? String
        
        let status = dic.value(forKey: "status") as? String
        cell.statusLabel.text = status?.uppercased()
        if(status == "pending") {
            cell.statusLabel.textColor = UIColor.red
        } else if(status == "approved") {
            cell.statusLabel.textColor = UIColor.green
        } else if(status == "declined") {
            cell.statusLabel.textColor = UIColor.red
        }
        
        self.setECTableViewCellShadowTheme(view: cell.mainView)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    //MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 112
    }
    
    // MARK: MyAssignment API Response methods
    func onGetMyCategoryDetailsSucceeded(data: MyCategoryOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.myCategoryArray.removeAllObjects()
            self.myCategoryArray = NSMutableArray.init(array: data.myCategory as! [Any])
            noDataLabel.isHidden = self.myCategoryArray.count == 0 ? false : true
            self.tableview.reloadData()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onGetMyCategoryDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.myCategoryArray.removeAllObjects()
        self.tableview.reloadData()
        self.displayErrorMessage(message: "No expert list found in the database")
    }
    
    func onGetMyCategoryDetailsFailed(data: MyCategoryOutputDomainModel) {
        self.dismissProgress()
        self.myCategoryArray.removeAllObjects()
        self.tableview.reloadData()
        self.displayErrorMessage(message: data.message)
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        //self.showErrorMessage(message: message)
        noDataLabel.isHidden = self.myCategoryArray.count == 0 ? false : true
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
