//
//  Decodable.swift
//  Codable
//
//  Created by Brandon Sneed on 11/2/15.
//  Copyright © 2015 theholygrail.io. All rights reserved.
//

import Foundation

public enum DecodeError: ErrorType {
    case Empty(field: String)
    case Invalid(field: String)
    case Undecodable
    case ValidationUnimplemented
    case ValidationFailed
}

public protocol Decodable {
    static func decode(json: JSON?) throws -> Self
    func validate() throws -> Self
}

public extension Decodable {
    func validate() throws -> Self {
        // do nothing.  user to override.
        throw DecodeError.ValidationUnimplemented
        //return self
    }
}