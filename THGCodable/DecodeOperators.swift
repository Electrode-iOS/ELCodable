//
//  DecodeOperators.swift
//  Codable
//
//  Created by Brandon Sneed on 11/3/15.
//  Copyright © 2015 theholygrail.io. All rights reserved.
//

import Foundation

infix operator ==> { associativity right precedence 150 }


public func ==> <T: Decodable>(lhs: JSON?, rhs: String) throws -> T {
    let value = try? T.decode(lhs?[rhs])
    if let value = value {
        return value
    } else {
        throw DecodeError.EmptyJSON
    }
}

public func ==> <T: Decodable>(lhs: JSON?, rhs: String) throws -> [T] {
    guard let array = lhs?[rhs]?.array else {
        throw DecodeError.EmptyJSON
    }
    
    var results = [T]()
    
    for json in array {
        if let value = try? T.decode(json) {
            results.append(value)
        } else {
            throw DecodeError.EmptyJSON
        }
    }
    
    return results
}

public func ==> <T: Decodable>(lhs: JSON?, rhs: String) throws -> T? {
    let value = try? T.decode(lhs?[rhs])
    if let value = value {
        return value
    } else {
        return nil
    }
}

public func ==> <T: Decodable>(lhs: JSON?, rhs: String) throws -> [T]? {
    guard let array = lhs?[rhs]?.array else {
        return nil
    }
    
    var results = [T]()
    
    for json in array {
        if let value = try? T.decode(json) {
            results.append(value)
        } else {
            throw DecodeError.EmptyJSON
        }
    }
    
    return results
}

