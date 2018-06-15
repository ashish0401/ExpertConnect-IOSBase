//
//  SendConfirmRejectDomainModel.swift
//  ExpertConnect
//
//  Created by Redbytes on 09/01/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
final class SendConfirmRejectDomainModel {
    
    var fromId: String = ""
    var toId: String = ""
    var type: String = ""
    var expertId: String = ""
    var categoryId: String = ""
    var subCategoryId: String = ""
    
    init(fromId: String, toId : String, type: String, expertId: String, categoryId:String, subCategoryId:String) {
        
        self.fromId = fromId
        self.toId = toId
        self.type = type
        self.expertId = expertId
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
    }
}
