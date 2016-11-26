//
//  BrowseEnquiryVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 09/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class BrowseEnquiryVC: UIViewController {

    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Browse Enquiry"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
      //  self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 247/255, green: 67/255, blue: 0.0, alpha: 1.0)]
    }
    override func viewWillAppear(_ animated: Bool) {
        self.addRightNavigationButtonsOnNavigationBar()
    }
    func addRightNavigationButtonsOnNavigationBar(){
        //        notification_btn  promotion_btn
        let notificationButton = UIButton()
        notificationButton.frame = CGRect(x: 5, y: 7, width: 30, height: 30)
        notificationButton.backgroundColor = UIColor.clear
        
        notificationButton.setImage(UIImage(named: "search_browse_enquiry"), for: UIControlState.normal)
        notificationButton.addTarget(self, action: #selector(searchButtonClicked(button:)), for: .touchUpInside)
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        view1.backgroundColor = UIColor.clear
        view1.addSubview(notificationButton)
        let rightButtonItem1 = UIBarButtonItem(customView: view1)
        
        
        self.navigationItem.rightBarButtonItem = rightButtonItem1
        
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    func searchButtonClicked(button: UIButton) {
        self.view.endEditing(true)
        
        
    }
    func notificationButtonClicked(button: UIButton) {
        
        self.view.endEditing(true)
    }
    func promotionButtonClicked(button: UIButton) {
        
        self.view.endEditing(true)
    }

}
