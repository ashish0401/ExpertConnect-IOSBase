//
//  AddBlogViewProtocol.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol BlogViewProtocol {
    func getBlogList(data: BlogViewInputDomainModel,  callback: @escaping (ECallbackResultType) -> Void)
}
