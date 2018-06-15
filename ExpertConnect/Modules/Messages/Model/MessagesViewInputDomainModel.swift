//
//  MessagesViewInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class MessagesViewInputDomainModel {
    var userId: String = ""
    var command: String = ""
    var urlEndPoint: String = ""

    init(userId: String, command: String, urlEndPoint: String) {
        self.userId = userId
        self.command = command
        self.urlEndPoint = urlEndPoint
    }
}
