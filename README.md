# WaitForIt

WaitForIt helps solving a common iOS apps development cases, like:

- *"Display a tutorial screen only when user launches an app for the first time"*
- *"Ask user for a review, but only if he installed the app more then two weeks ago and launched it at least 5 times"*
- *"Ask user to buy a subscription every 3 days, but only if he read at least 5 articles."*

Dealying with this kind logic usually involves saving some data to UserDefaults and usually has to be redone from scratch for each use case.

**WaitForIt** provides a simple api allowing you to handle most of the common scenarios without worrying about underlaying mechanism.

To use it you just declare so called *scenario* and provide attributes determining when a scenario should be fulfilled. Let's say you want to display a tutorial screen only once:

```


```


``` swift

struct ShowTutorial: ScenarioProtocol {
  var minEventsCountRequired: Int? { nil }


}

enum MyScenario {
  case showTutorial
  case askForReview
}

extension MyScenarios: ScenarioProtocol {
  var minEventsCountRequired: Int? {
    switch self {
      case .showTutorial:
        return nil
      case .askForReview:
        return 5 // condition will be met only if at least 5 scenario events has been triggered before
    }
  }

  var maxEventsCountPermitted: Int? {
    switch self {
      case .showTutorial:
        return 0 // condition will be met only if no scenario events has been triggered yet
      case .askForReview:
        return nil
    }
  }
}

let scenario = MyScenario.askForReview
scenario.triggerEvent()

scenario.fulfill { conditionsMet in
  if conditionsMet  {
    //DO STUFF
  }
}

```
