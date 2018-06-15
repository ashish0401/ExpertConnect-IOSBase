//
//  PromotionDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
final class PromotionDomainModel {

    var userId: String = ""
    var location: String = ""
    var command: String = ""

    init(userId: String, location : String, command: String) {
        self.userId = userId
        self.location = location
        self.command = command
    }
}


