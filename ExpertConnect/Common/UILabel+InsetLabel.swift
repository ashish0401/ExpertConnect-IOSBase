//
//  UILabel+ InsetLabel.swift
//  Mezuka
//
//  Created by Supriya on 17/10/16.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import UIKit

extension UILabel {
    
    func drawTextInRect(rect: CGRect) {
//        drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)))
        drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)))
    }
    
}
