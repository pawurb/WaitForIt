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

struct WaitForIt {
    let scenario: ScenarioProtocol
    private let kDefaultsBase = "net.pabloweb.WaitForIt."
    
    var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    init(scenario: ScenarioProtocol) {
        self.scenario = scenario
    }
    
    func triggerEvent() {
        incrementEventsCount()
    }
    
    func fulfill(completion: @escaping (Bool) -> Void) {
        let currentCount = getCurrentEventsCount()
        print(currentCount)
        if let max = scenario.maxEventsCount, let min = scenario.minEventsCount {
            completion((max >= currentCount) && (min < currentCount))
        } else if let max = scenario.maxEventsCount {
            completion(max >= currentCount)
        } else if let min = scenario.minEventsCount {
            completion(min <= currentCount)
        } else {
            completion(false)
        }
    }
    
    func reset() {
        userDefaults.removeObject(forKey: kDefaultsCount())
        userDefaults.synchronize()
    }
    
    private func incrementEventsCount() {
        let newCount = getCurrentEventsCount() + 1
        userDefaults.setValuesForKeys([kDefaultsCount(): newCount])
        userDefaults.synchronize()
    }
    
    private func getCurrentEventsCount() -> Int {
        let currentCount = userDefaults.value(forKey: kDefaultsCount())
        var count = 0
        
        if(currentCount != nil) {
          count = currentCount as! Int
        }
        
        return count
    }
    
    private func kDefaultsCount() -> String {
        return kDefaultsBase + String(describing: scenario)
    }
}
