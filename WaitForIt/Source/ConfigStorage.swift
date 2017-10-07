//
//  ConfigStorage.swift
//  WaitForIt
//
//  Created by Pawel Urbanek on 07/10/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation

fileprivate struct MemoryStorage {
    static var values: [String: Any?] = [:]
}

internal struct ConfigStorage<T> {
    var customConditions: (() -> Bool)? {
        get {
            return MemoryStorage.values[customConditionsKey] as? (() -> Bool)
        }
        set {
            MemoryStorage.values[customConditionsKey] = newValue
        }
    }

    var maxExecutionsPermitted: Int? {
        get {
            return MemoryStorage.values[maxExecutionsPermittedKey] as? Int
        }
        set {
            MemoryStorage.values[maxExecutionsPermittedKey] = newValue
        }
    }

    var minEventsRequired: Int? {
        get {
            return MemoryStorage.values[minEventsRequiredKey] as? Int
        }
        set {
            MemoryStorage.values[minEventsRequiredKey] = newValue
        }
    }

    var minSecondsBetweenExecutions: TimeInterval? {
        get {
            return MemoryStorage.values[minSecondsBetweenExecutionsKey] as? TimeInterval
        }
        set {
            MemoryStorage.values[minSecondsBetweenExecutionsKey] = newValue
        }
    }

    var maxEventsPermitted: Int? {
        get {
            return MemoryStorage.values[maxEventsPermittedKey] as? Int
        }
        set {
            MemoryStorage.values[maxEventsPermittedKey] = newValue
        }
    }

    var minSecondsSinceFirstEvent: TimeInterval? {
        get {
            return MemoryStorage.values[minSecondsSinceFirstEventKey] as? TimeInterval
        }
        set {
            MemoryStorage.values[minSecondsSinceFirstEventKey] = newValue
        }
    }

    var minSecondsSinceLastEvent: TimeInterval? {
        get {
            return MemoryStorage.values[minSecondsSinceLastEventKey] as? TimeInterval
        }
        set {
            MemoryStorage.values[minSecondsSinceLastEventKey] = newValue
        }
    }
    
    private var kConfigBase: String {
        return String(describing: type(of: T.self))
    }

    private var customConditionsKey: String {
        return "\(kConfigBase).customConditions"
    }

    private var maxExecutionsPermittedKey: String {
        return "\(kConfigBase).maxExecutionsPermitted"
    }

    private var minEventsRequiredKey: String {
        return "\(kConfigBase).minEventsRequired"
    }

    private var minSecondsBetweenExecutionsKey: String {
        return "\(kConfigBase).minSecondsBetweenExecutions"
    }

    private var maxEventsPermittedKey: String {
        return "\(kConfigBase).maxEventsPermitted"
    }

    private var minSecondsSinceFirstEventKey: String {
        return "\(kConfigBase).minSecondsSinceFirstEvent"
    }

    private var minSecondsSinceLastEventKey: String {
        return "\(kConfigBase).minSecondsSinceLastEvent"
    }

}
