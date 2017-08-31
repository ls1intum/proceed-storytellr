# Proceed-StoryTellr

[![Version](https://img.shields.io/cocoapods/v/Prototyper.svg?style=flat)](http://cocoapods.org/pods/Prototyper)
[![License](https://img.shields.io/cocoapods/l/Prototyper.svg?style=flat)](http://cocoapods.org/pods/Prototyper)
[![Platform](https://img.shields.io/cocoapods/p/Prototyper.svg?style=flat)](http://cocoapods.org/pods/Prototyper)

## Remarks

This project is a fork of the [Prototyper Pod](https://github.com/ls1intum/proceed-prototyper). For further information about the functionality of Prototyper and its use, visit the Github Page.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

To use the Prototyper framework you need an account for the [Prototyper online service](https://prototyper-bruegge.in.tum.de).
Create a scenario that can be used for testing the app. Per scenario step, you can define questions that you want to be displayed to the user.
Use the feedback button to give feedback that will be displayed on the [Prototyper online service](https://prototyper-bruegge.in.tum.de).

## Installation

1. Integrate Prototyper Cocoapod

    ```swift
    pod 'Prototyper', :git => 'https://github.com/ls1intum/proceed-storytellr.git', :branch => 'develop'
    ```

2. Create your scenario file as json. The format of it needs to be the following

    ```json
    {
        "id": "yourScenarioId",
        "isCompleted": false,
        "userFeedback": "",
        "steps": [{
                  "stepNumber": 1,
                  "stepDescription": "<Desciption for step 1>",
                  "questions": [{
                                "questionDescription": "<Desciption for question 1>",
                                "answer" : ""
                                }
                                ]
                  }
                  ]
    }
    ```

    Note: `"steps"` and `"questions"` are arrays and can be extended to hold as many items as needed for your scenario.

3. Display the feedback button in the `applicationDidFinishLaunchingWithOptions` method of your `AppDelegate`. Don't forget to import the Prototyper framework. In this method, you also have to set the scenario json file and pass it to Prototyper. 

    ```swift
        import Prototyper
    ```

    ```swift
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            PrototypeController.sharedInstance.showFeedbackButton(true)
          StoryTellrController.sharedInstance.filename = "<scenarioFileName>"
            
            return true
        }
    ```

4. Set the scenario step number for every View Controller that should contain a step. Note: It is necessary to reset the step when the view is about to disappear to avoid side-effects like step numbers set on the wrong View Controller.

    ```swift
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            StoryTellrController.sharedInstance.currentScenarioStepNumber = 1
        }
    ```

    ```swift
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            StoryTellrController.sharedInstance.resetCurrentStep()
        }
    ```

## Author

Chair of Applied Software Engineering, ios@in.tum.de

Lara Marie Reimer, [@laramarie](https://github.com/laramarie)

### Authors of the Prototyper Pod

Paul Schmiedmayer, [@PSchmiedmayer](https://twitter.com/pschmiedmayer)
Stefan Kofler, grafele@gmail.com

## License

Prototyper is available under the MIT license. See the LICENSE file for more info.
