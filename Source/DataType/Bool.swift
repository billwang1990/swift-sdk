//
//  LCBool.swift
//  LeanCloud
//
//  Created by Tang Tianyong on 2/27/16.
//  Copyright © 2016 LeanCloud. All rights reserved.
//

import Foundation

/**
 LeanCloud boolean type.

 It is a wrapper of `Swift.Bool` type, used to store a boolean value.
 */
public final class LCBool: NSObject, LCType, LCTypeExtension, ExpressibleByBooleanLiteral {
    public private(set) var value: Bool = false

    public override init() {
        super.init()
    }

    public convenience init(_ value: Bool) {
        self.init()
        self.value = value
    }

    public convenience required init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }

    public required init?(coder aDecoder: NSCoder) {
        value = aDecoder.decodeBool(forKey: "value")
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }

    public func copy(with zone: NSZone?) -> AnyObject {
        return LCBool(value)
    }

    public override func isEqual(_ object: AnyObject?) -> Bool {
        if object === self {
            return true
        } else if let object = object as? LCBool {
            return object.value == value
        } else {
            return false
        }
    }

    public var JSONValue: AnyObject {
        return value
    }

    public var JSONString: String {
        return ObjectProfiler.getJSONString(self)
    }

    var LCONValue: AnyObject? {
        return value
    }

    static func instance() -> LCType {
        return LCBool()
    }

    func forEachChild(_ body: @noescape (child: LCType) -> Void) {
        /* Nothing to do. */
    }

    func add(_ other: LCType) throws -> LCType {
        throw LCError(code: .invalidType, reason: "Object cannot be added.")
    }

    func concatenate(_ other: LCType, unique: Bool) throws -> LCType {
        throw LCError(code: .invalidType, reason: "Object cannot be concatenated.")
    }

    func differ(_ other: LCType) throws -> LCType {
        throw LCError(code: .invalidType, reason: "Object cannot be differed.")
    }
}
