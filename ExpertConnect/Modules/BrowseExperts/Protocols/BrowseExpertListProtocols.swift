//
//  BrowseExpertListProtocols.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
protocol BrowseExpertListProtocols {
    
    func getBrowseExpertList(data:BrowseExpertListDomainModel,callback: @escaping (ECallbackResultType) -> Void)
}
