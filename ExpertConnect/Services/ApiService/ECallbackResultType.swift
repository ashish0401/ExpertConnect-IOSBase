//
//  ECallbackResultType.swift
//  ExpertConnect
//
//  Created by Redbytes on 04/01/16.
//  Copyright © 2016 ExpertConnect. All rights reserved.
//

import Foundation

public enum ECallbackResultType {
    case Success(Any?)
    case Failure(EApiErrorType)
}
