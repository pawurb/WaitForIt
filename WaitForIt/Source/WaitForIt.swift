//
//  WaitForIt.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 23/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation

protocol ScenarioProtocol {
    static var minEventsRequired: Int? { get }
    
    static var maxEventsPermitted: Int? { get }
    
    static var maxExecutionsPermitted: Int? { get }
    
    static var minSecondsSinceFirstEvent: TimeInterval? { get }
    
    static func triggerEvent(timeNow: Date)
    
    static func triggerEvent()
    
    static func reset()
    
    static func execute(timeNow: Date, completion: @escaping (Bool) -> Void)
    
    static func execute(completion: @escaping (Bool) -> Void)
}

extension ScenarioProtocol {
    static var minEventsRequired: Int? {
        return nil
    }
    
    static var maxEventsPermitted: Int? {
        return nil
    }
    
    static var maxExecutionsPermitted: Int? {
        return nil
    }
    
    static var minSecondsSinceFirstEvent: TimeInterval? {
        return nil
    }
    
    static func triggerEvent() {
        triggerEvent(timeNow: Date())
    }
    
    static func triggerEvent(timeNow: Date) {
        let newCount = currentEventsCount + 1
        userDefaults.setValuesForKeys([kDefaultsEventsCount: newCount])
        
        if userDefaults.object(forKey: kDefaultsFirstEventDate) == nil {
            userDefaults.setValuesForKeys([kDefaultsFirstEventDate: timeNow])
        }
        
        userDefaults.synchronize()
    }
    
    static func execute(timeNow: Date, completion: @escaping (Bool) -> Void) {
        let currentCount = currentEventsCount
        
        var countBasedConditions: Bool
        
        if let max = maxEventsPermitted, let min = minEventsRequired {
            countBasedConditions = (max >= currentCount) && (min <= currentCount)
        } else if let max = maxEventsPermitted {
            countBasedConditions = max >= currentCount
        } else if let min = minEventsRequired {
            countBasedConditions = min <= currentCount
        } else {
            countBasedConditions = true
        }
        
        var dateBasedConditions: Bool
        
        if let minSecondsInterval = minSecondsSinceFirstEvent,
            let firstEventDate = currentFirstEventDate {
            let secondsSinceFirstEvent = timeNow.timeIntervalSince1970 - firstEventDate.timeIntervalSince1970
            print(secondsSinceFirstEvent)
            
            dateBasedConditions = secondsSinceFirstEvent > minSecondsInterval
        } else {
            dateBasedConditions = true
        }
        
        completion(countBasedConditions && dateBasedConditions)
    }
    
    
    static func execute(completion: @escaping (Bool) -> Void) {
        execute(timeNow: Date(), completion: completion)
    }
    
    static func reset() {
        [
            kDefaultsEventsCount,
            kDefaultsExecutionsCount,
            kDefaultsFirstEventDate
        ].forEach { key in
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.synchronize()
    }
    
    private static var currentEventsCount: Int {
        let currentCount = userDefaults.value(forKey: kDefaultsEventsCount)
        var count = 0
        
        if(currentCount != nil) {
          count = currentCount as! Int
        }
        
        return count
    }
    
    private static var currentFirstEventDate: Date? {
        return userDefaults.object(forKey: kDefaultsFirstEventDate) as? Date
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
}
