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
    static func triggerEvent()
    static func reset()
    static func fulfill(completion: @escaping (Bool) -> Void)
}

extension ScenarioProtocol {
    static var minEventsRequired: Int? {
        return nil
    }
    static var maxEventsPermitted: Int? {
        return nil
    }
    
    static func triggerEvent() {
        let newCount = currentEventsCount + 1
        userDefaults.setValuesForKeys([kDefaultsCount: newCount])
        userDefaults.synchronize()
    }
    
    static func fulfill(completion: @escaping (Bool) -> Void) {
        let currentCount = currentEventsCount
        print(currentCount)
        if let max = maxEventsPermitted, let min = minEventsRequired {
            completion((max >= currentCount) && (min <= currentCount))
        } else if let max = maxEventsPermitted {
            completion(max >= currentCount)
        } else if let min = minEventsRequired {
            completion(min <= currentCount)
        } else {
            completion(true)
        }
    }
    
    static func reset() {
        userDefaults.removeObject(forKey: kDefaultsCount)
        userDefaults.synchronize()
    }
    
    private static var currentEventsCount: Int {
        let currentCount = userDefaults.value(forKey: kDefaultsCount)
        var count = 0
        
        if(currentCount != nil) {
          count = currentCount as! Int
        }
        
        return count
    }
    
    private static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private static var kDefaultsBase: String {
        return "net.pabloweb.WaitForIt.\(String(describing: self))"
    }
    
    private static var kDefaultsCount: String {
        return "\(kDefaultsBase).eventsCount"
    }
}
