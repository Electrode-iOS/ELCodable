//
//  DecodableExtensions.swift
//  Codable
//
//  Created by Brandon Sneed on 11/4/15.
//  Copyright © 2015 theholygrail.io. All rights reserved.
//

import Foundation

extension String: Decodable {
    public static func decode(json: JSON?) throws -> String {
        if let value = json?.string {
            return value
        }
        throw DecodeError.Undecodable
    }
}

extension Float: Decodable {
    public static func decode(json: JSON?) throws -> Float {
        if let value = json?.float {
            return value
        }
        throw DecodeError.Undecodable
    }
}

extension Double: Decodable {
    public static func decode(json: JSON?) throws -> Double {
        if let value = json?.double {
            return value
        }
        throw DecodeError.Undecodable
    }
}

extension Int: Decodable {
    public static func decode(json: JSON?) throws -> Int {
        if let value = json?.int {
            return value
        }
        throw DecodeError.Undecodable
    }
}

extension Int64: Decodable {
    public static func decode(json: JSON?) throws -> Int64 {
        if let value = json?.int64 {
            return value
        }
        throw DecodeError.Undecodable
    }
}

extension UInt: Decodable {
    public static func decode(json: JSON?) throws -> UInt {
        if let value = json?.uInt {
            return value
        }
        throw DecodeError.Undecodable
    }
}

extension UInt64: Decodable {
    public static func decode(json: JSON?) throws -> UInt64 {
        if let value = json?.uInt64 {
            return value
        }
        throw DecodeError.Undecodable
    }
}

extension Bool: Decodable {
    public static func decode(json: JSON?) throws -> Bool {
        if let value = json?.bool {
            return value
        }
        throw DecodeError.Undecodable
    }
}

extension Decimal: Decodable {
    public static func decode(json: JSON?) throws -> Decimal {
        if let value = json?.decimal {
            return Decimal(value)
        }
        throw DecodeError.Undecodable
    }
}

extension Array where Element: Decodable {
    public static func decode(json: JSON?) throws -> [Element] {
        guard let items = json?.array else {
            throw DecodeError.Undecodable
        }
        
        var decodedItems = [Element]()
        
        for item in items {
            let decodedItem = try Element.decode(item)
            decodedItems.append(decodedItem)
        }
        
        return decodedItems
    }
}


