//
//  JSON2.swift
//  THGModel
//
//  Created by Brandon Sneed on 9/12/15.
//  Copyright © 2015 theholygrail. All rights reserved.
//

import Foundation

public enum JSONError: ErrorType {
    case InvalidJSON
}

public enum JSONType: Int {
    case Number
    case String
    case Bool
    case Array
    case Dictionary
    case Null
    case Unknown
}


public struct JSON {
    
    public var object: AnyObject?
    
    public init() {
        self.object = nil
    }
    
    public init(_ object: AnyObject?) {
        self.object = object
    }
    
    public init(json: JSON) {
        self.object = json.object
    }
    
    public init?(data: NSData?) {
        if let data = data {
            do {
                let object: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                self.object = object
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        else {
            return nil
        }
    }
    
    public init?(path: String) {
        let exists = NSFileManager.defaultManager().fileExistsAtPath(path)
        if exists {
            let data = NSData(contentsOfFile: path)
            self.init(data: data)
        } else {
            return nil
        }
    }
    
    /**
    Initialize an instance given a JSON file contained within the bundle.
    
    - parameter bundle: The bundle to attempt to load from.
    - parameter string: A string containing the name of the file to load from resources.
    */
    public init?(bundleClass: AnyClass, filename: String) {
        let bundle = NSBundle(forClass: bundleClass)
        self.init(bundle: bundle, filename: filename)
    }

    public init?(bundle: NSBundle, filename: String) {
        let filepath: String? = bundle.pathForResource(filename, ofType: nil)
        if let filepath = filepath {
            self.init(path: filepath)
        } else {
            return nil
        }
    }

    public subscript(key: String) -> JSON? {
        set {
            if var tempObject = object as? [String : AnyObject] {
                tempObject[key] = newValue?.object
                self.object = tempObject
            }
            else {
                var tempObject: [String : AnyObject] = [:]
                tempObject[key] = newValue?.object
                self.object = tempObject
            }
        }
        get {
            /**
            NSDictionary is used because it currently performs better than a native Swift dictionary.
            The reason for this is that [String : AnyObject] is bridged to NSDictionary deep down the
            call stack, and this bridging operation is relatively expensive. Until Swift is ABI stable
            and/or doesn't require a bridge to Objective-C, NSDictionary will be used here
            */
            if let dictionary = object as? NSDictionary {
                let value = dictionary[key]
                if let value = value {
                    return JSON(value)
                }
            }
            
            return nil
        }
    }
}

extension JSON {
    public func data() -> NSData? {
        if let object = object {
            return try? NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted)
        }
        return nil
    }
}

// MARK: - Types (Debugging)
extension JSON {
    public var type: JSONType {
        if let object = object {
            switch object {
            case is NSString:
                return .String
            case is NSArray:
                return .Array
            case is NSDictionary:
                return .Dictionary
            case is NSNumber:
                let number = object as! NSNumber
                let type = String.fromCString(number.objCType)!
                // there's no such thing as a 'char' in json, but that's
                // what the serializer types it as.
                if type == "c" {
                    return .Bool
                }
                return .Number
            case is NSNull:
                return .Null
            default:
                return .Unknown
            }
        } else {
            return .Unknown
        }
    }
    
    public var objectType: String {
        if let object = object {
            return "\(object.dynamicType)"
        } else {
            return "Unknown"
        }
    }
}

// MARK: - CustomStringConvertible

extension JSON: CustomStringConvertible {
    public var description: String {
        if let object: AnyObject = object {
            switch object {
            case is String, is NSNumber, is Float, is Double, is Int, is UInt, is Bool: return "\(object)"
            case is [AnyObject], is [String : AnyObject]:
                if let data = try? NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted) {
                    return NSString(data: data, encoding: NSUTF8StringEncoding) as? String ?? ""
                }
            default: return ""
            }
        }
        
        return "\(object)"
    }
}

// MARK: - CustomDebugStringConvertible

extension JSON: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}

// MARK: - NilLiteralConvertible

extension JSON: NilLiteralConvertible {
    public init(nilLiteral: ()) {
        self.init()
    }
}

// MARK: - StringLiteralConvertible

