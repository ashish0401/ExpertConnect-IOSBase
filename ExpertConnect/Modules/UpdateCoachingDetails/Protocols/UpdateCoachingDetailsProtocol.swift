//
//  UpdateCoachingDetailsProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol UpdateCoachingDetailsProtocol {
    func updateCoachingDetails(data: UpdateCoachingDetailsInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
    func getCoachingDetails(data: UpdateCoachingDetailsInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) 
}
