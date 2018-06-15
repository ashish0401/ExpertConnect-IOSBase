//
//  AddCategoryViewProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol AddCategoryViewProtocol {
    func addCategory(data: AddCategoryViewInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
}
