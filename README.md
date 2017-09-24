# WaitForIt

WaitForIt simplifies implementing common app development scenarios, like:

- *"Display a tutorial screen when user launches an app for the first time"*
- *"Ask user for a review, but only if he installed the app more then two weeks ago and launched it at least 5 times"*
- *"Ask user to buy a subscription once every 3 days, but no more then 5 times in total"*

Dealing with this kind logic usually involves saving data to `UserDefaults` and usually has to be redone from scratch for each scenario.

**WaitForIt** provides a simple api allowing you to handle most of the possible scenarios without worrying about underlaying mechanism.

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

    // minimum time interval before scenario can be executed after previous execution
    static var minSecondsBetweenExecutions: TimeInterval? { get }
}
```

Scenario is a simple struct which conforms to the protocol. You can configure all the values which determine when the following scenario will execute. To avoid possible typos you need to define all the properties. All of them being optionals you just have to declare ones that you don't want to use as `nil`.

Let's say you want to display a tutorial screen only once:

``` swift
struct ShowTutorial: ScenarioProtocol {
    static var maxExecutionsPermitted: Int? = 1

    static var maxEventsPermitted: Int? = nil
    static var maxExecutionsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
}

// In some ViewController.swift
func viewDidLoad() {
    super.viewDidLoad()
    ShowTutorial.execute { shouldExecute in
        if shouldExecute {
            self.showTutorial()
        }
    }
}
```

That's it! No no more need to deal with `UserDefaults` yourself. Just declare a struct with correct executement conditions, and lib takes care of the rest. When all the conditions for your scenario are fulfilled bool value passed inside the `execute` block is be `true`.

Let's try a different scenario. You want to ask user for a review, if he installed an app at least 1 week ago and turned it on at least 5 times. After that you want to ask him once every 3 days but no more then 4 times in total:

``` swift
struct ShowTutorial: ScenarioProtocol {
    static var minEventsRequired: Int? = 5
    static var minSecondsSinceFirstEvent: TimeInterval? = 604 800 // seconds in one week
    static var maxExecutionsPermitted: Int? = 3
    static var minSecondsBetweenExecutions: Int? = 172 800 // seconds in two days

    static var maxExecutionsPermitted: Int? = nil
}

// In AppDelegate.swift
    func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        ShowTutorial.triggerEvent()
        ShowTutorial.execute { shouldExecute in
            if shouldExecute {
                self.askForReview()
            }
        }

        return true
    }

```

