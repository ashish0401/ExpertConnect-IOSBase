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
       // self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 247/255, green: 67/255, blue: 0.0, alpha: 1.0)]
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    }
