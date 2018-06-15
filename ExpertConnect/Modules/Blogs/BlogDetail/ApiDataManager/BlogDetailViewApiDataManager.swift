//
//  AddBlogViewApiDataManager.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import SwiftyJSON

final class BlogDetailViewApiDataManager: BlogDetailViewProtocol {
    init() {}
    
    func addReview(data: BlogRatingInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void) {
        do {
            let api: ApiServiceProtocol = ApiService()
            let url: String = try api.constructApiEndpoint(base: "http://114.143.177.218/expert_connect", params: "blog.php")
            let headers = try api.constructHeader(withCsrfToken: true, cookieDictionary: nil)
            
            var parameters = ["command" : data.command as AnyObject] as [String: AnyObject]
            if data.command == "deleteBlogByBlogId" {
                parameters["user_id"] = data.userId as String? as AnyObject?
                parameters["blog_id"] = data.blogId as String? as AnyObject?
                
            } else if data.command == "rateAndCommentBlog" {
                parameters["commented_by"] = data.userId as String? as AnyObject?
                parameters["blog_id"] = data.blogId as String? as AnyObject?
                parameters["rating"] = data.rating as String? as AnyObject?
                parameters["comments"] = data.review as String? as AnyObject?
            }

            let apiConverter = BlogDetailViewApiModelConverter()
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
