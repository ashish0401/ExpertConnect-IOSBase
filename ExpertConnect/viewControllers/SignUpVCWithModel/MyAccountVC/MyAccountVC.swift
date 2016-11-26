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

        self.navigationItem.title = "My Account"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 247/255, green: 67/255, blue: 0.0, alpha: 1.0)]
    }
    override func viewWillAppear(_ animated: Bool) {
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
