//
//  ApiServiceTests.swift
//  Mezuka
//
//  Created by Hasan H. Topcu on 21/09/2016.
//  Copyright © 2016 Mezuka. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Mezuka

class ApiServiceTests: XCTestCase {
    // system under test
    var sut: ApiServiceProtocol!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ApiService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApiEndpointConstruction() {
        do {
            let endpoint1 = try sut.constructApiEndpoint(base: "http://api.mezuka.com", params: "endpoint1")
            let endpoint2 = try sut.constructApiEndpoint(base: "http://api.mezuka.com", params: "/endpoint1")
            let endpoint3 = try sut.constructApiEndpoint(base: "http://api.mezuka.com", params: "endpoint1/")
            let endpoint4 = try sut.constructApiEndpoint(base: "http://api.mezuka.com", params: "/endpoint1/")
            let endpoint5 = try sut.constructApiEndpoint(base: "http://api.mezuka.com/", params: "endpoint2", "A123DA039SJ233NA2")
            let endpoint6 = try sut.constructApiEndpoint(base: "http://api.mezuka.com/", params: "endpoint2", "/A123DA039SJ233NA2")
            let endpoint7 = try sut.constructApiEndpoint(base: "http://api.mezuka.com/", params: "/endpoint2", "A123DA039SJ233NA2")
            let endpoint8 = try sut.constructApiEndpoint(base: "http://api.mezuka.com/", params: "/endpoint2", "/A123DA039SJ233NA2")
            let endpoint9 = try sut.constructApiEndpoint(base: "http://api.mezuka.com/", params: "/endpoint2", "/A123DA039SJ233NA2/")
            let endpoint10 = try sut.constructApiEndpoint(base: "http://api.mezuka.com/", params: "/endpoint2", "/A123DA039SJ233NA2/")
            
            XCTAssertEqual(endpoint1, "http://api.mezuka.com/endpoint1")
            XCTAssertEqual(endpoint2, "http://api.mezuka.com/endpoint1")
            XCTAssertEqual(endpoint3, "http://api.mezuka.com/endpoint1")
            XCTAssertEqual(endpoint4, "http://api.mezuka.com/endpoint1")
            XCTAssertEqual(endpoint5, "http://api.mezuka.com/endpoint2/A123DA039SJ233NA2")
            XCTAssertEqual(endpoint6, "http://api.mezuka.com/endpoint2/A123DA039SJ233NA2")
            XCTAssertEqual(endpoint7, "http://api.mezuka.com/endpoint2/A123DA039SJ233NA2")
            XCTAssertEqual(endpoint8, "http://api.mezuka.com/endpoint2/A123DA039SJ233NA2")
            XCTAssertEqual(endpoint9, "http://api.mezuka.com/endpoint2/A123DA039SJ233NA2")
            XCTAssertEqual(endpoint10, "http://api.mezuka.com/endpoint2/A123DA039SJ233NA2")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateCookieString() {
        let cookie1 = sut.updateCookieString(cookie: "...mezuka_location=oldaddress;...", withKey: "mezuka_location", withValue: "newaddress")
        let cookie2 = sut.updateCookieString(cookie: "mezuka_location=oldaddress;...", withKey: "mezuka_location", withValue: "newaddress")
        let cookie3 = sut.updateCookieString(cookie: "...mezuka_location=oldaddress;", withKey: "mezuka_location", withValue: "newaddress")
        let cookie4 = sut.updateCookieString(cookie: "mezuka_location=oldaddress;", withKey: "mezuka_location", withValue: "newaddress")
        let cookie5 = sut.updateCookieString(cookie: "...mezuka_location=oldoldaddress;...", withKey: "mezuka_location", withValue: "newaddress")
        let cookie6 = sut.updateCookieString(cookie: "......", withKey: "mezuka_location", withValue: "newaddress")
        
        XCTAssertEqual(cookie1, "...mezuka_location=newaddress;...")
        XCTAssertEqual(cookie2, "mezuka_location=newaddress;...")
        XCTAssertEqual(cookie3, "...mezuka_location=newaddress;")
        XCTAssertEqual(cookie4, "mezuka_location=newaddress;")
        XCTAssertEqual(cookie5, "...mezuka_location=newaddress;...")
        XCTAssertEqual(cookie6, "mezuka_location=newaddress; ......")
    }
    
    func testApiEndpointConstruction_WithEmptyParameter() {
        do {
            _ = try sut.constructApiEndpoint(base: "http://api.mezuka.com", params: "")
            
            XCTFail()
            
        } catch EApiErrorType.InvalidParameters {
            
        } catch {
            XCTFail()
        }
    }
    
    func testApiEndpointConstruction_WithSecondEmptyParameter() {
        do {
            _ = try sut.constructApiEndpoint(base: "http://api.mezuka.com", params: "endpoint", "")
            
            XCTFail()
            
        } catch EApiErrorType.InvalidParameters {
            
        } catch {
            XCTFail()
        }
    }
    
    func testApiEndpointConstruction_WithFirstEmptyParameter() {
        do {
            _ = try sut.constructApiEndpoint(base: "http://api.mezuka.com", params: "", "endpoint")
            
            XCTFail()
            
        } catch EApiErrorType.InvalidParameters {
            
        } catch {
            XCTFail()
        }
    }
    
    /**
     Test get request [integration test]
     */
    func testGetRequest_WithAvailableRemoteEndpoint() {
        do {
            let headers = try sut.constructHeader(withCsrfToken: false, cookieDictionary: nil)
            let url = "https://httpbin.org/get"
            let converter: ((JSON) -> AnyObject)? = {_ in return 0 as AnyObject }
            
            let expect = expectation(description: "get request")
            sut.get(url: url, headers: headers, converter: converter) { (result) -> Void in
                switch (result) {
                case .Success(_): break
                case .Failure(_): XCTFail()
                }
                
                expect.fulfill()
            }
        } catch {
            
        }
        
        // Wait Async operation to be completed
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    /**
     Test get request [integration test]
     */
    func testGetRequest_WithNonAvailableRemoteEndpoint() {
        do {
            let headers = try sut.constructHeader(withCsrfToken: false, cookieDictionary: nil)
            let url = "https://httpbin.org/get_non_available"
            let converter: ((JSON) -> AnyObject)? = {_ in return 0 as AnyObject }
            
            let expect = expectation(description: "get request")
            sut.get(url: url, headers: headers, converter: converter) { (result) -> Void in
                switch (result) {
                case .Success(_): XCTFail()
                case .Failure(_): break
                    
                }
                
                expect.fulfill()
            }
        } catch {
            
        }
        
        // Wait Async operation to be completed
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    /**
     Test create request [integration test]
     */
    func testCreateRequest_WithAvailableRemoteEndpoint() {
        do {
            let headers = try sut.constructHeader(withCsrfToken: false, cookieDictionary: nil)
            let url = "https://httpbin.org/post"
            let params = ["city": "Denizli", "action": "post"]
            let converter: ((JSON) -> AnyObject)? = {_ in return 0 as AnyObject }
            
            let expect = expectation(description: "post request")
            sut.create(url, parameters: params as [String : AnyObject]?, headers: headers, converter: converter) { (result) -> Void in
                switch (result) {
                case .Success(_): break
                case .Failure(_): XCTFail()
                }
                
                expect.fulfill()
            }
        } catch {
            
        }
        
        // Wait Async operation to be completed
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    /**
     Test create request [integration test]
     */
    func testCreateRequest_WithNonAvailableRemoteEndpoint() {
        do {
            let headers = try sut.constructHeader(withCsrfToken: false, cookieDictionary: nil)
            let url = "https://httpbin.org/post_non_available"
            let params = ["city": "Denizli", "action": "post"]
            let converter: ((JSON) -> AnyObject)? = {_ in return 0 as AnyObject }
            
            let expect = expectation(description: "post request")
            sut.create(url, parameters: params as [String : AnyObject]?, headers: headers, converter: converter) { (result) -> Void in
                switch (result) {
                case .Success(_): break
                case .Failure(_): XCTFail()   
                }
                
                expect.fulfill()
            }
        } catch {
            
        }
        
        // Wait Async operation to be completed
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    /**
     Test update request [integration test]
     */
    func testUpdateRequest_WithAvailableRemoteEndpoint() {
        do {
            let headers = try sut.constructHeader(withCsrfToken: false, cookieDictionary: nil)
            let url = "https://httpbin.org/put"
            let params = ["city": "Denizli", "action": "put"]
            
            let expect = expectation(description: "put request")
            sut.update(url: url, parameters: params, headers: headers) { (result) -> Void in
                switch (result) {
                case .Success(_): break
                case .Failure(_): XCTFail()
                }
                
                expect.fulfill()
            }
        } catch {
            
        }
        
        // Wait Async operation to be completed
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    /**
     Test update request [integration test]
     */
    func testUpdateRequest_WithNonAvailableRemoteEndpoint() {
        do {
            let headers = try sut.constructHeader(withCsrfToken: false, cookieDictionary: nil)
            let url = "https://httpbin.org/put_non_available"
            let params = ["city": "Denizli", "action": "put"]
            
            let expect = expectation(description: "put request")
            sut.update(url: url, parameters: params, headers: headers) { (result) -> Void in
                switch (result) {
                case .Success(_): XCTFail()
                case .Failure(_): break
                    
                }
                
                expect.fulfill()
            }
        } catch {
            
        }
        
        // Wait Async operation to be completed
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    /**
     Test delete request [integration test]
     */
    func testDeleteRequest_WithAvailableRemoteEndpoint() {
        do {
            let headers = try sut.constructHeader(withCsrfToken: false, cookieDictionary: nil)
            let url = "https://httpbin.org/delete"
            let params = ["city": "Denizli", "action": "delete"]
            
            let expect = expectation(description: "delete request")
            sut.delete(url: url, parameters: params, headers: headers) { (result) -> Void in
                switch (result) {
                case .Success(_): break
                case .Failure(_): XCTFail()
                }
                
                expect.fulfill()
            }
        } catch {
            
        }
        
        // Wait Async operation to be completed
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    /**
     Test delete request [integration test]
     */
    func testDeleteRequest_WithNonAvailableRemoteEndpoint() {
        do {
            let headers = try sut.constructHeader(withCsrfToken: false, cookieDictionary: nil)
            let url = "https://httpbin.org/delete_non_available"
            let params = ["city": "Denizli", "action": "delete"]
            
            let expect = expectation(description: "delete request")
            sut.delete(url: url, parameters: params, headers: headers) { (result) -> Void in
                switch (result) {
                case .Success(_): XCTFail()
                case .Failure(_): break
                }
                
                expect.fulfill()
            }
        } catch {
            
        }
        
        // Wait Async operation to be completed
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print(error)
            }
        }
    }
}
