//
//  Decimal.swift
//  Decimal
//
//  Created by Brandon Sneed on 11/7/15.
//  Copyright © 2015 WalmartLabs. All rights reserved.
//

import Foundation

public struct Decimal: Hashable {
    public let value: NSDecimalNumber
    
    /// Create an instance initialized to zero.
    public init() {
        value = NSDecimalNumber.zero
    }
    /// Create an instance initialized to `value`.
    public init(_ value: NSDecimalNumber) {
        self.value = value
    }
    
    public init(_ value: NSNumber) {
        self.value = NSDecimalNumber(decimal: value.decimalValue)
    }
    
    public init(_ value: Float) {
        self.value = NSDecimalNumber(value: value)
    }
    
    public init(_ value: Double) {
        self.value = NSDecimalNumber(value: value)
    }
    
    public init(_ value: String) {
        self.value = NSDecimalNumber(string: value)
    }
    
    public init(_ v: UInt8) {
        value = NSDecimalNumber(value: v)
    }
    public init(_ v: Int8) {
        value = NSDecimalNumber(value: v)
    }
    public init(_ v: UInt16) {
        value = NSDecimalNumber(value: v)
    }
    public init(_ v: Int16) {
        value = NSDecimalNumber(value: v)
    }
    public init(_ v: UInt32) {
        value = NSDecimalNumber(value: v)
    }
    public init(_ v: Int32) {
        value = NSDecimalNumber(value: v)
    }
    public init(_ v: UInt64) {
        value = NSDecimalNumber(value: v)
    }
    public init(_ v: Int64) {
        value = NSDecimalNumber(value: v)
    }
    public init(_ v: UInt) {
        value = NSDecimalNumber(value: v)
    }
    public init(_ v: Int) {
        value = NSDecimalNumber(value: v)
    }
    
    /// The hash value.
    ///
    /// **Axiom:** `x == y` implies `x.hashValue == y.hashValue`.
    ///
    /// - Note: The hash value is not guaranteed to be stable across
    ///   different invocations of the same program.  Do not persist the
    ///   hash value across program runs.
    public var hashValue: Int {
        return value.hash
    }
}

extension Decimal: CustomStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return String(reflecting: value)
    }
}

extension Decimal: CustomDebugStringConvertible {
    /// A textual representation of `self`.
    public var debugDescription: String {
        return String(reflecting: value)
    }
}

extension Decimal /*: FloatingPointType*/ { // It complains about _BitsType missing, no idea wtf that is.
    /// The positive infinity.
    public static var infinity: Decimal {
        return Decimal(Double.infinity)
    }
    /// A quiet NaN.
    public static var NaN: Decimal {
        return Decimal(NSDecimalNumber.notANumber)
    }
    /// A quiet NaN.
    public static var quietNaN: Decimal {
        return NaN
    }
    /// `true` iff `self` is negative.
    public var isSignMinus: Bool {
        guard let doubleValue = doubleValue else {
            return false
        }
        
        return (doubleValue.sign == .minus)
    }
    /// `true` iff `self` is normal (not zero, subnormal, infinity, or
    /// NaN).
    public var isNormal: Bool {
        return doubleValue?.isNormal ?? false
    }
    /// `true` iff `self` is zero, subnormal, or normal (not infinity
    /// or NaN).
    public var isFinite: Bool {
        return doubleValue?.isFinite ?? false
    }
    /// `true` iff `self` is +0.0 or -0.0.
    public var isZero: Bool {
        return doubleValue?.isZero ?? false
    }
    /// `true` iff `self` is subnormal.
    public var isSubnormal: Bool {
        return doubleValue?.isSubnormal ?? false
    }
    /// `true` iff `self` is infinity.
    public var isInfinite: Bool {
        return doubleValue?.isInfinite ?? false
    }
    /// `true` iff `self` is NaN.
    public var isNaN: Bool {
        return doubleValue?.isNaN ?? false
    }
    /// `true` iff `self` is a signaling NaN.
    public var isSignaling: Bool {
        return doubleValue?.isSignalingNaN ?? false
    }
    
    private var doubleValue: Double? {
        return value as? Double
    }
}

extension Decimal: Equatable {
    public static func ==(lhs: Decimal, rhs: Decimal) -> Bool {
        return lhs.value.compare(rhs.value) == .orderedSame
    }
}

extension Decimal: Comparable {
    public static func <(lhs: Decimal, rhs: Decimal) -> Bool {
        return lhs.value.compare(rhs.value) == .orderedAscending
    }

