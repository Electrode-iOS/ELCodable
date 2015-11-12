//
//  JSONTests.swift
//  Codable
//
//  Created by Brandon Sneed on 10/27/15.
//  Copyright © 2015 theholygrail.io. All rights reserved.
//

import XCTest
@testable import THGCodable

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
        let json = JSON(bundleClass: THGCodableTests.self, filename: "jsontest_models.json")
        
        let v = NSDecimalNumber.maximumDecimalNumber()
        print(v)
        
        //let str = json?["mystring"]?.stringValue
        //let dbl = json?["double"]?.numberValue
        print(json?["mystring"]?.type, ",", json?["mystring"]?.string)
        print(json?["decimalNumber"]?.type, ",", json?["decimalNumber"]?.number)
        print(json?["decimalNumber"]?.type, ",", json?["decimalNumber"]?.string)
        print(json?["boolString"]?.type, ",", json?["boolString"]?.bool)
        print(json?["double"]?.type, ",", json?["double"]?.double)
        print(json?["double"]?.type, ",", json?["double"]?.string)
        
        //let b = NSNumber(float: 3.14)
        
        //print(b.numberValue)
    }
    
    func testWritingToJSON() {
        let dictData = ["key1": "value1", "key2": 1234]
        let arrayData = ["1", "2", "3", "4"]
        let stringData = "true"
        let numberData = 123456789
        
        var json = JSON()
        json["stringData"] = JSON(stringData)
        json["numberData"] = JSON(numberData)
        json["arrayData"] = JSON(arrayData)
        json["dictData"] = JSON(dictData)
        
        print(json)
    }
    
    func testCollectionStuff() {
        let dictData = ["key1": "value1", "key2": 1234]
        let arrayData = ["1", "2", "3", "4"]
        let stringData = "true"
        let numberData = 123456789
        
        var json = JSON()
        json["stringData"] = JSON(stringData)
        json["numberData"] = JSON(numberData)
        json["arrayData"] = JSON(arrayData)
        json["dictData"] = JSON(dictData)
        
        for (value) in json["arrayData"]!.array! {
            print(value)
        }
        
        for (key, value) in json["dictData"]!.dictionary! {
            print(key, value)
        }
    }
    
}
