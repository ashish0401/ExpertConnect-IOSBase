//
//  MyAccountVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 18/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class MyAccountVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activateBackIcon()
        self.navigationItem.title = "My Account"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
