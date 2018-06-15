//
//  ManageExpertiseView.swift
//  ExpertConnect
//
//  Created by Redbytes on 10/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ManageExpertiseView: UIViewController, UITableViewDelegate, UITableViewDataSource, AddExpertiseProtocol {
    
    @IBOutlet var tableview: UITableView!
    var myExpertiseArray = NSMutableArray()
    var myExpertiseFilteredArray = NSMutableArray()
    var userId = String()
    var isShowAlert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.activateBackIcon()
        self.activateAddIcon(delegate: self)
        self.navigationItem.title = "Manage Expertise"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        self.makeTableSeperatorColorClear()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ManageExpertise")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Loading Expertise Details".localized(in: "ManageExpertise")
        self.displayProgress(message: message)
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        let manageExpertiseDomainModel = ManageExpertiseDomainModel.init(userId: self.userId)
        let APIDataManager : ManageExpertiseProtocols = ManageExpertiseAPIDataManager()
        APIDataManager.getMyExpertiseDetails(model: manageExpertiseDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onGetMyExpertiseDetailsFailed(error: error)
            case .Success(let data as ManageExpertiseOutputDomainModel):
                do {
                    self.onGetMyExpertiseDetailsSucceeded(data: data)
                } catch {
                    self.onGetMyExpertiseDetailsFailed(data: data)
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
        return self.myExpertiseFilteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let identifier = "ManageExpertiseCell"
        var cell: ManageExpertiseCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ManageExpertiseCell
        if cell == nil {
            tableView.register(ManageExpertiseCell.self, forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ManageExpertiseCell
        }
        let dic : NSDictionary = self.myExpertiseFilteredArray[indexPath.row] as! NSDictionary
        cell.mainCategoryLabel.text = dic.value(forKey: "category_name") as? String
        cell.subCategoryLabel.text = dic.value(forKey: "sub_category_name") as? String
        cell.expertLevelLabel.text = dic.value(forKey: "level") as? String
        self.setECTableViewCellShadowTheme(view: cell.mainView)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110-27
    }
    
    // MARK: MyAssignment API Response methods
    func onGetMyExpertiseDetailsSucceeded(data: ManageExpertiseOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            if(isShowAlert) {
                let message = "New Expertise Details Added Successfully".localized(in: "ManageExpertise")
                self.displaySuccessMessage(message: message)
                self.isShowAlert = false
            }
            self.myExpertiseFilteredArray.removeAllObjects()
            self.myExpertiseArray = NSMutableArray.init(array: data.myExpertise as! [Any])
            
            for i in 0..<self.myExpertiseArray.count {
                if(i+1 < self.myExpertiseArray.count) {
                    
                    if((self.myExpertiseArray[i] as AnyObject).value(forKey: "sub_category_name") as? String != (self.myExpertiseArray[i+1] as AnyObject).value(forKey: "sub_category_name") as? String ) {
                        self.myExpertiseFilteredArray.add(self.myExpertiseArray[i])
                    }
                } else {
                    self.myExpertiseFilteredArray.add(self.myExpertiseArray[i])
                }
            }
            print("myExpertiseFilteredArray : ", self.myExpertiseFilteredArray)
            
            self.tableview.reloadData()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onGetMyExpertiseDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.myExpertiseFilteredArray.removeAllObjects()
        self.tableview.reloadData()
        self.displayErrorMessage(message: "No expert list found in the database")
    }
    
    func onGetMyExpertiseDetailsFailed(data: ManageExpertiseOutputDomainModel) {
        self.dismissProgress()
        self.myExpertiseFilteredArray.removeAllObjects()
        self.tableview.reloadData()
        self.displayErrorMessage(message: data.message)
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage(message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    func addExpertiseSucceded(showAlert: Bool) {
        self.isShowAlert = true
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
