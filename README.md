# WaitForIt [![Build Status](https://travis-ci.org/pawurb/WaitForIt.svg)](https://travis-ci.org/pawurb/WaitForIt) [![Pod version](https://badge.fury.io/co/WaitForIt.svg)](https://badge.fury.io/co/WaitForIt) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

**WaitForIt** makes implementing a common iOS app scenarios a breeze:

- *"Display a tutorial screen only when user launches an app for the first time."*
- *"Ask user for a review, but only if he installed the app more then two weeks ago and launched it at least 5 times."*
- *"Ask registered user to buy a subscription once every 3 days, but no more then 5 times in total."*

Dealing with this kind of logic usually involves manually saving data to `UserDefaults` and has to be redone from scratch for each scenario.

## Usage

**WaitForIt** provides a simple declarative API allowing you to handle most of the possible scenarios without worrying about underlaying implementation.

`ScenarioProtocol` has the following properties which can be used to define when a scenario should be executed:
``` swift
protocol ScenarioProtocol {
    // minimum number of scenario events needed to be trigerred before scenario can be executed
    static var minEventsRequired: Int? { get }

    // maximum number of scenario events which can be trigerred before scenario stops executing
    static var maxEventsPermitted: Int? { get }

    // maximum number of times that scenario can be executed
    static var maxExecutionsPermitted: Int? { get }

    // minimum time interval, after the first scenario event was trigerred, before the scenario can be executed
    static var minSecondsSinceFirstEvent: TimeInterval? { get }

    // minimum time interval before scenario can be executed again after previous execution
    static var minSecondsBetweenExecutions: TimeInterval? { get }

    // custom conditions closure
    static var customConditions: (() -> Bool)? { get }
}
```

Scenario is a simple struct which conforms to the `ScenarioProtocol`. You configure all the values which determine when the following scenario will execute. To avoid possible typos you need to define all the properties. All of them being optionals you declare ones that you don't want to use as `nil`.

You can operate on a scenario struct using static methods:

``` swift
    // increment scenario specific event counter
    static func triggerEvent()

    // try to execute a scenario (it counts as executed only if bool param passed into a block was `true`)
    static func tryToExecute(completion: @escaping (Bool) -> Void)

    // reset scenario event and execution counters
    static func reset()
```

### Basic example

Let's say you want to display a tutorial screen only once:

``` swift
import WaitForIt

struct ShowTutorial: ScenarioProtocol {
    static var maxExecutionsPermitted: Int? = 1

    static var maxEventsPermitted: Int? = nil
    static var minEventsRequired: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var customConditions: (() -> Bool)? = nil
}

// In ViewController.swift
func viewDidLoad() {
    super.viewDidLoad()
    ShowTutorial.tryToExecute { didExecute in
        if didExecute {
            self.showTutorial()
        }
    }
}
```

That's it! You no longer need to deal with `UserDefaults` yourself. Just declare a struct with correct execution conditions, and lib takes care of the rest. When all the conditions for your scenario are fulfilled, bool value passed inside the `tryToExecute` block will be `true`.

### More conditions

Let's try a bit more complex scenario. You want to ask user to buy a subscription, if he installed an app at least 1 week ago and turned it on at least 5 times. You want to ask him once every 2 days but no more then 4 times in total:

``` swift
import WaitForIt

struct AskToSubscribe: ScenarioProtocol {
    static var minEventsRequired: Int? = 5
    static var minSecondsSinceFirstEvent: TimeInterval? = 604 800 // seconds in one week
    static var maxExecutionsPermitted: Int? = 4
    static var minSecondsBetweenExecutions: Int? = 172 800 // seconds in two days

    static var maxEventsPermitted: Int? = nil
    static var customConditions: (() -> Bool)? = nil
}

// In AppDelegate.swift
func application(_ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    AskToSubscribe.triggerEvent()
    AskToSubscribe.tryToExecute { didExecute in
        if didExecute {
            self.askToSubscribe()
        }
    }

    return true
}

```

### Custom conditions

If time and event count based conditions are not enough for your scenario you can also define a custom conditions closure. It will be evaluated every time you try to execute a scenario:

``` swift
struct ShowLowBrightnessAlertOnce: ScenarioProtocol {
    static var customConditions: (() -> Bool)? = {
        return UIScreen.main.brightness < 0.3
    }
    static var maxExecutionsPermitted: Int? = 1

    static var minEventsRequired: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: Int? = nil
    static var maxEventsPermitted: Int? = nil
}
```

Even more complex stories could be implemented if you decided to mix conditions from more then one scenario struct. Of course you could also scatter event triggers and scenario executions throughout the app, they don't need to be in the same file.

Implementation is based upon standard `UserDefaults` so data will not persist if app is reinstalled. `UserDefaults` key names are generated with struct names, so renaming the struct will reset all its data. You can also reset persisted data using `reset()` method.

## Installation

### Carthage

In your `Cartfile`:

```ogdl
github "pawurb/WaitForIt" ~> 1.1.0
```

### Cocoapods

In your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!

target 'TargetName' do
  pod 'WaitForIt'
end
```

## Status

Lib is used in production but it is still in an early stage of development. Suggestions on how it could be improved are welcome.


