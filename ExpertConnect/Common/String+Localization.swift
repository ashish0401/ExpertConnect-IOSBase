//
//  String+Localization.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 02/10/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
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
