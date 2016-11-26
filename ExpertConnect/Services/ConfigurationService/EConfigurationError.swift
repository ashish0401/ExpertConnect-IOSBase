//
//  EConfigurationError.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 22/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation

public enum EConfigurationError: Error {
    case UnknownError
    case ConfigEndpointNotAvailable    // The API endpoint is not available
}
