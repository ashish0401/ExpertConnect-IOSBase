//
//  NSDate+Locale.swift
//  ExpertConnect
//
//  Created by Nadeem on 06/12/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

extension Date {
    func ToLocalStringWithFormat(dateFormat: String) -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: self)
        
        return timeStamp
    }
}
