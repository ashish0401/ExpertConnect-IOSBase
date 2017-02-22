//
//  HomeProtocols.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol HomeProtocols {
    func getCategoryDetails(callback: @escaping (ECallbackResultType) -> Void)
}