    public static func <=(lhs: Decimal, rhs: Decimal) -> Bool {
        let result = lhs.value.compare(rhs.value)
        if result == .orderedAscending {
            return true
        } else if result == .orderedSame {
            return true
        }
        return false
    }

    public static func >=(lhs: Decimal, rhs: Decimal) -> Bool {
        let result = lhs.value.compare(rhs.value)
        if result == .orderedDescending {
            return true
        } else if result == .orderedSame {
            return true
        }
        return false
    }

    public static func >(lhs: Decimal, rhs: Decimal) -> Bool {
        return lhs.value.compare(rhs.value) == .orderedDescending
    }
}

extension Decimal: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.value = NSDecimalNumber(value: value as Int)
    }
}

// MARK: Addition operators

public func +(lhs: Decimal, rhs: Decimal) -> Decimal {
    return Decimal(lhs.value.adding(rhs.value))
}

public prefix func ++(lhs: Decimal) -> Decimal {
    return Decimal(lhs.value.adding(NSDecimalNumber.one))
}

public postfix func ++(lhs: inout Decimal) -> Decimal {
    lhs = Decimal(lhs.value.adding(NSDecimalNumber.one))
    return lhs
}

public func +=(lhs: inout Decimal, rhs: Decimal) {
    lhs = Decimal(lhs.value.adding(rhs.value))
}

public func +=(lhs: inout Decimal, rhs: Int) {
    lhs = Decimal(lhs.value.adding(NSDecimalNumber(value: rhs as Int)))
}

public func +=(lhs: inout Decimal, rhs: Double) {
    lhs = Decimal(lhs.value.adding(NSDecimalNumber(value: rhs as Double)))
}

// MARK: Subtraction operators

public prefix func -(x: Decimal) -> Decimal {
    return Decimal(x.value.multiplying(by: NSDecimalNumber(value: -1 as Int)))
}

public func -(lhs: Decimal, rhs: Decimal) -> Decimal {
    return Decimal(lhs.value.subtracting(rhs.value))
}

public prefix func --(lhs: Decimal) -> Decimal {
    return Decimal(lhs.value.subtracting(NSDecimalNumber.one))
}

public postfix func --(lhs: inout Decimal) -> Decimal {
    lhs = Decimal(lhs.value.subtracting(NSDecimalNumber.one))
    return lhs
}

public func -=(lhs: inout Decimal, rhs: Decimal) {
    lhs = Decimal(lhs.value.subtracting(rhs.value))
}

public func -=(lhs: inout Decimal, rhs: Int) {
    lhs = Decimal(lhs.value.subtracting(NSDecimalNumber(value: rhs as Int)))
}

public func -=(lhs: inout Decimal, rhs: Double) {
    lhs = Decimal(lhs.value.subtracting(NSDecimalNumber(value: rhs as Double)))
}


// MARK: Multiplication operators

public func *(lhs: Decimal, rhs: Decimal) -> Decimal {
    return Decimal(lhs.value.multiplying(by: rhs.value))
}

public func *=(lhs: inout Decimal, rhs: Decimal) {
    lhs = Decimal(lhs.value.multiplying(by: rhs.value))
}

public func *=(lhs: inout Decimal, rhs: Int) {
    lhs = Decimal(lhs.value.multiplying(by: NSDecimalNumber(value: rhs as Int)))
}

public func *=(lhs: inout Decimal, rhs: Double) {
    lhs = Decimal(lhs.value.multiplying(by: NSDecimalNumber(value: rhs as Double)))
}

// MARK: Division operators

public func /(lhs: Decimal, rhs: Decimal) -> Decimal {
    return Decimal(lhs.value.dividing(by: rhs.value))
}

public func /=(lhs: inout Decimal, rhs: Decimal) {
    lhs = Decimal(lhs.value.dividing(by: rhs.value))
}

public func /=(lhs: inout Decimal, rhs: Int) {
    lhs = Decimal(lhs.value.dividing(by: NSDecimalNumber(value: rhs as Int)))
}

public func /=(lhs: inout Decimal, rhs: Double) {
    lhs = Decimal(lhs.value.dividing(by: NSDecimalNumber(value: rhs as Double)))
}

// MARK: Power-of operators

public func ^(lhs: Decimal, rhs: Int) -> Decimal {
    return Decimal(lhs.value.raising(toPower: rhs))
}

