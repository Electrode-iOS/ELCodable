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
    guard let json = lhs else {
        throw DecodeError.EmptyJSON
    }
    
    if rhs == "cityjij" {
        print("boo")
    }
    
    do {
        let value: T? = try T.decode(json[rhs])
        if let value = value {
            return value
        } else {
            throw DecodeError.NotFound(key: rhs)
        }
    } catch {
        // if decode got an error, it'll be EmptyJSON.
        // this is because json[rhs] returns nil if the key doesn't exist.
        // so throw what we actually mean/want.
        throw DecodeError.NotFound(key: rhs)
    }
}

public func ==> <T: Decodable>(lhs: JSON?, rhs: String) throws -> [T] {
    guard let json = lhs else {
        throw DecodeError.EmptyJSON
    }
    
    guard let array = json[rhs]?.array else {
        throw DecodeError.NotFound(key: rhs)
    }
    
    var results = [T]()
    
    for json in array {
        // will throw a NotFound() if this decode fails.
        let value = try T.decode(json)
        results.append(value)
    }
    
    return results
}

public func ==> <T: Decodable>(lhs: JSON?, rhs: String) throws -> T? {
    guard let json = lhs else {
        throw DecodeError.EmptyJSON
    }
    
    let value = try? T.decode(json[rhs])
    if let value = value {
        return value
    } else {
        return nil
    }
}

public func ==> <T: Decodable>(lhs: JSON?, rhs: String) throws -> [T]? {
    guard let json = lhs else {
        throw DecodeError.EmptyJSON
    }
    
    guard let array = json[rhs]?.array else {
        return nil
    }
    
    var results = [T]()
    
    for json in array {
        if let value = try? T.decode(json) {
            results.append(value)
        }
    }
    
    return results
}

