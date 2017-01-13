//
//  SendRequestDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
final class SendRequestDomainModel {

    var fromId: String = ""
    var toId: String = ""
    var type: String = ""
    var expertId: String = ""
    init(fromId: String, toId : String, type: String, expertId: String ) {
        
        self.fromId = fromId
        self.toId = toId
        self.type = type
        self.expertId = expertId
    }
}
