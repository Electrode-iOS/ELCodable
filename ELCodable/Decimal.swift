//
//  Decimal.swift
//  Decimal
//
//  Created by Brandon Sneed on 11/7/15.
//  Copyright © 2015 WalmartLabs. All rights reserved.
//

import Foundation

public struct Decimal {
    public let value: NSDecimalNumber
    
    /// Create an instance initialized to zero.
    public init() {
        value = NSDecimalNumber.zero()
    }
    /// Create an instance initialized to `value`.
    public init(_ value: NSDecimalNumber) {
        self.value = value
    }
    
    public init(_ value: NSNumber) {
        self.value = NSDecimalNumber(decimal: value.decimalValue)
    }
    
    public init(_ value: Float) {
        self.value = NSDecimalNumber(float: value)
    }
    
    public init(_ value: Double) {
        self.value = NSDecimalNumber(double: value)
    }
    
    public init(_ value: String) {
        self.value = NSDecimalNumber(string: value)
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
        return Decimal(NSDecimalNumber.notANumber())
    }
    /// A quiet NaN.
    public static var quietNaN: Decimal {
        return NaN
    }
    /// `true` iff `self` is negative.
    public var isSignMinus: Bool {
        return (value as Double).isSignMinus
    }
    /// `true` iff `self` is normal (not zero, subnormal, infinity, or
    /// NaN).
    public var isNormal: Bool {
        return (value as Double).isNormal
    }
    /// `true` iff `self` is zero, subnormal, or normal (not infinity
    /// or NaN).
    public var isFinite: Bool {
        return (value as Double).isFinite
    }
    /// `true` iff `self` is +0.0 or -0.0.
    public var isZero: Bool {
        return (value as Double).isZero
    }
    /// `true` iff `self` is subnormal.
    public var isSubnormal: Bool {
        return (value as Double).isSubnormal
    }
    /// `true` iff `self` is infinity.
    public var isInfinite: Bool {
        return (value as Double).isInfinite
    }
    /// `true` iff `self` is NaN.
    public var isNaN: Bool {
        return (value as Double).isNaN
    }
    /// `true` iff `self` is a signaling NaN.
    public var isSignaling: Bool {
        return (value as Double).isSignaling
    }
}

extension Decimal: Comparable, Equatable {
}

// MARK: Equatable
public func ==(lhs: Decimal, rhs: Decimal) -> Bool {
    return lhs.value.compare(rhs.value) == .OrderedSame
}

// MARK: Comparable
public func <(lhs: Decimal, rhs: Decimal) -> Bool {
    return lhs.value.compare(rhs.value) == .OrderedAscending
}

public func <=(lhs: Decimal, rhs: Decimal) -> Bool {
    let result = lhs.value.compare(rhs.value)
    if result == .OrderedAscending {
        return true
    } else if result == .OrderedSame {
        return true
    }
    return false
}

public func >=(lhs: Decimal, rhs: Decimal) -> Bool {
    let result = lhs.value.compare(rhs.value)
    if result == .OrderedDescending {
        return true
    } else if result == .OrderedSame {
        return true
    }
    return false
}

public func >(lhs: Decimal, rhs: Decimal) -> Bool {
    return lhs.value.compare(rhs.value) == .OrderedDescending
}

extension Decimal: Hashable {
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

extension Decimal: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self.value = NSDecimalNumber(integer: value)
    }
}

extension Decimal: AbsoluteValuable {
    /// Returns the absolute value of `x`.
    @warn_unused_result
    public static func abs(x: Decimal) -> Decimal {
        if x.value.compare(NSDecimalNumber.zero()) == .OrderedAscending {
            // number is neg, multiply by -1
            let negOne = NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true)
            return Decimal(x.value.decimalNumberByMultiplyingBy(negOne, withBehavior: nil))
        } else {
            return x
        }
    }
}

extension Decimal {
    public init(_ v: UInt8) {
        value = NSDecimalNumber(unsignedChar: v)
    }
    public init(_ v: Int8) {
        value = NSDecimalNumber(char: v)
    }
    public init(_ v: UInt16) {
        value = NSDecimalNumber(unsignedShort: v)
    }
    public init(_ v: Int16) {
        value = NSDecimalNumber(short: v)
    }
    public init(_ v: UInt32) {
        value = NSDecimalNumber(unsignedInt: v)
    }
    public init(_ v: Int32) {
        value = NSDecimalNumber(int: v)
    }
    public init(_ v: UInt64) {
        value = NSDecimalNumber(unsignedLongLong: v)
    }
    public init(_ v: Int64) {
        value = NSDecimalNumber(longLong: v)
    }
    public init(_ v: UInt) {
        value = NSDecimalNumber(unsignedInteger: v)
    }
    public init(_ v: Int) {
        value = NSDecimalNumber(integer: v)
    }
}

