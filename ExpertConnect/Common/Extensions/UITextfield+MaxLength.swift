//
//  UITextfield+MaxLength.swift
//  ExpertConnect
//
//  Created by Nadeem on 08/12/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import UIKit
private var maxLengths = [UITextField: Int]()

// 2
extension UITextField {
    
    // 3
    @IBInspectable var maxLength: Int {
        get {
            // 4
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            // 5
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControlEvents.editingChanged
            )
        }
    }
    
    func limitLength(textField: UITextField) {
        // 6
        guard let prospectiveText = textField.text, prospectiveText.characters.count > maxLength else {
                return
        }
        
        let selection = selectedTextRange
        // 7
//        text = prospectiveText.substringWithRange(
//            Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.startIndex.advancedBy(maxLength))
//        )
        text = prospectiveText[prospectiveText.startIndex..<prospectiveText.index(prospectiveText.startIndex, offsetBy: (maxLength))]
        selectedTextRange = selection
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        
        return false
    }
}


