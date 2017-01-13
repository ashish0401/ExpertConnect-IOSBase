//
// Created by hhtopcu.
// Copyright (c) 2016 hhtopcu. All rights reserved.
//

import Foundation

/** Use Object Mapper */
final class BrowseEnquiryReceivedNotificationDomainModel {
    var userId: String = ""
    var categoryId: String = ""
    var subCategoryId: String = ""
    var isFilter: String = ""
    var ammount: String = ""
    
    init(userId: String, categoryId: String, subCategoryId: String, isFilter: String, ammount: String) {
        self.userId = userId
        self.subCategoryId = subCategoryId
        self.categoryId = categoryId
        self.isFilter = isFilter
        self.ammount = ammount
    }
}
