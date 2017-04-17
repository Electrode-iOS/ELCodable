//
//  JSONTests.swift
//  Codable
//
//  Created by Brandon Sneed on 10/27/15.
//  Copyright © 2015 WalmartLabs. All rights reserved.
//

import XCTest
@testable import ELCodable

class JSONTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReadingFromJSON() {
        let json = JSON(bundleClass: ELCodableTests.self, filename: "jsontest_models.json")
        
        // types
        /*
        case Number
        case String
        case Bool
        case Array
        case Dictionary
        case Null
        case Unknown
        */

        XCTAssertTrue(json?["mystring"]?.type == .string)
        XCTAssertTrue(json?["decimalNumber"]?.type == .number)
        XCTAssertTrue(json?["bool"]?.type == .bool)
        XCTAssertTrue(json?["double"]?.type == .number)
        XCTAssertTrue(json?["int"]?.type == .number)
        XCTAssertTrue(json?["myarray1"]?.type == .array)
        XCTAssertTrue(json?["mydictionary"]?.type == .dictionary)
        XCTAssertTrue(json?["null"]?.type == .null)
    }
    
    func testWritingToJSON() {
        let dictData = ["key1": "value1", "key2": 1234] as [String : Any]
        let arrayData = ["1", "2", "3", "4"]
        let stringData = "true"
        let numberData = 123456789
        let nullData = NSNull()
        
        var json = JSON()
        json["stringData"] = JSON(stringData)
        json["numberData"] = JSON(numberData)
        json["arrayData"] = JSON(arrayData)
        json["dictData"] = JSON(dictData)
        json["nullData"] = JSON(nullData)
        
        print(json)
    }
    
    func testCollectionStuff() {
        let dictData = ["key1": "value1", "key2": 1234] as [String : Any]
        let arrayData = ["1", "2", "3", "4"]
        let stringData = "true"
        let numberData = 123456789
        
        var json = JSON()
        json["stringData"] = JSON(stringData)
        json["numberData"] = JSON(numberData)
        json["arrayData"] = JSON(arrayData)
        json["dictData"] = JSON(dictData)
        
        XCTAssertTrue(json["arrayData"]!.array! == JSON(arrayData).array!)
        XCTAssertTrue(json["dictData"]!.dictionary! == JSON(dictData).dictionary!)
    }
}
