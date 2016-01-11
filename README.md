# Coconut [![Build Status](https://travis-ci.org/TheHolyGrail/Coconut.svg?branch=master)](https://travis-ci.org/TheHolyGrail/Coconut)

THGCodable, a data model decoding/encoding framework for Swift.  Inspired by Anviking's Decodable (https://github.com/Anviking/Decodable)

Proper docs and tests forthcoming, for now, chew on this.

```swift
// An example model and submodel.

struct SubModel {
    let aSubString: String
}

// Add decode support to the submodel, no validation.

extension SubModel: Decodable {
    static func decode(json: JSON?) throws -> SubModel {
        return try SubModel(
            aSubString: json ==> "aSubString"
        )
    }
}

// Add encode support to the submodel, no validation.

extension SubModel: Encodable {
    func encode() throws -> JSON {
        return try encodeToJSON([
            "aSubString1" <== aSubString
        ])
    }
}

struct TestModel {
    // these will throw exceptions if the data isn't present, or can't be decoded.
    let aString: String
    let aFloat: Float
    let anInt: Int
    let aNumber: Decimal
    let anArray: [String]
    let aModel: SubModel
    let aModelArray: [SubModel]
    
    // these will NOT throw exceptions if the data isn't present.  If the data
    // is there and can't be encoded, only then will an exception be thrown.
    let optString: String?
    let optStringNil: Int?
    let optModel: SubModel?
    let optModelNil: SubModel?
    let optModelArray: [SubModel]?
    let optModelArrayNil: [SubModel]?
}

// Adds the ability to decode it from JSON.

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
            optString: json ==> "optString",
            optStringNil: json ==> "optStringNil",
            optModel: json ==> "optModel",
            optModelNil: json ==> "optModelNil",
            optModelArray: json ==> "optModelArray",
            optModelArrayNil: json ==> "optModelArrayNil"
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

// Adds the ability to encode to JSON

extension TestModel: Encodable {
    func encode() throws -> JSON {
        return try validateEncode().encodeToJSON([
            "aString1" <== aString,
            "aFloat1" <== aFloat,
            "anInt1" <== anInt,
            "aNumber1" <== aNumber,
            "anArray1" <== anArray,
            "aModel1" <== aModel,
            "aModelArray1" <== aModelArray
        ])
    }
    
    func validateEncode() throws -> TestModel {
        // you can do something here, or not even implement it. and skip the validateEncode() call above.
        return self
    }
}

```
