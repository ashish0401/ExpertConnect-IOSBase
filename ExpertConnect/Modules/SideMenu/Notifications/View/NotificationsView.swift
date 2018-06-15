//
//  NotificationsView.swift
//  ExpertConnect
//
//  Created by Redbytes on 17/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class NotificationsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    var notificationsArray = NSMutableArray()
    var userId = String()
    var noDataLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.objTabbarMain.tabBar.isHidden = true
        self.navigationItem.title = "Notifications"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.activateBackIcon()
        self.makeTableSeperatorColorClear()
        let message = "NotificationUnavailable".localized(in: "NotificationsView")
        self.noDataLabel = self.showStickyErrorMessage(message: message)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "NotificationsView")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Getting latest notifications".localized(in: "NotificationsView")
        self.displayProgress(message: message)
        
        self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        let notificationsDomainModel = NotificationsDomainModel.init(userId: self.userId)
        let APIDataManager : NotificationsProtocols = NotificationsAPIDataManager()
        APIDataManager.getNotificationsDetails(model: notificationsDomainModel, callback:{(result) in
            print("result : ", result)
            switch result {
            case .Failure(let error):
                self.onGetNotificationsDetailsFailed(error: error)
            case .Success(let data as NotificationsOutputDomainModel):
                do {
                    self.onGetNotificationsDetailsSucceeded(data: data)
                } catch {
                    self.onGetNotificationsDetailsFailed(data: data)
                }
            default:
                break
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.init(colorLiteralRed: 183/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0)
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "NotificationsViewCell"
        var cell: NotificationsViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationsViewCell
        if cell == nil {
            tableView.register(NotificationsViewCell.self, forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationsViewCell
        }
        let dic : NSDictionary = self.notificationsArray[indexPath.row] as! NSDictionary
        cell.notificationLabel.text = dic.value(forKey: "message") as? String
        let dateString = dic.value(forKey: "timestamp") as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObj = dateFormatter.date(from: dateString!)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy - hh:mm a"
        let stringFromDate = dateFormatter2.string(from: dateObj!)
        let calendar =  Calendar(identifier: .gregorian)
        let date1 = calendar.date(from: DateComponents(year: calendar.component(.year, from: dateObj!), month: calendar.component(.month, from: dateObj!), day: calendar.component(.day, from: dateObj!), hour: calendar.component(.hour, from: dateObj!), minute: calendar.component(.minute, from: dateObj!)))!
        let timeOffset = date1.relativeTime // "1 year ago"
        cell.dateTimeLabel.text = timeOffset
        cell.profileImageView.image = UIImage(named: "profile_rectangle_img")
        if (dic.value(forKey: "profile_pic") as! String != "") {
            let url = URL(string: dic.value(forKey: "profile_pic") as! String)
            cell.profileImageView.kf.setImage(with: url)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK: tableview Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int ) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: BrowseEnquiryReceivedNotification API Response methods
    func onGetNotificationsDetailsSucceeded(data: NotificationsOutputDomainModel) {
        self.dismissProgress()
        if data.status {
            self.notificationsArray = NSMutableArray.init(array: data.notifications as! [Any])
            self.notificationsArray =  NSMutableArray(array: self.notificationsArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
            noDataLabel.isHidden = self.notificationsArray.count == 0 ? false : true
            self.tableview.reloadData()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onGetNotificationsDetailsFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.notificationsArray.removeAllObjects()
        self.tableview.reloadData()
        self.displayErrorMessage(message: "No notification history found in the database")
    }
    
    func onGetNotificationsDetailsFailed(data: NotificationsOutputDomainModel) {
        self.dismissProgress()
        self.notificationsArray.removeAllObjects()
        self.tableview.reloadData()
        self.displayErrorMessage(message: data.message)
    }
    
    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        noDataLabel.isHidden = self.notificationsArray.count == 0 ? false : true
    }
    
    func displaySuccessMessage(message: String){
        self.showSuccessMessage(message: message)
    }
    
    func relativeDateStringForDate(date : Date) -> NSString {
        // *** create calendar object ***
        var calendar = NSCalendar.current
        
        // *** Get components using current Local & Timezone ***
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date))
        
        // *** define calendar components to use as well Timezone to UTC ***
        let unitFlags = Set<Calendar.Component>([.hour, .day, .month, .year, .weekOfYear])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // *** Get components from date ***
        let components = calendar.dateComponents(unitFlags, from: date as Date)
        print("Components : \(components)")
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let weeks = components.weekOfYear
        
        if components.year! > 0 {
            return NSString.init(format: "%d years ago", year!);
        } else if components.month! > 0 {
            return NSString.init(format: "%d months ago", month!);
        } else if components.weekOfYear! > 0 {
            return NSString.init(format: "%d weeks ago", weeks!);
        } else if (components.day! > 0) {
            if components.day! > 1 {
                return NSString.init(format: "%d days ago", day!);
            } else {
                return "Yesterday";
            }
        } else {
            return NSString.init(format: "%d hours ago", hour!);
        }
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
