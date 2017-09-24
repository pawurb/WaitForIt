# WaitForIt

WaitForIt helps solving a common iOS apps development cases, like:

- *"Display a tutorial screen only when user launches an app for the first time"*
- *"Ask user for a review, but only if he installed the app more then two weeks ago and launched it at least 5 times"*
- *"Ask user to buy a subscription every 3 days, but only if he read at least 5 articles."*

Dealying with this kind logic usually involves saving some data to UserDefaults and usually has to be redone from scratch for each use case.

**WaitForIt** provides a simple api allowing you to handle most of the common scenarios without worrying about underlaying mechanism.

To use it you just declare so called *scenario struct* and provide attributes determining when a scenario should be fulfilled. Let's say you want to display a tutorial screen only once:

``` swift
struct ShowTutorial: ScenarioProtocol {
  static var maxEventsPermitted: Int? = 0
}

func viewDidLoad() {
  super.viewDidLoad()
  let scenario = ShowTutorial.self
  scenario.fulfill { shouldFulfill in
      if shouldFulfill {
          scenario.triggerEvent()
          self.showTutorial()
      }
  }
}
```

That's it! No need to play with UserDefaults, you just have to declare a struct with correct fulfillment conditions, and lib takes care of the rest.

