//
//  TeacherFilterProtocols.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
protocol TeacherFilterProtocols {
    
    func getTeacherFilterList(data:TeacherFilterDomainModel,callback: @escaping (ECallbackResultType) -> Void)
}
