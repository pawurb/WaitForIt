
``` swift
protocol ScenarioProtocol {
  var maxEventsCountPermitted: Int? { get }
  var minEventsCountRequired: Int? { get }
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
