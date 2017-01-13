//
//  TeacherListProtocols.swift
//  ExpertConnect
//
//  Created by Nadeem on 23/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
protocol TeacherListProtocols {
    
    func getTeacherList(data:TeacherListDomainModel,callback: @escaping (ECallbackResultType) -> Void)
}
