# WaitForIt

**WaitForIt** simplifies implementing common app development scenarios, like:

- *"Display a tutorial screen when user launches an app for the first time."*
- *"Ask user for a review, but only if he installed the app more then two weeks ago and launched it at least 5 times."*
- *"Ask user to buy a subscription once every 3 days, but no more then 5 times in total."*

Dealing with this kind logic usually involves manually saving data to `UserDefaults` and has to be redone from scratch for each scenario.

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
}
```

Scenario is a simple struct which conforms to the protocol. You configure all the values which determine when the following scenario will execute. To avoid possible typos you need to define all the properties. All of them being optionals you declare ones that you don't want to use as `nil`.

You can operate on a scenario struct using three static methods:

``` swift
    // increment scenario specific event counter
    static func triggerEvent()

    // try to execute a scenario
    // Scenario counts as executed only if bool param passed into a block was `true`
    static func execute(completion: @escaping (Bool) -> Void)

    // reset scenario event and execution counters
    static func reset()
```

Let's say you want to display a tutorial screen only once:

``` swift
struct ShowTutorial: ScenarioProtocol {
    static var maxExecutionsPermitted: Int? = 1

    static var maxEventsPermitted: Int? = nil
    static var maxExecutionsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
}

// In ViewController.swift
func viewDidLoad() {
    super.viewDidLoad()
    ShowTutorial.execute { shouldExecute in
        if shouldExecute {
            self.showTutorial()
        }
    }
}
```

That's it! You no more need to deal with `UserDefaults` yourself. Just declare a struct with correct execution conditions, and lib takes care of the rest. When all the conditions for your scenario are fulfilled, bool value passed inside the `execute` block will be `true`.

Let's try a bit more complex scenario. You want to ask user to buy a subscription, if he installed an app at least 1 week ago and turned it on at least 5 times. You want to ask him once every 3 days but no more then 4 times in total:

``` swift
struct AskToSubscribe: ScenarioProtocol {
    static var minEventsRequired: Int? = 5
    static var minSecondsSinceFirstEvent: TimeInterval? = 604 800 // seconds in one week
    static var maxExecutionsPermitted: Int? = 4
    static var minSecondsBetweenExecutions: Int? = 172 800 // seconds in two days

    static var maxEventsPermitted: Int? = nil
}

// In AppDelegate.swift
func application(_ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    AskToSubscribe.triggerEvent()
    AskToSubscribe.execute { shouldExecute in
        if shouldExecute {
            self.askToSubscribe()
        }
    }

    return true
}

```



