//
//  MessagesView.swift
//  ExpertConnect
//
//  Created by Redbytes on 06/02/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol MessagesDelegate {
    func addCategorySucceded(showAlert:Bool, message: String) -> Void
}

class MessagesView: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomIOS7AlertViewDelegate, UITextViewDelegate {
    
    var delegate:MessagesDelegate!
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let alertView = CustomIOS7AlertView()
    var alertActionType = String()
    let buttonsForSendMessage = ["SEND"]
    let buttonsForSendEnquiry = ["SUBMIT"]
    var messageTextView = UITextView()
    var userId: String = ""
    var noDataLabel = UILabel()
    var sentArray = NSMutableArray()
    var receivedArray = NSMutableArray()
    var messagesArray = NSMutableArray()
    var receiverId: String = ""

    var teacherNameHeight = CGFloat()
    var messageHeight = CGFloat()
    let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height:0))
    let blankAttribute = NSLayoutAttribute(rawValue: 0)
//    var teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+10+22))
//    var messageWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+10+22))
    var teacherNameWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+10+10+44+22))
    var messageWidth : CGFloat = (UIScreen.main.bounds.size.width-(22+47+10+10+44+22))

    var isFromGeneralEnquiry: Bool = false
    var command: String = ""
    var urlEndPoint: String = ""

    override func viewDidLoad() {
        self.navigationItem.title = "Messages"
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.segmentedControl.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Raleway-Light", size: 18.0)! ], for: .normal)
        let sortedViews = segmentedControl.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        for (index, view) in sortedViews.enumerated() {
            if index == segmentedControl.selectedSegmentIndex {
                view.tintColor = UIColor.ExpertConnectRed
            } else {
                view.tintColor = UIColor.ExpertConnectBlack
            }
        }
        if(isFromGeneralEnquiry) {
            self.activateBackIcon()
        } else {
            self.activateTextualEnquiryIcon(delegate:self)
        }
        self.makeTableSeperatorColorClear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.noDataLabel.removeFromSuperview()
        if(isFromGeneralEnquiry) {
            self.navigationItem.title = "General Enquiries"
            appDelegate.objTabbarMain.tabBar.isHidden = true
            let message = "EnquiriesUnavailable".localized(in: "MessagesView")
            self.noDataLabel = self.showStickyErrorMessage(message: message)
            self.command = "getGeneralEnquiryList"
            self.urlEndPoint = "general_enquiries.php"

        } else {
            self.navigationItem.title = "Messages"
            appDelegate.objTabbarMain.tabBar.isHidden = false
            if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
                let message = "MessagesUnavailable".localized(in: "MessagesView")
                self.noDataLabel = self.showStickyErrorMessage(message: message)
            } else {
                let message = "LoginRequest".localized(in: "MessagesView")
                self.noDataLabel = self.showStickyErrorMessage(message: message)
            }
            self.command = "getNotificationList"
            self.urlEndPoint = "notification_activity.php"
        }
        self.getMessageDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        if(isFromGeneralEnquiry) {
            self.tableview.frame = CGRect(x: self.tableview.frame.origin.x, y: self.tableview.frame.origin.y - 49, width: self.tableview.frame.size.width, height: 49 + self.tableview.frame.size.height)
            self.segmentedControl.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getMessageDetails() {
        if (!self.isInternetAvailable()) {
            let message = "No Internet Connection".localized(in: "ExpertDetails")
            self.displayErrorMessage(message: message)
            return
        }
        let message = "Loading Messages".localized(in: "MessagesView")
        self.displayProgress(message: message)
        if UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
        } else {
            self.userId = "0"
        }
        
        let messagesViewInputDomainModel = MessagesViewInputDomainModel.init(userId: self.userId, command: self.command, urlEndPoint: self.urlEndPoint)
        let APIDataManager : MessagesViewProtocol = MessagesViewApiDataManager()
        APIDataManager.getNotificationList(data: messagesViewInputDomainModel, callback:{(result) in
            print("result : ", result)
            if(self.isFromGeneralEnquiry) {
                switch result {
                case .Failure(let error):
                    self.onGetMessageListFailed(error: error)
                case .Success(let data as EnquiryViewOutputDomainModel):
                    do {
                        self.onGetEnquiryListSucceeded(data: data)
                    } catch {
                        self.onGetEnquiryListFailed(data: data)
                    }
                default:
                    break
                }
                
            } else {
                switch result {
                case .Failure(let error):
                    self.onGetMessageListFailed(error: error)
                case .Success(let data as MessagesViewOutputDomainModel):
                    do {
                        self.onGetMessageListSucceeded(data: data)
                    } catch {
                        self.onGetMessageListFailed(data: data)
                    }
                default:
                    break
                }
            }
        })
    }
    
    private func makeTableSeperatorColorClear() {
        self.tableview.separatorColor = UIColor.clear
    }
    
    // MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "MessagesCustomCell"
        var cell: MessagesCustomCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessagesCustomCell
        if cell == nil {
            tableView.register(MessagesCustomCell.self, forCellReuseIdentifier: "MessagesCustomCell")
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessagesCustomCell
        }
        
        cell.messageButton.tag = indexPath.row
        cell.messageButton.addTarget(self, action: #selector(sendMessageButtonClicked(button:)), for: .touchUpInside)

        let apiConverter = MessagesViewApiModelConverter()
        if(self.isFromGeneralEnquiry) {
            let messageDetail = apiConverter.fromJson(json: self.messagesArray[indexPath.row] as! NSDictionary) as EnquiryModel
            
            cell.teacherNameLabel.text = messageDetail.userName
            cell.messageLabel.text = messageDetail.message
            cell.dateLabel.text = messageDetail.date
            cell.profileImageview.image = UIImage(named: "profile_rectangle_img")
            if (messageDetail.profilePic != "") {
                let url = URL(string: messageDetail.profilePic )
                cell.profileImageview.kf.setImage(with: url)
            }
        } else {
            let messageDetail = apiConverter.fromJson(json: self.messagesArray[indexPath.row] as! NSDictionary) as MessageModel
            
            cell.teacherNameLabel.text = messageDetail.userName
            cell.messageLabel.text = messageDetail.message
            cell.dateLabel.text = messageDetail.date
            cell.profileImageview.image = UIImage(named: "profile_rectangle_img")
            if (messageDetail.profilePic != "") {
                let url = URL(string: messageDetail.profilePic )
                cell.profileImageview.kf.setImage(with: url)
            }
        }

        teacherNameHeight = (cell.teacherNameLabel.text?.heightForView(text: cell.teacherNameLabel.text!, font: UIFont(name: "Raleway-Light", size: 17)!, width: teacherNameWidth))!
        messageHeight = (cell.messageLabel.text?.heightForView(text: cell.messageLabel.text!, font: UIFont(name: "Raleway-Light", size: 14)!, width: messageWidth))!

        cell.teacherNameLabel.removeConstraints(cell.teacherNameLabel.constraints)
        cell.messageLabel.removeConstraints(cell.messageLabel.constraints)

//        if self.segmentedControl.selectedSegmentIndex == 0 {
//            cell.messageButton.isHidden = true
//            self.setConstraints(actualView: cell.teacherNameLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 10, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 10, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
//            
//            self.setConstraints(actualView: cell.messageLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 10, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 10, upperView: cell.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: messageHeight, width: messageWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
//            
//        } else {
//            cell.messageButton.isHidden = false
            self.setConstraints(actualView: cell.teacherNameLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 10, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 64, upperView: cell.mainView, upperAttributeForActualView: .top, upperAttributeForUpperView: .top, upperViewConstant: 10, height: teacherNameHeight, width: teacherNameWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
            
            self.setConstraints(actualView: cell.messageLabel, leadingView: cell.profileImageview, leadingAttributeForActualView: NSLayoutAttribute.leading, leadingAttributeForLeadingView: NSLayoutAttribute.trailing, leadingViewConstant: 10, trailingView: cell.mainView, trailingAttributeForActualView: NSLayoutAttribute.trailing, trailingAttributeForTrailingView: NSLayoutAttribute.trailing, trailingViewConstant: 64, upperView: cell.teacherNameLabel, upperAttributeForActualView: .top, upperAttributeForUpperView: .bottom, upperViewConstant: 4, height: messageHeight, width: messageWidth, upperSpaceConstraint: true, leadingMarginConstraint: true, trailingMarginConstraint: true)
//        }

        self.setECTableViewCellShadowTheme(view: cell.mainView)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (22)+(teacherNameHeight)+(4)+(messageHeight)+(4)+(10)+(22)
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // MARK: Set Constraints method
    func setConstraints(actualView:UIView, leadingView:UIView, leadingAttributeForActualView:NSLayoutAttribute, leadingAttributeForLeadingView:NSLayoutAttribute, leadingViewConstant:CGFloat, trailingView:UIView, trailingAttributeForActualView:NSLayoutAttribute, trailingAttributeForTrailingView:NSLayoutAttribute, trailingViewConstant:CGFloat, upperView:UIView, upperAttributeForActualView:NSLayoutAttribute, upperAttributeForUpperView:NSLayoutAttribute, upperViewConstant:CGFloat, height:CGFloat, width:CGFloat, upperSpaceConstraint:Bool, leadingMarginConstraint:Bool, trailingMarginConstraint:Bool) {
        
        actualView.translatesAutoresizingMaskIntoConstraints = false
        
        /** remove constraints of reusable cell*/
        actualView.removeConstraints(actualView.constraints)
        /** end - remove constraints of reusable cell*/
        
        let heightConstraint = NSLayoutConstraint(item: actualView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(height))
        
        let widthConstraint = NSLayoutConstraint(item: actualView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
        
        NSLayoutConstraint.activate([heightConstraint,widthConstraint])
        
        var leadingMargin : NSLayoutConstraint!
        var trailingMargin : NSLayoutConstraint!
        var upperSpace : NSLayoutConstraint!
        if leadingMarginConstraint {
            leadingMargin = NSLayoutConstraint(item: actualView, attribute: leadingAttributeForActualView,
                                               relatedBy: NSLayoutRelation.equal, toItem: leadingView,
                                               attribute: leadingAttributeForLeadingView, multiplier: 1, constant: leadingViewConstant)
            NSLayoutConstraint.activate([leadingMargin])
        }
        if trailingMarginConstraint {
            trailingMargin = NSLayoutConstraint(item: trailingView, attribute: trailingAttributeForTrailingView,
                                                relatedBy: NSLayoutRelation.equal, toItem: actualView,
                                                attribute: trailingAttributeForActualView, multiplier: 1, constant: trailingViewConstant)
            NSLayoutConstraint.activate([trailingMargin])
        }
        if upperSpaceConstraint {
            upperSpace = NSLayoutConstraint(item: actualView, attribute: upperAttributeForActualView, relatedBy: .equal, toItem: upperView, attribute: upperAttributeForUpperView, multiplier: 1, constant: upperViewConstant)
            NSLayoutConstraint.activate([upperSpace])
        }
    }
    
    // MARK: Segmented Control Button Click method
    @IBAction func segmentedControlClicked(_ sender: Any) {
        let sortedViews = (sender as AnyObject).subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        for (index, view) in sortedViews.enumerated() {
            if index == (sender as AnyObject).selectedSegmentIndex {
                view.tintColor = UIColor.ExpertConnectRed
            } else {
                view.tintColor = UIColor.ExpertConnectBlack
            }
        }
        if (sender as AnyObject).selectedSegmentIndex == 0 {
//            self.teacherNameWidth = (UIScreen.main.bounds.size.width-(22+47+10+22))
//            self.messageWidth = (UIScreen.main.bounds.size.width-(22+47+10+22))

            self.teacherNameWidth = (UIScreen.main.bounds.size.width-(22+47+10+10+44+22))
            self.messageWidth = (UIScreen.main.bounds.size.width-(22+47+10+10+44+22))

            self.messagesArray = NSMutableArray.init(array: self.sentArray as! [Any])
            //Reverse Array
            self.messagesArray = self.messagesArray.reversed() as! NSMutableArray
            self.tableview.reloadData()
            noDataLabel.isHidden = self.messagesArray.count == 0 ? false : true
            
        } else {
            self.teacherNameWidth = (UIScreen.main.bounds.size.width-(22+47+10+10+44+22))
            self.messageWidth = (UIScreen.main.bounds.size.width-(22+47+10+10+44+22))

            self.messagesArray = NSMutableArray.init(array: self.receivedArray as! [Any])
            //Reverse Array
            self.messagesArray = self.messagesArray.reversed() as! NSMutableArray
            self.tableview.reloadData()
            noDataLabel.isHidden = self.messagesArray.count == 0 ? false : true
        }
}
    
    // MARK: Send Message Button Click method
    func sendMessageButtonClicked(button: UIButton) {
        if !UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            //Go to login screen
            let loginView = LoginWireFrame.setupLoginModule() as UIViewController
            let navController = UINavigationController(rootViewController: loginView)
            self.present(navController, animated: true, completion: nil)
            loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        } else {
            let apiConverter = MessagesViewApiModelConverter()
            if(self.isFromGeneralEnquiry) {
                let messageDetail = apiConverter.fromJson(json: self.messagesArray[button.tag] as! NSDictionary) as EnquiryModel
                self.receiverId = messageDetail.userId
            } else {
                let messageDetail = apiConverter.fromJson(json: self.messagesArray[button.tag] as! NSDictionary) as MessageModel
                self.receiverId = messageDetail.userId
            }
            
            alertActionType = "sendMesageAction"
            alertView.buttonTitles = buttonsForSendMessage
            // Set a custom container view
            alertView.containerView = createContainerView(message: "Write your message here")
            // Set self as the delegate
            alertView.delegate = self
            // Show time!
            alertView.catchString(withString: "4")
            alertView.show()
        }
    }

    // MARK: Send Message Button Click method
    func sendEnquiryButtonClicked() {
        if !UserDefaults.standard.bool(forKey: "UserLoggedInStatus") {
            //Go to login screen
            let loginView = LoginWireFrame.setupLoginModule() as UIViewController
            let navController = UINavigationController(rootViewController: loginView)
            self.present(navController, animated: true, completion: nil)
            loginView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
        } else {
            alertActionType = "sendEnquiryAction"
            alertView.buttonTitles = buttonsForSendEnquiry
            // Set a custom container view
            alertView.containerView = createContainerView(message: "Write your enquiry here")
            // Set self as the delegate
            alertView.delegate = self
            // Show time!
            alertView.catchString(withString: "4")
            alertView.show()
        }
    }
    
    // MARK: Custom Alert Delegates
    func customIOS7AlertViewButtonTouchUpInside(_ alertView: CustomIOS7AlertView, buttonIndex: Int) {
        //  print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        if alertActionType == "sendEnquiryAction" {
            if (self.messageTextView.text == nil || (self.messageTextView.text?.characters.count)! == 0) {
                let message = "Please write your enquiry"
                alertView.close()
                self.displayErrorMessageWithCallback(message: message)
                return
            }
            //Send Enquiry
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let enquiry = self.messageTextView.text!
            
            if (!self.isInternetAvailable()) {
                let message = "No Internet Connection".localized(in: "ManageExpertise")
                self.displayErrorMessage(message: message)
                return
            }
            let message = "Posting Enquiry".localized(in: "MessagesView")
            self.displayProgress(message: message)
            let enquiryInputDomainModel = SendEnquiryInputModel.init(userId: self.userId, message: enquiry.trimmingCharacters(in: .whitespacesAndNewlines), command : "addGeneralEnquiry")
            let APIDataManager : MessagesViewProtocol = MessagesViewApiDataManager()
            APIDataManager.sendEnquiry(data: enquiryInputDomainModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onSendEnquiryFailed(error: error)
                    break
                    
                case .Success(let data as OTPOutputDomainModel):
                    self.onSendEnquirySucceed(data: data)
                    break
                    
                default:
                    break
                }
            })
            //presenter?.notifyForgotPasswordButtonTapped()
            print("send email code")
            alertView.close()
            
        } else if alertActionType == "sendMesageAction" {
            if (self.messageTextView.text == nil || (self.messageTextView.text?.characters.count)! == 0) {
                let message = "Please write your message"
                alertView.close()
                self.displayErrorMessageWithCallback(message: message)
                return
            }
            //Send Message
            self.userId = UserDefaults.standard.value(forKey: "UserId") as! String
            let textMessage = self.messageTextView.text!
            if (!self.isInternetAvailable()) {
                let message = "No Internet Connection".localized(in: "ManageExpertise")
                self.displayErrorMessage(message: message)
                return
            }
            let message = "Sending Message".localized(in: "BrowseExpertsVC")
            self.displayProgress(message: message)
            let sendMessageInputModel = SendMessageInputModel.init(senderId: self.userId, receiverId: self.receiverId, message: textMessage.trimmingCharacters(in: .whitespacesAndNewlines))
            let APIDataManager : BrowseExpertListProtocols = BrowseExpertListApiDataManager()
            APIDataManager.sendMessage(data: sendMessageInputModel, callback:{(result) in
                print("result : ", result)
                switch result {
                case .Failure(let error):
                    self.onSendMessageFailed(error: error)
                    break
                    
                case .Success(let data as OTPOutputDomainModel):
                    self.onSendMessageSucceed(data: data)
                    break
                    
                default:
                    break
                }
            })
            //presenter?.notifyForgotPasswordButtonTapped()
            print("send email code")
            alertView.close()
        }
    }
    func createContainerView(message: NSString) -> UIView {
        let View=UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 280))
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 240, height: 30))
        label.text = message as String
        label.font =  UIFont(name: "Raleway-Medium", size: 18)
        label.textColor = UIColor.ExpertConnectBlack
        View.addSubview(label)
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: 246, y: 0, width: 44, height: 44)
        closeButton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        closeButton.backgroundColor = UIColor.white
        closeButton.setImage(UIImage(named: "cross_btn"), for: UIControlState.normal)
        closeButton.layer.cornerRadius = 3

        View.addSubview(closeButton)
        messageTextView = UITextView(frame: CGRect(x: 20, y: 55, width: 250.00, height: 200.00))
        messageTextView.backgroundColor = UIColor.white
        messageTextView.textColor = UIColor.ExpertConnectBlack
        messageTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        //messageTextView.text = "Write your message..."
        messageTextView.font = UIFont(name: "Raleway-Light", size: 18)
        //messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate=self;
        
        self.setExpertConnectTextViewTheme(textview: self.messageTextView)
        messageTextView.becomeFirstResponder()
        View.addSubview(messageTextView)
        return View;
    }
    
    func pressButton(button: UIButton) {
        // Do whatever you need when the button is pressed
        alertView.close()
    }
    
    func displayErrorMessageWithCallback(message: String) {
        self.showErrorMessage(message: message, callback: {
            self.alertView.show()
        })
    }
    
    // MARK: textview delegate
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.ExpertConnectBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            //            textView.text = "Write your message..."
            //            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 300
        let currentString: NSString = textView.text as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
    }
    
    // MARK: Send Message Response Methods
    func onSendMessageSucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
            self.view.endEditing(true)
            self.displaySuccessMessage(message: data.message)
            self.getMessageDetails()
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onSendMessageFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed To Send Message")
    }

    // MARK: Get Enquiry List API Response methods
    func onGetEnquiryListSucceeded(data: EnquiryViewOutputDomainModel) {
        self.dismissProgress()
        self.messagesArray = NSMutableArray.init(array: data.enquiryList as! [Any])
        
        //Reverse Array
        self.messagesArray = self.messagesArray.reversed() as! NSMutableArray
        print("messages Array : ", self.messagesArray)
        self.tableview.reloadData()
        noDataLabel.isHidden = self.messagesArray.count == 0 ? false : true
    }
    
    func onGetEnquiryListFailed(data: EnquiryViewOutputDomainModel) {
        self.dismissProgress()
        self.tableview.reloadData()
        //        self.displayErrorMessage(message: "No blog list found in the database")
        noDataLabel.isHidden = self.messagesArray.count == 0 ? false : true
    }

    // MARK: Get Message List API Response methods
    func onGetMessageListSucceeded(data: MessagesViewOutputDomainModel) {
        self.dismissProgress()
        self.sentArray = NSMutableArray.init(array: data.sent as! [Any])
        self.receivedArray = NSMutableArray.init(array: data.received as! [Any])
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.messagesArray = NSMutableArray.init(array: self.sentArray as! [Any])
        } else {
            self.messagesArray = NSMutableArray.init(array: self.receivedArray as! [Any])
        }
        //Reverse Array
        self.messagesArray = self.messagesArray.reversed() as! NSMutableArray
        print("messages Array : ", self.messagesArray)
        self.tableview.reloadData()
        noDataLabel.isHidden = self.messagesArray.count == 0 ? false : true
    }
    
    func onGetMessageListFailed(data: MessagesViewOutputDomainModel) {
        self.dismissProgress()
        self.tableview.reloadData()
        //        self.displayErrorMessage(message: "No blog list found in the database")
        noDataLabel.isHidden = self.messagesArray.count == 0 ? false : true
    }
    
    func onGetMessageListFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.tableview.reloadData()
        //        self.displayErrorMessage(message: "No blog list found in the database")
        noDataLabel.isHidden = self.messagesArray.count == 0 ? false : true
    }
    
    // MARK: Send Enquiry Response Methods
    func onSendEnquirySucceed(data:OTPOutputDomainModel) {
        self.dismissProgress()
        if data.status == true {
                self.view.endEditing(true)
            self.displaySuccessMessage(message: data.message)
        } else {
            self.displayErrorMessage(message: data.message)
        }
    }
    
    func onSendEnquiryFailed(error: EApiErrorType) {
        self.dismissProgress()
        self.displayErrorMessage(message: "Failed To Send Enquiry")
    }

    // MARK: Alert methods
    func displayErrorMessage(message: String) {
        self.showErrorMessage(message: message)
    }
    
    func displaySuccessMessage(message: String){
        self.showStylishSuccessMessage(message: message)
    }
}
