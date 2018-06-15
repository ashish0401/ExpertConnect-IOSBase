//
//  BlogRatingInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class TeacherRatingInputDomainModel {
    var teacherId: String = ""
    var expertId: String = ""
    var ratedBy: String = ""
    var rating: String = ""
    
    init(teacherId: String, expertId: String, ratedBy : String, rating : String) {
        self.teacherId = teacherId
        self.expertId = expertId
        self.ratedBy = ratedBy
        self.rating = rating
    }
}
