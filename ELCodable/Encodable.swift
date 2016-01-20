//
//  Encodable.swift
//  Codable
//
//  Created by Brandon Sneed on 11/9/15.
//  Copyright © 2015 WalmartLabs. All rights reserved.
//

import Foundation

public enum EncodeError: ErrorType {
    case Unencodable
    case ValidationUnumplemented
    case ValidationFailed
}

public protocol Encodable {
    func encode() throws -> JSON
}

public typealias EncodeFormat = Array<(String, JSON)>

public extension Encodable {
    func validateEncode() throws -> Self {
        // do nothing.  user to override.
        throw EncodeError.ValidationUnumplemented
    }
    
    func encodeToJSON(format: EncodeFormat) throws -> JSON {
        var json = JSON()
        for tuple in format {
            json[tuple.0] = tuple.1
        }
        return json
    }
}
