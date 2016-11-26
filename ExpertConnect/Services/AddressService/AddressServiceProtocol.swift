//
//  AddressServiceProtocol.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 12/10/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import Foundation

protocol AddressServiceProtocol {
    /**
     This method gets all recent addresses user already searched for
     - returns: Fetch all addresses
     */
    func getRecentAddresses() -> [AddressModel]
    
    /**
     This method adds the given address to recent addresses
     - returns: the result if it is successfully saved
     */
    func addToRecentAddresses(address: AddressModel) -> Bool
    
    /**
     This method gets the top stored addresses
     - returns: Fetch all addresses
     */
    func getStoredAddresses() -> [AddressModel]
    
    /**
     This method adds the given address to stored addresses
     - returns: the result if it is successfully saved
     */
    func addToStoredAddresses(address: AddressModel) -> Bool
    
    /**
     This method gets the top recent addresses user already searched for
        - returns: Fetch max top-5 addresses
    */
    func getTopRecentAddresses() -> [AddressModel]
    
    /**
     This method gets the top stored addresses
     - returns: Fetch max top-5 addresses
     */
    func getTopStoredAddresses() -> [AddressModel]
    
    /**
     This method updates the given address using its internal id
     - returns: the result if it is successfully updated
     */
    func updateStoredAddress(address: AddressModel) -> Bool
    
    /**
     This method deletes the given address using its internal id
     - returns: the result if it is successfully deleted
     */
    func deleteStoredAddress(address: AddressModel) -> Bool
    
    /**
     This method provides to fetch related addresses related to the query typed by the user
     - parameters:
        - query: user address query
        - callback: The found address(es) will be passed to that callback function
     */
    func fetchAddressFromMap(query: String, callback: @escaping ([AddressModel]) -> ())
    
    /**
     This method returns a formatted JSON String
     - parameters:
        - address: type of AddressModel
     - returns: formatted address JSON String
    */
    func getFormattedAddressJson(address: AddressModel) -> String
}
