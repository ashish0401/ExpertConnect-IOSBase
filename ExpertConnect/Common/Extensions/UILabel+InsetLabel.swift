//
//  UILabel+ InsetLabel.swift
//  ExpertConnect
//
//  Created by Ramesh.M on 06/12/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

extension UILabel {
    
    func drawTextInRect(rect: CGRect) {
//        drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)))
        drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)))
    }
    
}
