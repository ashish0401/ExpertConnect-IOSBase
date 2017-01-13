//
//  Array+containsObject.swift
//  ExpertConnect
//
//  Created by Nadeem on 13/12/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
