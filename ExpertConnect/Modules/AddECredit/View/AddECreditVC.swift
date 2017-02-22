//
//  AddECreditVC.swift
//  ExpertConnect
//
//  Created by Nadeem on 04/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class AddECreditVC: UIViewController {
    
    var expertDetailsInputDomainModel: ExpertDetailsInputDomainModel!
    var signUpInputDomainModel: SignUpInputDomainModel!
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var thirdView: UIView!
    @IBOutlet var skipButton: UIButton!
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        let coachingDetailsVC : CoachingDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoachingDetailsVC") as UIViewController as! CoachingDetailsVC
        coachingDetailsVC.expertDetailsInputDomainModel = expertDetailsInputDomainModel
        coachingDetailsVC.signUpInputDomainModel = signUpInputDomainModel
        self.navigationController?.pushViewController(coachingDetailsVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true;
        self.activateBackIcon()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Add E Credits"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.setExpertConnectRedButtonTheme(button: self.skipButton)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.firstView.layer.shadowColor = UIColor.black.cgColor
        self.firstView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.firstView.layer.shadowOpacity = 0.4
        self.firstView.layer.shadowRadius = 0.3
        let shadowRect = self.firstView.bounds.insetBy(dx: 0,dy: 0)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
