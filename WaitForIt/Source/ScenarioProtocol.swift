//
//  WaitForIt.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 23/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation

public protocol ScenarioProtocol {
    static func config()

    // minimum number of scenario events needed to be trigerred before scenario can be executed
    static var minEventsRequired: Int? { get set }

    // maximum number of scenario events which can be trigerred before scenario stops executing
    static var maxEventsPermitted: Int? { get set }
    
    // maximum number of times that scenario can be executed
    static var maxExecutionsPermitted: Int? { get set }
    
    // minimum time interval, after the first scenario event was trigerred, before the scenario can be executed
    static var minSecondsSinceFirstEvent: TimeInterval? { get set }
    
    // minimum time interval, after the last scenario event was trigerred, before the scenario can be executed
    static var minSecondsSinceLastEvent: TimeInterval? { get set }
    
    // minimum time interval before scenario can be executed again after previous execution
    static var minSecondsBetweenExecutions: TimeInterval? { get set }

    // custom conditions closure
    static var customConditions: (() -> Bool)? { get set }
    
    // increment scenario specific event counter
    static func triggerEvent()
    
    // same as above but you can mock current date, used internally for testing
    static func triggerEvent(timeNow: Date)
    
    // try to execute a scenario (it counts as executed only if bool param passed into a block was `true`)
    static func tryToExecute(completion: @escaping (Bool) -> Void)
    
    // same as above but you can mock current date, used internally for testing
    static func tryToExecute(timeNow: Date, completion: @escaping (Bool) -> Void)
    
    // reset scenario event and execution counters
    static func reset()
}

fileprivate struct ConfigStorage {
    static var values: [String: Any?] = [:]
}

struct Storage<T> {
    static func call() {
        print(String(describing: self))
    }
}

public extension ScenarioProtocol {

    static var customConditions: (() -> Bool)? {
        get {
            return ConfigStorage.values[customConditionsKey] as? (() -> Bool)
        }
        set {
            ConfigStorage.values[customConditionsKey] = newValue
        }
    }

    static var maxExecutionsPermitted: Int? {
        get {
            return ConfigStorage.values[maxExecutionsPermittedKey] as? Int
        }
        set {
            ConfigStorage.values[maxExecutionsPermittedKey] = newValue
        }
    }

    static var minEventsRequired: Int? {
        get {
            return ConfigStorage.values[minEventsRequiredKey] as? Int
        }
        set {
            ConfigStorage.values[minEventsRequiredKey] = newValue
        }
    }

    static var minSecondsBetweenExecutions: TimeInterval? {
        get {
            return ConfigStorage.values[minSecondsBetweenExecutionsKey] as? TimeInterval
        }
        set {
            ConfigStorage.values[minSecondsBetweenExecutionsKey] = newValue
        }
    }

    static var maxEventsPermitted: Int? {
        get {
            return ConfigStorage.values[maxEventsPermittedKey] as? Int
        }
        set {
            ConfigStorage.values[maxEventsPermittedKey] = newValue
        }
    }

    static var minSecondsSinceFirstEvent: TimeInterval? {
        get {
            return ConfigStorage.values[minSecondsSinceFirstEventKey] as? TimeInterval
        }
        set {
            ConfigStorage.values[minSecondsSinceFirstEventKey] = newValue
        }
    }

    static var minSecondsSinceLastEvent: TimeInterval? {
        get {
            return ConfigStorage.values[minSecondsSinceLastEventKey] as? TimeInterval
        }
        set {
            ConfigStorage.values[minSecondsSinceLastEventKey] = newValue
        }
    }

    static func triggerEvent() {
        triggerEvent(timeNow: Date())
    }
    
    static func triggerEvent(timeNow: Date) {
        config()
        stats.saveEventStats(timeNow: timeNow)
    }
    
    static func tryToExecute(timeNow: Date, completion: @escaping (Bool) -> Void) {
        config()
        let eventCountConditions = checkEventCountConditions()
        let firstEventDateConditions = checkFirstEventDateConditions(timeNow: timeNow)
        let lastEventDateConditions = checkLastEventDateConditions(timeNow: timeNow)
        let executionCountConditions = checkExecutionCountConditions()
        let executionDateConditions = checkExecutionDateConditions(timeNow: timeNow)
        let customConditionsValue = checkCustomConditions()
        
        let finalResult = eventCountConditions && firstEventDateConditions && lastEventDateConditions && executionCountConditions && executionDateConditions && customConditionsValue
        
        if finalResult {
            incrementExecutionsCounter()
            saveLastExecutionDate(timeNow: timeNow)
        }
        
        completion(finalResult)
    }
    
