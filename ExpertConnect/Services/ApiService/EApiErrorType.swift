//
//  ECallbackErrorType.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 21/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation

public enum EApiErrorType: Error {
    case UnknownError
    case AlreadyExist               // Resource does already exist
    case NotExist                   // Resource does NOT exist
    case InvalidParameters          // The parameter(s) is/are invalid
    case InvalidCredentials         // Credentials are invalid
    case InternalError              // There's a server-side problem
    case AccessTokenTimeout         // Access Token for the user is timed out
    case APIEndpointNotAvailable    // The API endpoint is not available
    case InvalidCsrfToken           // Invalid Csrf Token (possibly not exist, or expired)
}
