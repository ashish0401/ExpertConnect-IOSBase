//
//  MyAssignmentProtocols.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol MyAssignmentProtocols {
    func getMyAssignmentDetails(model: MyAssignmentDomainModel, callback: @escaping (ECallbackResultType) -> Void)
}