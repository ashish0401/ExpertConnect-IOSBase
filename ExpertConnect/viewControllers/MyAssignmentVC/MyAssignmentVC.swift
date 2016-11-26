//
//  MyAssignmentVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 09/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class MyAssignmentVC: UIViewController {

    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Assignment"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
       // self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 247/255, green: 67/255, blue: 0.0, alpha: 1.0)]
        
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
