//
//  AddressModel.swift
//  ExpertConnect
//
//  Created by Redbytes on 12/10/2016.
//  Copyright © 2016 ExpertConnect. All rights reserved.
//

import Foundation
import CoreData

class AddressModel {
    private var id: NSManagedObjectID? = nil
    var zipcode: String = ""
    var country: String = ""
    var city: String = ""
    var street: String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    // Extra
    var address: String = ""
    var state: String = ""
    var stateCode: String = ""
    var countryCode: String = ""
    var formattedAddress: String = ""
    var streetNumber: String = ""
    var timeZone: String = ""
    
    init(street: String, city: String, zipcode: String, country: String, latitude: Double, longitude: Double) {
        self.street = street
        self.city = city
        self.zipcode = zipcode
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func setObjectId(id: NSManagedObjectID?) {
        self.id = id
    }
    
    func getObjectId() -> NSManagedObjectID? {
        return self.id
    }
}
