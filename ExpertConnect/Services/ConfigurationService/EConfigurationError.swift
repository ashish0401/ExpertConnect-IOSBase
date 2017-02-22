//
//  EConfigurationError.swift
//  ExpertConnect
//
//  Created by Redbytes on 22/09/2016.
//  Copyright © 2016 ExpertConnect. All rights reserved.
//

import Foundation

public enum EConfigurationError: Error {
    case UnknownError
    case ConfigEndpointNotAvailable    // The API endpoint is not available
}
