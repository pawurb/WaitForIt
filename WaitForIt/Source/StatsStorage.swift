//
//  StatsStorage.swift
//  WaitForIt
//
//  Created by Pawel Urbanek on 07/10/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation

struct StatsStorage<T> {
    private let userDefaults = UserDefaults.standard

    func reset() {
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

    func saveEventStats(timeNow: Date) {
        let newCount = currentEventsCount + 1
        userDefaults.setValuesForKeys([kDefaultsEventsCount: newCount])
        
        if userDefaults.object(forKey: kDefaultsFirstEventDate) == nil {
            userDefaults.setValuesForKeys([kDefaultsFirstEventDate: timeNow])
        }
        userDefaults.setValuesForKeys([kDefaultsLastEventDate: timeNow])
        
        userDefaults.synchronize()
    }
    
    var currentFirstEventDate: Date? {
        return userDefaults.object(forKey: kDefaultsFirstEventDate) as? Date
    }
    
    var currentLastEventDate: Date? {
        return userDefaults.object(forKey: kDefaultsLastEventDate) as? Date
    }
    
    var currentLastExecutionDate: Date? {
        return userDefaults.object(forKey: kDefaultsLastExecutionDate) as? Date
    }

    var currentExecutionsCount: Int {
        let currentCount = userDefaults.value(forKey: kDefaultsExecutionsCount)
        var count = 0

        if(currentCount != nil) {
            count = currentCount as! Int
        }

        return count
    }

    var currentEventsCount: Int {
        let currentCount = userDefaults.value(forKey: kDefaultsEventsCount)
        var count = 0

        if(currentCount != nil) {
            count = currentCount as! Int
        }

        return count
    }

    func incrementExecutionsCounter() {
        let newCount = currentExecutionsCount + 1
        userDefaults.setValuesForKeys([kDefaultsExecutionsCount: newCount])
        userDefaults.synchronize()
    }
    
    func saveLastExecutionDate(timeNow: Date) {
        userDefaults.setValuesForKeys([kDefaultsLastExecutionDate: timeNow])
        userDefaults.synchronize()
    }

    private var kDefaultsBase: String {
        return "net.pabloweb.WaitForIt.\(String(describing: T.self))"
    }
    
    private var kDefaultsEventsCount: String {
        return "\(kDefaultsBase).eventsCount"
    }
    
    private var kDefaultsExecutionsCount: String {
        return "\(kDefaultsBase).executionsCount"
    }
    
    private var kDefaultsFirstEventDate: String {
        return "\(kDefaultsBase).firstEventDate"
    }
    
    private var kDefaultsLastEventDate: String {
        return "\(kDefaultsBase).lastEventDate"
    }
    
    private var kDefaultsLastExecutionDate: String {
        return "\(kDefaultsBase).lastExecutionDate"
    }
}
