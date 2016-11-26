//
//  AddressServiceTests.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 12/10/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import XCTest
import UIKit
import CoreData
@testable import Mezuka

class AddressServiceTests: XCTestCase {
    var sut: AddressServiceProtocol!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = AddressService()
        
        // Clean all records in Address entity before each test case run
        self.cleanUpAddressEntity()
    }
    
    private func cleanUpAddressEntity() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")
        
        // Fetch Addresses from CoreData
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let objectContext = appDelegate.persistentContainer.viewContext
            let results = try objectContext.fetch(request) as! [NSManagedObject]
            
            for record in results {
                objectContext.delete(record)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetRecentAddresses() {
        let address1 : AddressModel = AddressModel(street: "2127 sk.", city: "Ankara", zipcode: "06510", country: "Turkey", latitude: 1.0, longitude: 2.0)
        let address2 : AddressModel = AddressModel(street: "2127 sk.", city: "Ankara", zipcode: "06510", country: "Turkey", latitude: 1.0, longitude: 2.0)
        
        let result1 = sut.addToRecentAddresses(address: address1)
        let result2 = sut.addToRecentAddresses(address: address2)
        
        let resultsRecent = sut.getRecentAddresses()
        let resultsStored = sut.getStoredAddresses()
        
        XCTAssert(resultsRecent.count == 2)
        XCTAssert(resultsStored.count == 0)
    }
    
    func testAddRecentAddress() {
        do {
            let model : AddressModel = AddressModel(street: "2127 sk.", city: "Ankara", zipcode: "06510", country: "Turkey", latitude: 1.0, longitude: 2.0)
            
            // Save the address through persistency manager
            let result = sut.addToRecentAddresses(address: model)
            
            XCTAssertTrue(result)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let objectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")
            let results = try objectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            let street = results[0].value(forKey: "street") as! String
            let city = results[0].value(forKey: "city") as! String
            let zipcode = results[0].value(forKey: "zipcode") as! String
            let country = results[0].value(forKey: "country") as! String
            let latitude = results[0].value(forKey: "latitude") as! Double
            let longitude = results[0].value(forKey: "longitude") as! Double
            let type = results[0].value(forKey: "type") as! Int
            
            XCTAssertEqual(model.street, street)
            XCTAssertEqual(model.city, city)
            XCTAssertEqual(model.zipcode, zipcode)
            XCTAssertEqual(model.country, country)
            XCTAssertEqual(model.latitude, latitude)
            XCTAssertEqual(model.longitude, longitude)
            XCTAssertEqual(EAddressType.recent.rawValue, type)
            
        } catch _ as NSError {
            XCTFail()
        }
    }
    
    func testAddStoredAddress() {
        do {
            let model : AddressModel = AddressModel(street: "2127 sk.", city: "Ankara", zipcode: "06510", country: "Turkey", latitude: 1.0, longitude: 2.0)
            
            // Save the address through persistency manager
            let result = sut.addToStoredAddresses(address: model)
            
            XCTAssertTrue(result)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let objectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")
            let results = try objectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            let street = results[0].value(forKey: "street") as! String
            let city = results[0].value(forKey: "city") as! String
            let zipcode = results[0].value(forKey: "zipcode") as! String
            let country = results[0].value(forKey: "country") as! String
            let latitude = results[0].value(forKey: "latitude") as! Double
            let longitude = results[0].value(forKey: "longitude") as! Double
            let type = results[0].value(forKey: "type") as! Int
            
            XCTAssertEqual(model.street, street)
            XCTAssertEqual(model.city, city)
            XCTAssertEqual(model.zipcode, zipcode)
            XCTAssertEqual(model.country, country)
            XCTAssertEqual(model.latitude, latitude)
            XCTAssertEqual(model.longitude, longitude)
            XCTAssertEqual(EAddressType.stored.rawValue, type)
            
        } catch _ as NSError {
            XCTFail()
        }
    }
    
    func testDeleteStoredAddress() {
        let model : AddressModel = AddressModel(street: "2127 sk.", city: "Ankara", zipcode: "06510", country: "Turkey", latitude: 1.0, longitude: 2.0)
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let objectContext = appDelegate.persistentContainer.viewContext
            let entity =  NSEntityDescription.entity(forEntityName: "Address", in: objectContext)
            let addressTable = NSManagedObject(entity: entity!, insertInto: objectContext)
            
            // Assign
            addressTable.setValue(model.street, forKey: "street")
            addressTable.setValue(model.city, forKey: "city")
            addressTable.setValue(model.zipcode, forKey: "zipcode")
            addressTable.setValue(model.country, forKey: "country")
            addressTable.setValue(model.latitude, forKey: "latitude")
            addressTable.setValue(model.longitude, forKey: "longitude")
            addressTable.setValue(EAddressType.recent.rawValue, forKey: "type")
            addressTable.setValue(NSDate(), forKey: "createdAt") // Add current timestamp
            
            // Save the address
            try objectContext.save()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")
            let results = try objectContext.fetch(fetchRequest) as! [NSManagedObject]
            model.setObjectId(id: results[0].objectID)
            
            XCTAssertEqual(results.count, 1)
            
            let retval = sut.deleteStoredAddress(address: model)
            
            XCTAssert(retval == true)
            
            let resultsAfterDeletion = try objectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            XCTAssertEqual(resultsAfterDeletion.count, 0)
            
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateStoredAddress() {
        let model : AddressModel = AddressModel(street: "2127 sk.", city: "Ankara", zipcode: "06510", country: "Turkey", latitude: 1.0, longitude: 2.0)
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let objectContext = appDelegate.persistentContainer.viewContext
            let entity =  NSEntityDescription.entity(forEntityName: "Address", in: objectContext)
            let addressTable = NSManagedObject(entity: entity!, insertInto: objectContext)
            
            // update the entity
            addressTable.setValue(model.street, forKey: "street")
            addressTable.setValue(model.city, forKey: "city")
            addressTable.setValue(model.zipcode, forKey: "zipcode")
            addressTable.setValue(model.country, forKey: "country")
            addressTable.setValue(model.latitude, forKey: "latitude")
            addressTable.setValue(model.longitude, forKey: "longitude")
            addressTable.setValue(EAddressType.recent.rawValue, forKey: "type")
            addressTable.setValue(NSDate(), forKey: "createdAt") // Add current timestamp
            
            // Save the address
            try objectContext.save()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")
            let results = try objectContext.fetch(fetchRequest) as! [NSManagedObject]
            model.setObjectId(id: results[0].objectID)
            
            XCTAssertEqual(results.count, 1)
            
            // Update the model
            model.city = "Mountain View"
            model.zipcode = "95035"
            model.country = "USA"
            let retval = sut.updateStoredAddress(address: model)
            
            // it should update the address successfully
            XCTAssert(retval == true)
            
            let resultsAfterUpdate = try objectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            // The updated values should be the same as updated
            XCTAssertEqual(resultsAfterUpdate[0].value(forKey: "city") as! String, "Mountain View")
            XCTAssertEqual(resultsAfterUpdate[0].value(forKey: "zipcode") as! String, "95035")
            XCTAssertEqual(resultsAfterUpdate[0].value(forKey: "country") as! String, "USA")
            
        } catch {
            XCTFail()
        }
    }
    
    func testFetchAddressFromMapKit() {
        let expect = expectation(description: "fetch address from mapkit")
        sut.fetchAddressFromMap(query: "31 Dulancey Ct") { (results) in
            XCTAssert(results.count > 0)
            expect.fulfill()
        }
        
        // Wait Async operation to be completed
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func testGetFormattedAddressJson() {
        let model : AddressModel = AddressModel(street: "31 Dulancey Ct", city: "", zipcode: "10301", country: "United States", latitude: 40.63436, longitude: -74.07777499999997)
        let json = sut.getFormattedAddressJson(address: model)
        
        //print("A: \(ConfigurationService.getCurrentLocation())")
        //print("B: \(ConfigurationService.getCurrentLocation().removingPercentEncoding)")
        //print("C: \(json)")
        //print("D: \(json.addingPercentEncoding(withAllowedCharacters: CharacterSet.letters)!)")
        
        XCTAssert(json.isEmpty == false)
    }
}
