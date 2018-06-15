//
//  AddBlogViewApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class AddBlogViewApiDataManager: AddBlogViewProtocol {
    init() {}
    
    func addBlog(data: AddBlogViewInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "blog.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            let parameters = ["user_id" : data.userId, "category_id" : data.categoryId, "sub_category_id" : data.subCategoryId, "blog_title" : data.blogTitle, "blog_description" : data.blogDescription, "blog_url" : data.blogUrl, "blog_city" : data.blogCity, "command" : "addBlog"] as [String : Any]
            
            let apiConverter = AddBlogViewApiModelConverter()
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
}