extension JSON: StringLiteralConvertible {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
}

// MARK: - FloatLiteralConvertible

extension JSON: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

// MARK: - IntegerLiteralConvertible

extension JSON: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

// MARK: - BooleanLiteralConvertible

extension JSON: BooleanLiteralConvertible {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

// MARK: - ArrayLiteralConvertible

extension JSON: ArrayLiteralConvertible {
    public init(arrayLiteral elements: AnyObject...) {
        self.init(elements)
    }
}

// MARK: - DictionaryLiteralConvertible

extension JSON: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (String, AnyObject)...) {
        var object: [String : AnyObject] = [:]
        
        for (key, value) in elements {
            object[key] = value
        }
        
        self.init(object)
    }
}

// MARK: - String

extension JSON {
    public var string: String? {
        if let object = object {
            var value: String? = nil
            switch object {
            case is String:
                value = object as? String
            case is NSDecimalNumber:
                value = (object as? NSDecimalNumber)?.stringValue
            case is NSNumber:
                value = (object as? NSNumber)?.stringValue
            default:
                break
            }
            
            return value
        } else {
            return nil
        }
    }
}

// MARK: - NSNumber

extension JSON {
    public var number: NSNumber? {
        if let object = object {
            var value: NSNumber? = nil
            switch object {
            case is NSNumber:
                value = object as? NSNumber
            case is String:
                value = NSDecimalNumber(string: object as? String)
            default:
                break
            }
            
            return value
        } else {
            return nil
        }
    }
}

// MARK: - NSDecimalNumber

extension JSON {
    public var decimal: NSDecimalNumber? {
        if let object = object {
            var value: NSDecimalNumber? = nil
            switch object {
            case is String:
                let stringValue = object as? String
                if let stringValue = stringValue {
                    value = NSDecimalNumber(string: stringValue)
                }
                
            case is NSDecimalNumber:
                value = object as? NSDecimalNumber
                
            case is NSNumber:
                // We need to jump through some hoops here. NSNumber's decimalValue doesn't guarantee
                // exactness for float and double types.  See "decimalValue" on NSNumber.
                let number = object as! NSNumber
                let type = String.fromCString(number.objCType)!
                
                // type encodings can be found here:
                // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
                
                switch(type) {
                    // treat the integer based ones the same and just use
                    // the largest type.  No worries here about rounding.
                case "c", "i", "s", "l", "q":
                    value = NSDecimalNumber(longLong: number.longLongValue)
                    break
                    // do the same with the unsigned types.
                case "C", "I", "S", "L", "Q":
                    value = NSDecimalNumber(unsignedLongLong: number.unsignedLongLongValue)
                    break
                    // and again with precision types.
                case "f", "d":
                    value = NSDecimalNumber(double: number.doubleValue)
                    // not sure if we need to handle this, but just in case.
                    // it shouldn't hurt anything.
                case "*":
                    value = NSDecimalNumber(string: number.stringValue)
                    // probably don't need this one either, but oh well.
                case "B":
                    value = NSDecimalNumber(bool: number.boolValue)
                    
                default:
                    break
                }
                
            default:
                break
            }
            
            return value
        } else {
            return nil
        }
    }
}

// MARK: - Float

extension JSON {
    public var float: Float? {
        if let object = object {
            var value: Float? = nil
            switch object {
            case is NSNumber:
                value = (object as? NSNumber)?.floatValue
            case is String:
                let stringValue = object as? String
                if let stringValue = stringValue {
                    value = NSDecimalNumber(string: stringValue).floatValue
                }
            default:
                break;
            }
            
            return value
        } else {
            return nil
        }
    }
}

// MARK: - Double

extension JSON {
    public var double: Double? {
        if let object = object {
            var value: Double? = nil
            switch object {
            case is NSNumber:
                value = (object as? NSNumber)?.doubleValue
            case is String:
                let stringValue = object as? String
                if let stringValue = stringValue {
                    value = NSDecimalNumber(string: stringValue).doubleValue
                }
            default:
                break;
            }
            
            return value
        } else {
            return nil
        }
    }
}

// MARK: - Int

