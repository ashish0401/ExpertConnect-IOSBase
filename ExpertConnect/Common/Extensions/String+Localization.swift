//
//  String+Localization.swift
//  ExpertConnect
//
//  Created by Ramesh.M on 06/12/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(with comment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
    
    func localized(in table:String) -> String {
        return NSLocalizedString(self, tableName: table, bundle: Bundle.main, value: "", comment: "")
    }
}
