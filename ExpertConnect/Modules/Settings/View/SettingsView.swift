//
//  SettingsView.swift
//  ExpertConnect
//
//  Created by Redbytes on 18/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class SettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource, CoachingDetailsDelegate, ResetPasswordDelegate, ChangeNumberDelegate {
    @IBOutlet var tableview: UITableView!
    var settingsArray = NSMutableArray()
    var userId = String()
    var isShowAlert: Bool = false
    var userType: String = ""
    var alertMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.activateBackIcon()
        self.makeTableSeperatorColorClear()
        self.userType = UserDefaults.standard.value(forKey: "teacherStudentValue") as! String
        self.settingsArray.add("Notification".localized(in: "SettingsView"))
        self.settingsArray.add("CoachingDetails".localized(in: "SettingsView"))
        self.settingsArray.add("PaymentDetails".localized(in: "SettingsView"))
        self.settingsArray.add("ChangeNumber".localized(in: "SettingsView"))
        self.settingsArray.add("DeleteAccount".localized(in: "SettingsView"))
        self.settingsArray.add("PasswordReset".localized(in: "SettingsView"))
        self.settingsArray.add("HelpSupport".localized(in: "SettingsView"))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if(isShowAlert) {
            let message = self.alertMessage
            self.displaySuccessMessage(message: message)
            self.isShowAlert = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.init(colorLiteralRed: 183/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0)
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SettingsViewCell"
        var cell: SettingsViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsViewCell
        if cell == nil {
            tableView.register(SettingsViewCell.self, forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsViewCell
        }
        cell.settingsTitleLabel.text = self.settingsArray[indexPath.row] as? String
        
        for subview in cell.contentView.subviews {
            if (subview.isKind(of:UISwitch.self)) {
                subview.removeFromSuperview()
            }
        }
        if(indexPath.row == 0) {
            let mySwitch = UISwitch(frame:CGRect(x: self.view.frame.width - 75, y: 16, width: 0, height: 0))
            mySwitch.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
            if(UserDefaults.standard.bool(forKey: "PushNotificationStatus")) {
                mySwitch.setOn(true, animated: false)
                mySwitch.onTintColor = UIColor.init(colorLiteralRed: 244/255.0, green: 183/255.0, blue: 147/255.0, alpha: 1.0)
                mySwitch.thumbTintColor = UIColor.ExpertConnectRed
            } else {
                mySwitch.setOn(false, animated: false)
                mySwitch.tintColor = UIColor.init(colorLiteralRed: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1.0)
                mySwitch.thumbTintColor = UIColor.init(colorLiteralRed: 186/255.0, green: 186/255.0, blue: 186/255.0, alpha: 1.0)
            }
            mySwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
            cell.contentView.addSubview(mySwitch)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK: tableview Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break;
            
        case 1:
            //update coaching details
            let updateCoachingDetailsView : UpdateCoachingDetailsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateCoachingDetailsView") as UIViewController as! UpdateCoachingDetailsView
            updateCoachingDetailsView.delegate = self
            self.navigationController?.pushViewController(updateCoachingDetailsView, animated: true)
            break;
            
        case 2:
            //payment details
            break;
            
        case 3:
            //change number
            let changeNumberView : ChangeNumberView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangeNumberView") as UIViewController as! ChangeNumberView
            changeNumberView.delegate = self
            self.navigationController?.pushViewController(changeNumberView, animated: true)
            break;
            
        case 4:
            //delete account
            let deleteAccountView : DeleteAccountView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteAccountView") as UIViewController as! DeleteAccountView
            //changeNumberView.delegate = self
            self.navigationController?.pushViewController(deleteAccountView, animated: true)
            break;
            
        case 5:
            //reset password
            let resetPasswordView : ResetPasswordView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordView") as UIViewController as! ResetPasswordView
            resetPasswordView.delegate = self
            self.navigationController?.pushViewController(resetPasswordView, animated: true)
            break;
            
        case 6:
            //help_support
            let helpSupportView : HelpSupportView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpSupportView") as UIViewController as! HelpSupportView
            self.navigationController?.pushViewController(helpSupportView, animated: true)
            break;
            
        default:
            break;
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int ) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func switchChanged(sender: UISwitch!) {
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        print("Switch value is \(sender.isOn)")
        if(sender.isOn) {
            let message = "Updating notification to on".localized(in: "SettingsView")
            self.displayProgress(message: message)
            let pushNotificationInputDomainModel = PushNotificationInputDomainModel.init(userId: self.userId, notificationStatus: "1")
            let APIDataManager : PushNotificationProtocol = PushNotificationApiDataManager()
            APIDataManager.setNotificationOnOff(data: pushNotificationInputDomainModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onUpdatePushNotificationFailed(error: error)
                    sender.setOn(false, animated: false)
                    break
                    
                case .Success(let data as OTPOutputDomainModel):
                    sender.onTintColor = UIColor.init(colorLiteralRed: 244/255.0, green: 183/255.0, blue: 147/255.0, alpha: 1.0)
                    sender.thumbTintColor = UIColor.ExpertConnectRed
                    UserDefaults.standard.set(true, forKey: "PushNotificationStatus")
                    self.onUpdatePushNotificationSucceed(data: data)
                    break
                    
                default:
                    break
                }
            })
            
        } else {
            let message = "Updating notification to off".localized(in: "SettingsView")
            self.displayProgress(message: message)
            let pushNotificationInputDomainModel = PushNotificationInputDomainModel.init(userId: self.userId, notificationStatus: "0")
            let APIDataManager : PushNotificationProtocol = PushNotificationApiDataManager()
            APIDataManager.setNotificationOnOff(data: pushNotificationInputDomainModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onUpdatePushNotificationFailed(error: error)
                    sender.setOn(true, animated: false)
                    break
                    
                case .Success(let data as OTPOutputDomainModel):
                    self.onUpdatePushNotificationSucceed(data: data)
                    sender.thumbTintColor = UIColor.init(colorLiteralRed: 186/255.0, green: 186/255.0, blue: 186/255.0, alpha: 1.0)
                    UserDefaults.standard.set(false, forKey: "PushNotificationStatus")
                    break
                    
                default:
                    break
                }
            })
        }
    }
    
    // MARK: - Update Coaching Detail Delegate
    func updateCoachingDetailsSucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }
    // MARK: - Reset Password Delegate
    func resetPasswordSucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }
    // MARK: - Change Number Delegate
    func changeNumberSucceded(showAlert: Bool, message: String) {
        self.isShowAlert = true
        self.alertMessage = message
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
    
    func onUpdatePushNotificationSucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            self.displaySuccessMessage(message: data.message)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onUpdatePushNotificationFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed to apply notification setting")
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage( message: message)
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
