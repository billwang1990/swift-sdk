//
//  LCDate.swift
//  LeanCloud
//
//  Created by Tang Tianyong on 4/1/16.
//  Copyright © 2016 LeanCloud. All rights reserved.
//

import Foundation

/**
 LeanCloud date type.

 This type used to represent a point in UTC time.
 */
public final class LCDate: NSObject, LCType, LCTypeExtension {
    public private(set) var value: Date = Date()

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    static func dateFromString(_ string: String) -> Date? {
        return dateFormatter.date(from: string)
    }

    static func stringFromDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    var ISOString: String {
        return LCDate.stringFromDate(value)
    }

    public override init() {
        super.init()
    }

    public convenience init(_ date: Date) {
        self.init()
        value = date
    }

    init?(ISOString: String) {
        guard let date = LCDate.dateFromString(ISOString) else {
            return nil
        }

        value = date
    }

    init?(dictionary: [String: AnyObject]) {
        guard let type = dictionary["__type"] as? String else {
            return nil
        }
        guard let dataType = RESTClient.DataType(rawValue: type) else {
            return nil
        }
        guard case dataType = RESTClient.DataType.Date else {
            return nil
        }
        guard let ISOString = dictionary["iso"] as? String else {
            return nil
        }
        guard let date = LCDate.dateFromString(ISOString) else {
            return nil
        }

        value = date
    }

    init?(JSONValue: AnyObject?) {
        var value: Date?

        switch JSONValue {
        case let ISOString as String:
            value = LCDate.dateFromString(ISOString)
        case let dictionary as [String: AnyObject]:
            if let date = LCDate(dictionary: dictionary) {
                value = date.value
            }
        case let date as LCDate:
            value = date.value
        default:
            break
        }

        guard let someValue = value else {
            return nil
        }

        value = someValue
    }

    public required init?(coder aDecoder: NSCoder) {
        value = (aDecoder.decodeObject(forKey: "value") as? Date) ?? Date()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }

    public func copy(with zone: NSZone?) -> AnyObject {
        return LCDate((value as NSDate).copy() as! Date)
    }

    public override func isEqual(_ another: AnyObject?) -> Bool {
        if another === self {
            return true
        } else if let another = another as? LCDate {
            return (another.value as NSDate).isEqual(to: value)
        } else {
            return false
        }
    }

    public var JSONValue: AnyObject {
        return [
            "__type": "Date",
            "iso": ISOString
        ]
    }

    public var JSONString: String {
        return ObjectProfiler.getJSONString(self)
    }

    var LCONValue: AnyObject? {
        return JSONValue
    }

    static func instance() -> LCType {
        return self.init()
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
