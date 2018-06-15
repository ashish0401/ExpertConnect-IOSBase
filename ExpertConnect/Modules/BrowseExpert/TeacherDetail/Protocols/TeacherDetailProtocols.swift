//
//  BrowseExpertListProtocols.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
protocol TeacherDetailProtocols {
    func addReview(data: TeacherRatingInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
}
