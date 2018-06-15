//
//  AddBlogViewProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol AddPromotionViewProtocol {
    func addPromotion(data: AddPromotionViewInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
    func getMyCategoryDetails(model: MyCategoryDomainModel, callback: @escaping (ECallbackResultType) -> Void)
}
