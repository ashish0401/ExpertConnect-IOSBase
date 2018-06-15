//
//  ManageExpertiseProtocols.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol ManageExpertiseProtocols {
    func getMyExpertiseDetails(model: ManageExpertiseDomainModel, callback: @escaping (ECallbackResultType) -> Void)
}
