//
//  AddBlogViewApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class AddPromotionViewApiDataManager: AddPromotionViewProtocol {
    init() {}
    
    func addPromotion(data: AddPromotionViewInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            // @@@Vikas
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "add_promotion.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            let parameters = [
                                "teacher_id":data.teacherId,
                                "category_id":data.categoryId,
                                "sub_category_id":data.subCategoryId,
                                "base_price":data.basePrice,
                                "discount_price":data.discountPrice,
                                "offer_date":data.offerDate,
                                "description":data.description,
                                "location":data.location,
                                "blog_url":data.blogUrl,
                                "command":"addPromotion"
                            ] as [String : Any]
            
            let apiConverter = AddPromotionViewApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> AnyObject in
                                        return apiConverter.fromResetPasswordJson(json: json) as OTPOutputDomainModel},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
    
    func getMyCategoryDetails(model: MyCategoryDomainModel, callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "my_expert_list.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["user_id" : model.userId as AnyObject] as [String: AnyObject]
            
            let apiConverter = MyCategoryApiModelConverter()
            
            api.create(url,
                       parameters: parameters as [String : AnyObject]?,
                       headers: headers, converter: { (json) -> AnyObject in
                        return apiConverter.fromJson(json: json) as MyCategoryOutputDomainModel},
                       callback: callback)
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
