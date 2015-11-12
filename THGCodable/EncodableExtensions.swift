//
//  EncodableExtensions.swift
//  Codable
//
//  Created by Brandon Sneed on 11/10/15.
//  Copyright © 2015 theholygrail.io. All rights reserved.
//

import Foundation

extension String: Encodable {
    public func encode() throws -> JSON {
        return JSON(self)
    }
}

extension Float: Encodable {
    public func encode() throws -> JSON {
        return JSON(self)
    }
}

extension Double: Encodable {
    public func encode() throws -> JSON {
        return JSON(self)
    }
}

extension Int: Encodable {
    public func encode() throws -> JSON {
        return JSON(self)
    }
}

extension Int64: Encodable {
    public func encode() throws -> JSON {
        return JSON(NSNumber(longLong: self))
    }
}

extension UInt: Encodable {
    public func encode() throws -> JSON {
        return JSON(self)
    }
}

extension UInt64: Encodable {
    public func encode() throws -> JSON {
        return JSON(NSNumber(unsignedLongLong: self))
    }
}

extension Bool: Encodable {
    public func encode() throws -> JSON {
        return JSON(self)
    }
}

extension Decimal: Encodable {
    public func encode() throws -> JSON {
        return JSON(self.value)
    }
}

extension Array where Element: Encodable {
    public func encode() throws -> JSON {
        var array = [AnyObject]()
        for item in self {
            let jsonItem = try item.encode()
            if let object = jsonItem.object {
                array.append(object)
            }
        }
        return JSON(array)
    }
}
