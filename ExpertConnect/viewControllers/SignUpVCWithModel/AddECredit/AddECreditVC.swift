//
//  AddECreditVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class AddECreditVC: UIViewController {
    
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var thirdView: UIView!
    @IBOutlet var skipButton: UIButton!
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "CoachingDetailsVC") as UIViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        
        //        self.firstView.layer.shadowColor = UIColor.black.cgColor
        //        self.firstView.layer.shadowOffset = CGSize(width: 0, height: 1)
        //        self.firstView.layer.shadowOpacity = 0.4
        //        self.firstView.layer.shadowRadius = 5
        
        //        self.firstView.layer.shadowColor = UIColor.black.cgColor
        //        self.firstView.layer.shadowOffset = CGSize(width: 0, height: 1)
        //        self.firstView.layer.shadowOpacity = 0.4
        //        self.firstView.layer.shadowRadius = 5.0
        //        let shadowRect = self.firstView.bounds.insetBy(dx: 0,dy: 4)
        //
        //        self.firstView.layer.shadowPath = UIBezierPath(rect:shadowRect).cgPath
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Add E Credits"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 247/255, green: 67/255, blue: 0.0, alpha: 1.0)]
        self.addBackButtonOnNavigationBar()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.firstView.layer.shadowColor = UIColor.black.cgColor
        self.firstView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.firstView.layer.shadowOpacity = 0.4
        self.firstView.layer.shadowRadius = 0.3
        let shadowRect = self.firstView.bounds.insetBy(dx: 0,dy: 0)
        
        // self.firstView.layer.shadowPath = UIBezierPath(rect:shadowRect).cgPath
        self.firstView.layer.shadowPath = UIBezierPath(roundedRect: self.firstView.bounds, cornerRadius: 3).cgPath
        
        
        self.firstView.layer.cornerRadius = 3
        
        
        self.secondView.layer.shadowColor = UIColor.black.cgColor
        self.secondView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.secondView.layer.shadowOpacity = 0.4
        self.secondView.layer.shadowRadius = 0.3
        
        self.secondView.layer.shadowPath = UIBezierPath(roundedRect: self.secondView.bounds, cornerRadius: 3).cgPath
        self.secondView.layer.cornerRadius = 3
        
        self.thirdView.layer.shadowColor = UIColor.black.cgColor
        self.thirdView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.thirdView.layer.shadowOpacity = 0.4
        self.thirdView.layer.shadowRadius = 0.3
        
        self.thirdView.layer.shadowPath = UIBezierPath(roundedRect: self.thirdView.bounds, cornerRadius: 3).cgPath
        self.thirdView.layer.cornerRadius = 3
    }
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        self.navigationController?.isNavigationBarHidden = true
    //        self.navigationController?.navigationBar.removeFromSuperview()
    //
    //    }
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
