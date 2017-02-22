//
//  SubCategoryProtocols.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol SubCategoryProtocols {
    func getSubCategoryDetails(model: SubCategoryDomainModel, callback: @escaping (ECallbackResultType) -> Void)
}
