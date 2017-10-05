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
        let newCount = currentEventsCount + 1
        userDefaults.setValuesForKeys([kDefaultsEventsCount: newCount])
        
        if userDefaults.object(forKey: kDefaultsFirstEventDate) == nil {
            userDefaults.setValuesForKeys([kDefaultsFirstEventDate: timeNow])
        }
        userDefaults.setValuesForKeys([kDefaultsLastEventDate: timeNow])
        
        userDefaults.synchronize()
    }
    
    static func tryToExecute(timeNow: Date, completion: @escaping (Bool) -> Void) {
        config()
        print(ConfigStorage.values)
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

        let currentCount = currentEventsCount
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
            let firstEventDate = currentFirstEventDate {
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
            let lastEventDate = currentLastEventDate {
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
            result = currentExecutionsCount < maxExecutions
        } else {
            result = true
        }
        
        return result
    }
    
    private static func checkExecutionDateConditions(timeNow: Date) -> Bool {
        let result: Bool
        
        if let minSecondsInterval = minSecondsBetweenExecutions,
            let lastExecutionDate = currentLastExecutionDate {
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
        [
            kDefaultsEventsCount,
            kDefaultsExecutionsCount,
            kDefaultsFirstEventDate,
            kDefaultsLastEventDate,
            kDefaultsLastExecutionDate
        ].forEach { key in
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.synchronize()
    }
    
    static var currentEventsCount: Int {
        let currentCount = userDefaults.value(forKey: kDefaultsEventsCount)
        var count = 0
        
        if(currentCount != nil) {
          count = currentCount as! Int
        }
        
        return count
    }
    
    static var currentExecutionsCount: Int {
        let currentCount = userDefaults.value(forKey: kDefaultsExecutionsCount)
        var count = 0
        
        if(currentCount != nil) {
          count = currentCount as! Int
        }
        
        return count
    }
    
    private static func incrementExecutionsCounter() {
        let newCount = currentExecutionsCount + 1
        userDefaults.setValuesForKeys([kDefaultsExecutionsCount: newCount])
        userDefaults.synchronize()
    }
    
    private static func saveLastExecutionDate(timeNow: Date) {
        userDefaults.setValuesForKeys([kDefaultsLastExecutionDate: timeNow])
        userDefaults.synchronize()
    }
    
    static var currentFirstEventDate: Date? {
        return userDefaults.object(forKey: kDefaultsFirstEventDate) as? Date
    }
    
    static var currentLastEventDate: Date? {
        return userDefaults.object(forKey: kDefaultsLastEventDate) as? Date
    }
    
    static var currentLastExecutionDate: Date? {
        return userDefaults.object(forKey: kDefaultsLastExecutionDate) as? Date
    }
    
    private static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private static var kDefaultsBase: String {
        return "net.pabloweb.WaitForIt.\(String(describing: self))"
    }
    
    private static var kDefaultsEventsCount: String {
        return "\(kDefaultsBase).eventsCount"
    }
    
    private static var kDefaultsExecutionsCount: String {
        return "\(kDefaultsBase).executionsCount"
    }
    
    private static var kDefaultsFirstEventDate: String {
        return "\(kDefaultsBase).firstEventDate"
    }
    
    private static var kDefaultsLastEventDate: String {
        return "\(kDefaultsBase).lastEventDate"
    }
    
    private static var kDefaultsLastExecutionDate: String {
        return "\(kDefaultsBase).lastExecutionDate"
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
}
