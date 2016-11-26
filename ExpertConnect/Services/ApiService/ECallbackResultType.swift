//
//  ECallbackResultType.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 04/01/16.
//  Copyright © 2016 Kinetica. All rights reserved.
//

import Foundation

public enum ECallbackResultType {
    case Success(Any?)
    case Failure(EApiErrorType)
}
