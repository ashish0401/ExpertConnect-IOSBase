//
//  EHttpStatusCode.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 16/12/15.
//  Copyright © 2016 Kinetica. All rights reserved.
//

import Foundation

/// Resource: https://developer.yahoo.com/social/rest_api_guide/http-response-codes.html
public enum EHttpStatusCode : Int {
    case OK = 200                       // /GET or /DELETE (with body) result is successful
    case CREATED = 201                  // /POST or /PUT is successful
    case NOT_MODIFIED = 304             // If caching is enabled and etag matches with the server
    case BAD_REQUEST = 400              // Possibly the parameters are invalid
    case INVALID_CREDENTIAL = 401       // INVALID CREDENTIAL, possible invalid token
    case NOT_FOUND = 404                // The item you looked for is not found
    case CONFLICT = 409                 // Conflict - means already exist
    case AUTHENTICATION_EXPIRED = 419   // Expired
}
