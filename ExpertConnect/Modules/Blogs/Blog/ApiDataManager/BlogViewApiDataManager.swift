//
//  AddBlogViewApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class BlogViewApiDataManager: BlogViewProtocol {
    init() {}
    
    func getBlogList(data: BlogViewInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "blog.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            var parameters = ["command" : data.command as AnyObject] as [String: AnyObject]
            if data.command == "getBlogList" {
                parameters["user_id"] = data.userId as String? as AnyObject?
                parameters["blog_city"] = data.blogCity as String? as AnyObject?

            } else if data.command == "getBlogById" {
                parameters["user_id"] = data.userId as String? as AnyObject?
            }
            
            let apiConverter = BlogViewApiModelConverter()
            api.createForgotPassword(url,
                                     parameters: parameters as [String : AnyObject]?,
                                     headers: headers, converter: { (json) -> Any in
                                        return apiConverter.fromJson(json: json) as [BlogViewOutputDomainModel]},
                                     callback: callback)
            
        } catch {
            // Change it with the real error
            callback(.Failure(.UnknownError))
        }
    }
}