extension JSON {
    public var int: Int? {
        if let object = object {
            var value: Int? = nil
            switch object {
            case is NSNumber:
                value = (object as? NSNumber)?.integerValue
            case is String:
                let stringValue = object as? String
                if let stringValue = stringValue {
                    value = NSDecimalNumber(string: stringValue).integerValue
                }
            default:
                break;
            }
            
            return value
        } else {
            return nil
        }
    }
    
    public var int64: Int64? {
        if let object = object {
            var value: Int64? = nil
            switch object {
            case is NSNumber:
                value = (object as? NSNumber)?.longLongValue
            case is String:
                let stringValue = object as? String
                if let stringValue = stringValue {
                    value = NSDecimalNumber(string: stringValue).longLongValue
                }
            default:
                break;
            }
            
            return value
        } else {
            return nil
        }
    }
}

// MARK: - UInt

extension JSON {
    public var uInt: UInt? {
        if let object = object {
            var value: UInt? = nil
            switch object {
            case is NSNumber:
                value = (object as? NSNumber)?.unsignedIntegerValue
            case is String:
                let stringValue = object as? String
                if let stringValue = stringValue {
                    value = NSDecimalNumber(string: stringValue).unsignedIntegerValue
                }
            default:
                break;
            }
            
            return value
        } else {
            return nil
        }
    }
    
    public var uInt64: UInt64? {
        if let object = object {
            var value: UInt64? = nil
            switch object {
            case is NSNumber:
                value = (object as? NSNumber)?.unsignedLongLongValue
            case is String:
                let stringValue = object as? String
                if let stringValue = stringValue {
                    value = NSDecimalNumber(string: stringValue).unsignedLongLongValue
                }
            default:
                break;
            }
            
            return value
        } else {
            return nil
        }
    }
}

// MARK: - Bool

extension JSON {
    public var bool: Bool? {
        if let object = object {
            var value: Bool? = nil
            switch object {
            case is NSNumber:
                value = (object as? NSNumber)?.boolValue
            case is String:
                let stringValue = object as? String
                if let stringValue = stringValue {
                    value = NSDecimalNumber(string: stringValue).boolValue
                }
            default:
                break;
            }
            
            return value
        } else {
            return nil
        }
    }
}

// MARK: - NSURL

extension JSON {
    public var URL: NSURL? {
        if let urlString = string {
            return NSURL(string: urlString)
        }
        return nil
    }
}

// MARK: - Array

extension JSON {
    public var array: [JSON]? {
        if let array = object as? [AnyObject] {
            return array.map { JSON($0) }
        }
        return nil
    }
    //public var arrayValue: [JSON] { return array ?? [] }
}

// MARK: - Dictionary

extension JSON {
    public var dictionary: [String : JSON]? {
        if let dictionary = object as? [String : AnyObject] {
            return Dictionary(dictionary.map { ($0, JSON($1)) })
        }
        return nil
    }
    //public var dictionaryValue: [String : JSON] { return dictionary ?? [:] }
}

extension Dictionary {
    private init(_ pairs: [Element]) {
        self.init()
        for (key, value) in pairs {
            self[key] = value
        }
    }
}

// MARK: - Equatable

extension JSON: Equatable {}

public func ==(lhs: JSON, rhs: JSON) -> Bool {
    if let lhsObject: AnyObject = lhs.object, rhsObject: AnyObject = rhs.object {
        switch (lhsObject, rhsObject) {
        case (let left as String, let right as String):
            return left == right
        case (let left as Double, let right as Double):
            return left == right
        case (let left as Float, let right as Float):
            return left == right
        case (let left as Int, let right as Int):
            return left == right
        case (let left as Int64, let right as Int64):
            return left == right
        case (let left as UInt, let right as UInt):
            return left == right
        case (let left as UInt64, let right as UInt64):
            return left == right
        case (let left as Bool, let right as Bool):
            return left == right
        case (let left as [AnyObject], let right as [AnyObject]):
            return left.map { JSON($0) } == right.map { JSON ($0) }
        case (let left as [String : AnyObject], let right as [String : AnyObject]):
            return Dictionary(left.map { ($0, JSON($1)) }) == Dictionary(right.map { ($0, JSON($1)) })
        default: return false
        }
    }
    
    return false
}



