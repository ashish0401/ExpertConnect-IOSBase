//
//  UIViewController+NavigationItems.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 18/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func activateHamburgerIcon() {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Hamburger")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onHamburgerMenuBarTapped))
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.mezukaDark
    }
    
    func activateSearchIcon() {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "search")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onSearchMenuBarTapped))
        
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(rightButton)
        } else {
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.mezukaDark
    }
    
    func activateMyOrderIcon() {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "bag")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onMyOrderMenuBarTapped))
        
        if var items = self.navigationItem.rightBarButtonItems {
            items.append(rightButton)
        } else {
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.mezukaDark
    }
    
    func onHamburgerMenuBarTapped() {
       // MenuWireFrame.sharedInstance.openMenu()
    }
    
    func onSearchMenuBarTapped() {
       // MenuWireFrame.sharedInstance.navigateToSearchView()
    }
    
    func onMyOrderMenuBarTapped() {
      //  MenuWireFrame.sharedInstance.presentMyOrderView()
    }
}