// MARK: Addition operators

public func +(lhs: Decimal, rhs: Decimal) -> Decimal {
    return Decimal(lhs.value.decimalNumberByAdding(rhs.value))
}

public prefix func ++(lhs: Decimal) -> Decimal {
    return Decimal(lhs.value.decimalNumberByAdding(NSDecimalNumber.one()))
}

public postfix func ++(inout lhs: Decimal) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByAdding(NSDecimalNumber.one()))
    return lhs
}

public func +=(inout lhs: Decimal, rhs: Decimal) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByAdding(rhs.value))
    return lhs
}

public func +=(inout lhs: Decimal, rhs: Int) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByAdding(NSDecimalNumber(integer: rhs)))
    return lhs
}

public func +=(inout lhs: Decimal, rhs: Double) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByAdding(NSDecimalNumber(double: rhs)))
    return lhs
}

// MARK: Subtraction operators

public prefix func -(x: Decimal) -> Decimal {
    return Decimal(x.value.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: -1)))
}

public func -(lhs: Decimal, rhs: Decimal) -> Decimal {
    return Decimal(lhs.value.decimalNumberBySubtracting(rhs.value))
}

public prefix func --(lhs: Decimal) -> Decimal {
    return Decimal(lhs.value.decimalNumberBySubtracting(NSDecimalNumber.one()))
}

public postfix func --(inout lhs: Decimal) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberBySubtracting(NSDecimalNumber.one()))
    return lhs
}

public func -=(inout lhs: Decimal, rhs: Decimal) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberBySubtracting(rhs.value))
    return lhs
}

public func -=(inout lhs: Decimal, rhs: Int) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberBySubtracting(NSDecimalNumber(integer: rhs)))
    return lhs
}

public func -=(inout lhs: Decimal, rhs: Double) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberBySubtracting(NSDecimalNumber(double: rhs)))
    return lhs
}


// MARK: Multiplication operators

public func *(lhs: Decimal, rhs: Decimal) -> Decimal {
    return Decimal(lhs.value.decimalNumberByMultiplyingBy(rhs.value))
}

public func *=(inout lhs: Decimal, rhs: Decimal) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByMultiplyingBy(rhs.value))
    return lhs
}

public func *=(inout lhs: Decimal, rhs: Int) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: rhs)))
    return lhs
}

public func *=(inout lhs: Decimal, rhs: Double) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByMultiplyingBy(NSDecimalNumber(double: rhs)))
    return lhs
}

// MARK: Division operators

public func /(lhs: Decimal, rhs: Decimal) -> Decimal {
    return Decimal(lhs.value.decimalNumberByDividingBy(rhs.value))
}

public func /=(inout lhs: Decimal, rhs: Decimal) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByDividingBy(rhs.value))
    return lhs
}

public func /=(inout lhs: Decimal, rhs: Int) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByDividingBy(NSDecimalNumber(integer: rhs)))
    return lhs
}

public func /=(inout lhs: Decimal, rhs: Double) -> Decimal {
    lhs = Decimal(lhs.value.decimalNumberByDividingBy(NSDecimalNumber(double: rhs)))
    return lhs
}

// MARK: Power-of operators

public func ^(lhs: Decimal, rhs: Int) -> Decimal {
    return Decimal(lhs.value.decimalNumberByRaisingToPower(rhs))
}

extension Decimal: Strideable {
    /// Returns a stride `x` such that `self.advancedBy(x)` approximates
    /// `other`.
    ///
    /// - Complexity: O(1).
    public func distanceTo(other: Decimal) -> Decimal {
        return self - other
    }
    /// Returns a `Self` `x` such that `self.distanceTo(x)` approximates
    /// `n`.
    ///
    /// - Complexity: O(1).
    public func advancedBy(amount: Decimal) -> Decimal {
        return self + amount
    }
    
}