    private static func checkEventCountConditions() -> Bool {
        let result: Bool

        let currentCount = stats.currentEventsCount
        if let max = maxEventsPermitted, let min = minEventsRequired {
            result = (max >= currentCount) && (min <= currentCount)
        } else if let max = maxEventsPermitted {
            result = max >= currentCount
        } else if let min = minEventsRequired {
            result = min <= currentCount
        } else {
            result = true
        }
        
        return result
    }
    
    private static func checkFirstEventDateConditions(timeNow: Date) -> Bool {
        let result: Bool
        
        if let minSecondsInterval = minSecondsSinceFirstEvent,
            let firstEventDate = stats.currentFirstEventDate {
            let secondsSinceFirstEvent = timeNow.timeIntervalSince1970 - firstEventDate.timeIntervalSince1970
            
            result = secondsSinceFirstEvent > minSecondsInterval
        } else {
            result = true
        }
        
        return result
    }
    
    private static func checkLastEventDateConditions(timeNow: Date) -> Bool {
        let result: Bool

        if let minSecondsInterval = minSecondsSinceLastEvent,
            let lastEventDate = stats.currentLastEventDate {
            let secondsSinceLastEvent = timeNow.timeIntervalSince1970 - lastEventDate.timeIntervalSince1970

            result = secondsSinceLastEvent > minSecondsInterval
        } else {
            result = true
        }
        
        return result
    }
    
    private static func checkExecutionCountConditions() -> Bool {
        let result: Bool
        
        if let maxExecutions = maxExecutionsPermitted {
            result = stats.currentExecutionsCount < maxExecutions
        } else {
            result = true
        }
        
        return result
    }
    
    private static func checkExecutionDateConditions(timeNow: Date) -> Bool {
        let result: Bool
        
        if let minSecondsInterval = minSecondsBetweenExecutions,
            let lastExecutionDate = stats.currentLastExecutionDate {
            let secondsSinceLastExecution = timeNow.timeIntervalSince1970 - lastExecutionDate.timeIntervalSince1970
            
            result = secondsSinceLastExecution > minSecondsInterval
        } else {
            result = true
        }
        
        return result
    }
    
    private static func checkCustomConditions() -> Bool {
        let result: Bool
        
        if let customConditionsBlock = customConditions {
            result = customConditionsBlock()
        } else {
            result = true
        }
        
        return result
    }
    
    static func tryToExecute(completion: @escaping (Bool) -> Void) {
        tryToExecute(timeNow: Date(), completion: completion)
    }
    
    static func reset() {
        config()
        stats.reset()
    }
    
    private static func incrementExecutionsCounter() {
        stats.incrementExecutionsCounter()
    }
    
    private static func saveLastExecutionDate(timeNow: Date) {
        stats.saveLastExecutionDate(timeNow: timeNow)
    }
    
    private static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private static var kConfigBase: String {
        return String(describing: type(of: self))
    }

    private static var customConditionsKey: String {
        return "\(kConfigBase).customConditions"
    }

    private static var maxExecutionsPermittedKey: String {
        return "\(kConfigBase).maxExecutionsPermitted"
    }

    private static var minEventsRequiredKey: String {
        return "\(kConfigBase).minEventsRequired"
    }

    private static var minSecondsBetweenExecutionsKey: String {
        return "\(kConfigBase).minSecondsBetweenExecutions"
    }

    private static var maxEventsPermittedKey: String {
        return "\(kConfigBase).maxEventsPermitted"
    }

    private static var minSecondsSinceFirstEventKey: String {
        return "\(kConfigBase).minSecondsSinceFirstEvent"
    }

    private static var minSecondsSinceLastEventKey: String {
        return "\(kConfigBase).minSecondsSinceLastEvent"
    }

    private static var stats: StatsStorage<Self> {
        return StatsStorage<Self>()
    }
}
