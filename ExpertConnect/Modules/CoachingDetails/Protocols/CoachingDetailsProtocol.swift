//
//  CoachingDetailsStudentProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol CoachingDetailsProtocol {
    func coachingDetails(endpoint: String, data: RegisterUserInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
}
