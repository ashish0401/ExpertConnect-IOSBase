//
//  UIViewController+NavigationItems.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 18/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import UIKit

private var homeViewDelegate: HomeVC?
private var browseViewDelegate: BrowseEnquiryVC?
private var searchBrowseViewDelegate: BrowseEnquiryVC?
private var manageExpertiseViewDelegate: ManageExpertiseView?
private var expertDetailsViewDelegate: ExpertDetailsVC?

extension UIViewController {
    func activateHamburgerIcon(delegate: HomeVC) {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "side_menu_btn")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onHamburgerMenuBarTapped))
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.ExpertConnectRed
        homeViewDelegate = delegate
    }
    
    func activateSearchIcon(delegate: BrowseEnquiryVC) {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_browse_enquiry")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onSearchMenuBarTapped))
        
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(rightButton)
            self.navigationItem.rightBarButtonItems = items
        } else {
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.ExpertConnectRed
        browseViewDelegate = delegate

    }

    func activateAddIcon(delegate: ManageExpertiseView) {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "add_btn")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onAddMenuBarTapped))
        
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(rightButton)
            self.navigationItem.rightBarButtonItems = items
        } else {
            self.navigationItem.rightBarButtonItem = rightButton
        }
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.ExpertConnectRed
        manageExpertiseViewDelegate = delegate
    }

    func activateTextualAddIcon(delegate: ExpertDetailsVC) {

        let addButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onTextualAddMenuBarTapped))
        addButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Raleway-Medium", size: 19)!], for: UIControlState.normal)
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(addButton)
            self.navigationItem.rightBarButtonItems = items
        } else {
            self.navigationItem.rightBarButtonItem = addButton
        }
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.ExpertConnectRed
        expertDetailsViewDelegate = delegate
    }

    func activateNotificationIcon() {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "notification_btn")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onNotificationMenuBarTapped))
        
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(rightButton)
            self.navigationItem.rightBarButtonItems = items
        } else {
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.ExpertConnectRed
    }

    func activatePromotionIcon() {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "promotion_btn")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onPromotionMenuBarTapped))
        
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(rightButton)
            self.navigationItem.rightBarButtonItems = items
        } else {
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.ExpertConnectRed
    }

    func activateBackIcon() {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_btn")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onBackMenuBarTapped))
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.ExpertConnectRed
    }

    func activateTextualCancelIcon() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onCancelMenuBarTapped))
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Raleway-Light", size: 19)!], for: UIControlState.normal)
        navigationItem.leftBarButtonItem = cancelButton
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.ExpertConnectRed

    }

    func activateSearchBrouseBackIcon(delegate: BrowseEnquiryVC) {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_btn")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onSearchBrouseBackMenuBarTapped))
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.ExpertConnectRed
        searchBrowseViewDelegate = delegate
    }

    func activateMyOrderIcon() {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "bag")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onMyOrderMenuBarTapped))
        
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(rightButton)
            self.navigationItem.rightBarButtonItems = items
        } else {
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.mezukaDark
    }
    
    func onHamburgerMenuBarTapped() {
        self.view.endEditing(true)
        homeViewDelegate?.menuLeft.show()
    }
    
    func onSearchMenuBarTapped() {
        if(browseViewDelegate?.selectedSegment == "First") {
        let searchBrowseObj : SearchBrowse = UIStoryboard(name: "SearchBrowse", bundle: nil).instantiateViewController(withIdentifier: "SearchBrowse") as UIViewController as! SearchBrowse
        searchBrowseObj.delegate = browseViewDelegate
        self.navigationController?.pushViewController(searchBrowseObj, animated: true)
        }
    }
    
    func onAddMenuBarTapped() {
        self.view.endEditing(true)
        let addExpertiseView : ExpertDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpertDetailsVC") as UIViewController as! ExpertDetailsVC
        addExpertiseView.isAddExpertise = true
        let navController = UINavigationController(rootViewController: addExpertiseView)
        self.present(navController, animated: true, completion: nil)
        addExpertiseView.modalTransitionStyle = UIModalTransitionStyle(rawValue: 0)!
    }

    func onNotificationMenuBarTapped() {
        self.view.endEditing(true)
    }
    
    func onPromotionMenuBarTapped() {
        self.view.endEditing(true)
    }

    func onBackMenuBarTapped() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    func onCancelMenuBarTapped() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    func onTextualAddMenuBarTapped() {
        self.view.endEditing(true)
        let button = expertDetailsViewDelegate?.nextButton
        expertDetailsViewDelegate?.nextButtonAction(button!)
    }

    func onSearchBrouseBackMenuBarTapped() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        searchBrowseViewDelegate?.searchBrouseBackMenuBarTapped()
    }

    func onMyOrderMenuBarTapped() {
      //  MenuWireFrame.sharedInstance.presentMyOrderView()
    }
}
