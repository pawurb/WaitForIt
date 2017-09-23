
``` swift
protocol ScenarioProtocol {
  var maxEventsCount: Int? { get }
  var minEventsCount: Int? { get }
}

enum MyScenarios {
  case showTutorial
  case askForReview
}

extension MyScenarios: ScenarioProtocol {
  var maxEventsCount: Int? {
    switch self {
      case .showTutorial:
        return 1 // condition will be met only if no scenario events has been triggered yet
      case .askForReview:
        return nil
    }
  }

  var minEventsCount: Int? {
    switch self {
      case .showTutorial:
        return nil
      case .askForReview:
        return 5 // condition will be met only if at least 5 scenario events has been triggered before
    }
  }
}

let scenarioHandler = WaitForIt(scenario: .askForReview)
scenarioHandler.triggerEvent()

scenarioHandler.fulfill { conditionsMet in
  if conditionsMet  {
    //DO STUFF
  }
}

```
