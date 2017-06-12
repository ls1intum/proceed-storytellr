# Prototyper

[![Version](https://img.shields.io/cocoapods/v/Prototyper.svg?style=flat)](http://cocoapods.org/pods/Prototyper)
[![License](https://img.shields.io/cocoapods/l/Prototyper.svg?style=flat)](http://cocoapods.org/pods/Prototyper)
[![Platform](https://img.shields.io/cocoapods/p/Prototyper.svg?style=flat)](http://cocoapods.org/pods/Prototyper)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

To use the Prototyper framework you need an account for the [Prototyper online service](https://prototyper-bruegge.in.tum.de).
Create a new prototype and download the container file for the prototype you want to inlude in your app.
Use the feedback button to give feedback that will be deisplayed on the [Prototyper online service](https://prototyper-bruegge.in.tum.de).

## Installation

1. Integrate Prototyper Cocoapod

    ```swift
    pod 'Prototyper'
    ```

    To guarantee that you can configure prototypes directly in Interface Builder add the following lines at the end of your Podfile:

    ```swift
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
            target.build_configurations.each do |config|
                config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
            end
        end
    end
    ```
2. Display the feedback button in the `applicationDidFinishLaunchingWithOptions` method of your `AppDelegate`. Don't forget to import the Prototyper framework.

    ```swift
        import Prototyper
    ```

    ```swift
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            PrototypeController.sharedInstance.showFeedbackButton(true)
            
            return true
        }
    ```

3. Download a container from the [Prototyper online service](https://prototyper-bruegge.in.tum.de)
4. Add a `PrototyperView` for every prototype page you want to show. You can configure the Prototyper View completely in the Interface Builder. You need to set the `containerName` and optionally the `pageID`

## Author

Chair of Applied Software Engineering, ios@in.tum.de
Paul Schmiedmayer, [@PSchmiedmayer](https://twitter.com/pschmiedmayer)
Stefan Kofler, grafele@gmail.com

## License

Prototyper is available under the MIT license. See the LICENSE file for more info.
