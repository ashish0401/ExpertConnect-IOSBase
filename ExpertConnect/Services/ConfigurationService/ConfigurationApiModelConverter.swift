//
//  ConfigurationApiModelConverter.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 20/10/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation
import SwiftyJSON

class ConfigurationApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
        - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> Config {
        let googleMapKey = json["google_map_key"].stringValue
        let countries = self.fromJson(countryJson: json["countries"].dictionaryValue)
        
        // Form the model to be sent
        let model: Config = Config()
        model.googleMapKey = googleMapKey
        model.countries = countries
        
        return model
    }
    
    func fromJson(countryJson: [String: JSON]) -> [String: Country] {
        var model: [String: Country] = [:]
        
        for (key, value) in countryJson {
            if(model[key] == nil) {
                let name = value["name"].stringValue
                let code = value["code"].stringValue
                model[key] = Country(name: name, code: code)
            }
        }
        
        return model
    }
}
