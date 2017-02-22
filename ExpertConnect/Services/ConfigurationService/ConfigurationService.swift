//
//  ConfigurationService.swift
//  ExpertConnect
//
//  Created by Redbytes on 22/09/2016.
//  Copyright © 2016 ExpertConnect. All rights reserved.
//

import Foundation
import Alamofire

class ConfigurationService: ConfigurationServiceProtocol {
    static let api: ApiServiceProtocol = ApiService()
    static let apiConverter = ConfigurationApiModelConverter()
    static let csrfTokenKey = "csrf-token"

    static func getAppConfiguration() throws {
        let url = try self.api.constructApiEndpoint(base: "https://mezuka.com", params: "api", "config")
        let header = try self.api.constructHeader(withCsrfToken: false, cookieDictionary: nil)

        api.get(url: url, headers: header, converter: { (json) -> AnyObject in
            return apiConverter.fromJson(json: json) as Config}) { (result) in
            switch result {
            
            case .Failure(_):
                break
            
            case .Success(let model as Config):
                print(model.countries)
                print(model.googleMapKey)
                
            default:
                break
            }
        }
    }
    
    static func getInitialCookies() throws {
        let url = try self.api.constructApiEndpoint(base: "https://mezuka.com", params: "/")
        let header = try self.api.constructHeader(withCsrfToken: false, cookieDictionary: [:])
        
        api.getCookies(url: url, headers: header)
    }
    
    static func getCurrentLocation() -> String {
        return "%7B%22formatted_address%22%3A%2231+Dulancey+Ct%2C+Staten+Island%2C+NY+10301%2C+USA%22%2C%22country%22%3A%22United+States%22%2C%22country_code%22%3A%22US%22%2C%22state%22%3A%22New+York%22%2C%22state_code%22%3A%22NY%22%2C%22city%22%3A%22%22%2C%22address1%22%3A%2231+Dulancey+Court%22%2C%22zipcode%22%3A%2210301%22%2C%22latitude%22%3A40.63436%2C%22longitude%22%3A-74.07777499999997%2C%22time_zone%22%3A%22America%2FNew_York%22%2C%22street_number%22%3A%2231%22%2C%22street%22%3A%22Dulancey+Court%22%7D"
    }
}
