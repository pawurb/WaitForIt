//
//  WaitForIt.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 23/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation

protocol ScenarioProtocol {
    var minEventsCount: Int? { get }
    var maxEventsCount: Int? { get }
}

extension ScenarioProtocol  {
    func triggerEvent() {
        let newCount = getCurrentEventsCount() + 1
        userDefaults.setValuesForKeys([kDefaultsCount: newCount])
        userDefaults.synchronize()
    }
    
    func fulfill(completion: @escaping (Bool) -> Void) {
        let currentCount = getCurrentEventsCount()
        print(currentCount)
        if let max = maxEventsCount, let min = minEventsCount {
            completion((max >= currentCount) && (min <= currentCount))
        } else if let max = maxEventsCount {
            completion(max > currentCount)
        } else if let min = minEventsCount {
            completion(min <= currentCount)
        } else {
            completion(true)
        }
    }
    
    func reset() {
        userDefaults.removeObject(forKey: kDefaultsCount)
        userDefaults.synchronize()
    }
    
    private func getCurrentEventsCount() -> Int {
        let currentCount = userDefaults.value(forKey: kDefaultsCount)
        var count = 0
        
        if(currentCount != nil) {
          count = currentCount as! Int
        }
        
        return count
    }
    
    private var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private var kDefaultsBase: String {
        return "net.pabloweb.WaitForIt.\(String(describing: self))"
    }
    
    private var kDefaultsCount: String {
        return "\(kDefaultsBase).eventsCount"
    }
}
