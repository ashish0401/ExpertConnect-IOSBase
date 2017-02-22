//
//  AddressService.swift
//  ExpertConnect
//
//  Created by Redbytes on 12/10/2016.
//  Copyright © 2016 ExpertConnect. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MapKit
import SwiftyJSON

class AddressService: AddressServiceProtocol {
    private let addressEntityName = "Address"
    private let mObjectContext : NSManagedObjectContext
    
    /** Columns */
    private let keyStreetColumn = "street"
    private let keyCityColumn = "city"
    private let keyZipCodeColumn = "zipcode"
    private let keyCountryColumn = "country"
    private let keyLatitudeColumn = "latitude"
    private let keyLongitudeColumn = "longitude"
    private let keyTypeColumn = "type" // 0: Stored, 1: Recent
    private let keyCreatedAtColumn = "createdAt"
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate   
        mObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    /**
     This method converts entity data to address model and returns back the result
     - parameters:
        - data: Entity data
     - returns: Address model stored in local storage
     */
    private func getAddresses(forType type: EAddressType, limit: Int = -1) -> [AddressModel] {
        var addresses : [AddressModel] = []
        
        // To fetch all data in sorted
        let sectionSortDescriptor = NSSortDescriptor(key: self.keyCreatedAtColumn, ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        
        // Entity: Address
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.addressEntityName)
        let predicate = NSPredicate(format: "type == \(type.rawValue)")
        
        // Apply sorting according to creatin time
        request.sortDescriptors = sortDescriptors
        
        if(limit > 0) {
            request.fetchLimit = limit
        }
        
        // Apply filtering to fetch only recent addresses
        request.predicate = predicate
        
        // Fetch Addresses from CoreData
        do {
            let results = try mObjectContext.fetch(request) as! [NSManagedObject]
            
            for record in results {
                let street = record.value(forKey: self.keyStreetColumn) as! String
                let city = record.value(forKey: self.keyCityColumn) as! String
                let zipcode = record.value(forKey: self.keyZipCodeColumn) as! String
                let country = record.value(forKey: self.keyCountryColumn) as! String
                let latitude = record.value(forKey: self.keyLatitudeColumn) as! Double
                let longitude = record.value(forKey: self.keyLongitudeColumn) as! Double
                let id: NSManagedObjectID = record.objectID
                
                let model : AddressModel = AddressModel(street: street, city: city, zipcode: zipcode, country: country, latitude: latitude, longitude: longitude)
                model.setObjectId(id: id)
                
                addresses.append(model)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return addresses
    }
    
    private func addAddress(address: AddressModel, to type:EAddressType) -> Bool {
        var retval : Bool = false
        
        // Save
        do {
            
            // Get address table
            let entity =  NSEntityDescription.entity(forEntityName: self.addressEntityName, in: mObjectContext)
            let addressTable = NSManagedObject(entity: entity!, insertInto: mObjectContext)
            
            // Assign
            addressTable.setValue(address.street, forKey: self.keyStreetColumn)
            addressTable.setValue(address.city, forKey: self.keyCityColumn)
            addressTable.setValue(address.zipcode, forKey: self.keyZipCodeColumn)
            addressTable.setValue(address.country, forKey: self.keyCountryColumn)
            addressTable.setValue(address.latitude, forKey: self.keyLatitudeColumn)
            addressTable.setValue(address.longitude, forKey: self.keyLongitudeColumn)
            addressTable.setValue(type.rawValue, forKey: self.keyTypeColumn)
            addressTable.setValue(NSDate(), forKey: self.keyCreatedAtColumn) // Add current timestamp
            
            // No return type
            try mObjectContext.save()
            
            // So the result is true
            retval = true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return retval
    }
    
    func getRecentAddresses() -> [AddressModel] {
        return getAddresses(forType: .recent)
    }
    
    func getTopRecentAddresses() -> [AddressModel] {
        return getAddresses(forType: .recent, limit: 5)
    }
    
    func getStoredAddresses() -> [AddressModel] {
        return getAddresses(forType: .stored)
    }
    
    func getTopStoredAddresses() -> [AddressModel] {
        return getAddresses(forType: .stored, limit: 5)
    }
    
    func addToRecentAddresses(address: AddressModel) -> Bool {
        return self.addAddress(address: address, to: .recent)
    }
    
    func addToStoredAddresses(address: AddressModel) -> Bool {
        return self.addAddress(address: address, to: .stored)
    }
    
    func deleteStoredAddress(address: AddressModel) -> Bool {
        do {
            let id = try address.getObjectId()!
            let object = mObjectContext.object(with: id)
            try mObjectContext.delete(object)
        } catch {
            return false
        }
        
        return true
    }
    
    func updateStoredAddress(address: AddressModel) -> Bool {
        do {
            let id = address.getObjectId()!
            let object = mObjectContext.object(with: id)
            
            object.setValue(address.street, forKey: self.keyStreetColumn)
            object.setValue(address.city, forKey: self.keyCityColumn)
            object.setValue(address.zipcode, forKey: self.keyZipCodeColumn)
            object.setValue(address.country, forKey: self.keyCountryColumn)
            object.setValue(address.latitude, forKey: self.keyLatitudeColumn)
            object.setValue(address.longitude, forKey: self.keyLongitudeColumn)
            object.setValue(EAddressType.recent.rawValue, forKey: self.keyTypeColumn)
            
            try object.managedObjectContext?.save()
            
            return true
        } catch {
            let saveError = error as NSError
            print(saveError)
        }

        return false
    }
    
    /**
     This method provides to fetch related addresses related to the query typed by the user
     - parameters:
        - query: user address query
        - callback: The found address(es) will be passed to that callback function
     */
    func fetchAddressFromMap(query: String, callback: @escaping ([AddressModel]) -> ()) {
        // Create a local search request
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        
        // Start to search
        search.start { (response, error) -> Void in
            
            // The address array to be passed
            var addresses: [AddressModel] = []
            
            if error != nil {
                // If error exist
                print("Error occured in search: \(error!.localizedDescription)")
            } else {
                
                if (response!.mapItems.count > 0) {
                    // Iterate over the found map items
                    for item in response!.mapItems {
                        
                        // Get categorical data
                        let info = (item.placemark.addressDictionary as NSDictionary!)!
                        
                        let address = (item.placemark.name != nil ? item.placemark.name! : "")
                        let city: String! = ((info["City"] != nil) ? info["City"] :  "") as! String
                        let country: String! = ((info["Country"] != nil) ? info["Country"] : "") as! String
                        let zip: String! = ((info["ZIP"] != nil) ? info["ZIP"] : "") as! String
                        let latitude = item.placemark.location?.coordinate.latitude
                        let longitude = item.placemark.location?.coordinate.longitude
                        let formatted: [String] = ((info["FormattedAddressLines"] != nil) ? info["FormattedAddressLines"] :  []) as! [String]
                        let state: String = ((info["State"] != nil) ? info["State"] :  "") as! String
                        let stateCode: String = ((info["State"] != nil) ? info["State"] :  "") as! String
                        let street: String = ((info["Street"] != nil) ? info["Street"] : "") as! String
                        let streetNumber: String = ((info["SubThoroughfare"] != nil) ? info["SubThoroughfare"] : "") as! String
                        let countryCode: String  = ((info["CountryCode"] != nil) ? info["CountryCode"] :  "") as! String

                        // Construct address model
                        let model : AddressModel = AddressModel(street: address, city: city, zipcode: zip, country: country, latitude: latitude!, longitude: longitude!)
                        model.countryCode = countryCode
                        model.streetNumber = streetNumber
                        model.state = state
                        model.stateCode = stateCode
                        model.street = street
                        model.address = formatted.joined(separator: ", ")
                        model.formattedAddress = formatted.joined(separator: ", ")
                        model.timeZone = "America/New_York" // Default
                        
                        // Add the address to the array
                        addresses.append(model)
                    }
                }
                
                // Call callback and pass addresses found
                callback(addresses)
            }
        }
    }
    
    /**
     This method returns a api compatible formatted adress
     - parameters:
        - address: address to be formatted
     - returns: formatted address
         {
             "formatted_address":"31+Dulancey+Ct,+Staten+Island,+NY+10301,+USA",
             "country":"United+States",
             "country_code":"US",
             "state":"New+York",
             "state_code":"NY",
             "city":"",
             "address1":"31+Dulancey+Court",
             "zipcode":"10301",
             "latitude":40.63436,
             "longitude":-74.07777499999997,
             "time_zone":"America/New_York",
             "street_number":"31",
             "street":"Dulancey+Court"
         }
     */
    func getFormattedAddressJson(address: AddressModel) -> String {
        var retval = ""
        
        let json: JSON =  [
            "formatted_address": "\(address.city.replacingOccurrences(of: " ", with: "+"))",
            "country": "\(address.country.replacingOccurrences(of: " ", with: "+"))",
            "country_code": "\(address.countryCode.replacingOccurrences(of: " ", with: "+"))",
            "state": "\(address.state.replacingOccurrences(of: " ", with: "+"))",
            "state_code": "\(address.stateCode.replacingOccurrences(of: " ", with: "+"))",
            "city": "\(address.city.replacingOccurrences(of: " ", with: "+"))",
            "address1": "\(address.address.replacingOccurrences(of: " ", with: "+"))",
            "zipcode": "\(address.zipcode)",
            "latitude": address.latitude,
            "longitude": address.longitude,
            "time_zone": "\(address.timeZone.replacingOccurrences(of: " ", with: "+"))",
            "street_number": "\(address.streetNumber)",
            "street": "\(address.street.replacingOccurrences(of: " ", with: "+"))"
        ]
        
        retval = json.description.replacingOccurrences(of: " ", with: "") // Remove whitespaces
        retval = retval.replacingOccurrences(of: "\n", with: "") // Remove newlines
        retval = retval.replacingOccurrences(of: "{", with: "%7B")
        retval = retval.replacingOccurrences(of: "}", with: "%7D")
        retval = retval.replacingOccurrences(of: "\"", with: "%22")
        retval = retval.replacingOccurrences(of: ":", with: "%3A")
        retval = retval.replacingOccurrences(of: ",", with: "%2C")
        
        return retval
    }
}
