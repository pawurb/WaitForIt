# WaitForIt

WaitForIt helps solving a common iOS apps development cases, like:

- *"Display a tutorial screen only when user launches an app for the first time"*
- *"Ask user for a review, but only if he installed the app more then two weeks ago and launched it at least 5 times"*
- *"Ask user to buy a subscription every 3 days, but only if he read at least 5 articles."*

Dealying with this kind logic usually involves saving some data to UserDefaults and usually has to be redone from scratch for each use case.

**WaitForIt** provides a simple api allowing you to handle most of the common scenarios without worrying about underlaying mechanism.

To use it you just declare so called *scenario struct* and provide attributes determining when a scenario should be executeed. Let's say you want to display a tutorial screen only once:

``` swift
struct ShowTutorial: ScenarioProtocol {
  static var maxEventsPermitted: Int? = 0
}

// In some ViewController.swift
func viewDidLoad() {
    super.viewDidLoad()
    let scenario = ShowTutorial.self
    scenario.execute { shouldexecute in
        if shouldexecute {
            scenario.triggerEvent()
            self.showTutorial()
        }
    }
}
```

That's it! No need to play with UserDefaults, you just have to declare a struct with correct executement conditions, and lib takes care of the rest.

Let's try a different scenario. You want to ask user for a review, if he installed an app at least 1 week ago and turned it on at least 5 times:

``` swift
struct ShowTutorial: ScenarioProtocol {
  static var minEventsRequired: Int? = 5
  static var minSecondsSinceFirstEvent: TimeInterval? = 604 800 // seconds in one week
}

// In AppDelegate.swift
    func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let scenario = ShowTutorial.self
        scenario.triggerEvent()
        scenario.execute { shouldexecute in
            if shouldexecute {
                SKStoreReviewController.requestReview()
            }
        }

        return true
    }

```

