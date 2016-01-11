//
//  THGCodableTests.swift
//  THGCodableTests
//
//  Created by Brandon Sneed on 11/12/15.
//  Copyright © 2015 theholygrail.io. All rights reserved.
//

import XCTest
@testable import THGCodable

enum TestIntEnum: Int, Decodable, Encodable {
    case Test1
    case Test2
    case Test3
    
    static func decode(json: JSON?) throws -> TestIntEnum {
        if let value = json?.int {
            return TestIntEnum(rawValue: value)!
        }
        throw DecodeError.Undecodable
    }
    
    func encode() throws -> JSON {
        return JSON(rawValue)
    }
}

struct SubModel {
    let aSubString: String
}

extension SubModel: Decodable {
    static func decode(json: JSON?) throws -> SubModel {
        return try SubModel(
            aSubString: json ==> "aSubString"
        )
    }
}

extension SubModel: Encodable {
    func encode() throws -> JSON {
        return try encodeToJSON([
            "aSubString1" <== aSubString
            ])
    }
}

struct TestModel {
    let aString: String
    let aFloat: Float
    let anInt: Int
    let aNumber: Decimal
    let anArray: [String]
    let aModel: SubModel
    let aModelArray: [SubModel]
    let anIntEnum: TestIntEnum
    
    let optString: String?
    let optStringNil: Int?
    let optModel: SubModel?
    let optModelNil: SubModel?
    let optModelArray: [SubModel]?
    let optModelArrayNil: [SubModel]?
    let optIntEnum: TestIntEnum?
    let optIntEnumBadRange: TestIntEnum
}

extension TestModel: Decodable {
    static func decode(json: JSON?) throws -> TestModel {
        return try TestModel(
            aString: json ==> "aString",
            aFloat: json ==> "aFloat",
            anInt: json ==> "anInt",
            aNumber: json ==> "aNumber",
            anArray: json ==> "anArray",
            aModel: json ==> "aModel",
            aModelArray: json ==> "aModelArray",
            anIntEnum: json ==> "anIntEnum",
            optString: json ==> "optString",
            optStringNil: json ==> "optStringNil",
            optModel: json ==> "optModel",
            optModelNil: json ==> "optModelNil",
            optModelArray: json ==> "optModelArray",
            optModelArrayNil: json ==> "optModelArrayNil",
            optIntEnum: json ==> "optIntEnum",
            optIntEnumBadRange: json ==> "anIntEnumBadRange"
            ).validateDecode()
    }
    
    func validateDecode() throws -> TestModel {
        if aFloat == 1.234 {
            return self
        } else {
            throw DecodeError.ValidationFailed
        }
    }
}

extension TestModel: Encodable {
    func encode() throws -> JSON {
        return try validateEncode().encodeToJSON([
            "aStringOut" <== aString,
            "aFloatOut" <== aFloat,
            "anIntOut" <== anInt,
            "aNumberOut" <== aNumber,
            "anArrayOut" <== anArray,
            "aModelOut" <== aModel,
            "aModelArrayOut" <== aModelArray,
            "anIntEnumOut" <== anIntEnum,
            "optModel" <== optModel,
            "optModelArrayNilOut" <== optModelArrayNil,
            "optIntEnumOut" <== optIntEnum
            ])
    }
    
    func validateEncode() throws -> TestModel {
        return self
    }
}

class THGCodableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDecode() {
        var json = JSON()
        
        json["aString"] = "hello"
        json["aFloat"] = 1.234
        json["anInt"] = 1234
        json["aNumber"] = 1234
        json["anArray"] = ["1", "2", "3", "4"]
        json["aModel"] = JSON(["aSubString": "value"])
        json["aModelArray"] = JSON([["aSubString": "value1"], ["aSubString": "value2"], ["aSubString": "value3"]])
        json["anIntEnum"] = JSON(TestIntEnum.Test1.rawValue)
        
        // optional tests
        
        json["optString"] = JSON("helloAgain")
        json["optStringNil"] = JSON()
        json["optModel"] = ["aSubString": "value"]
        json["optModelNil"] = nil
        json["optModelArray"] = JSON([["aSubString": "value1"], ["aSubString": "value2"], ["aSubString": "value3"]])
        json["optModelArrayNil"] = nil
        json["optIntEnum"] = JSON(TestIntEnum.Test2.rawValue)
        json["optIntEnumBadRange"] = JSON(47)
        
        do {
            let model = try TestModel.decode(json)
            print(model)
        } catch DecodeError.Empty(let field) {
            print("required field \(field) was missing.")
        } catch _ {
            print("something happened, but i don't know what.")
        }
        
        //let output = try? model?.encode()
        //print(output)
    }

}
