### Initial setup

Project contains:

- Coacoapods to configure depdendencies.

To apply them run following commands:

-  `pod install `

### Macro architecture

Project uses modular architecture to develop separate reusable modules of application independently.

Fundamental concept of this architecture is "Module Assembly". It is a functional macro-unit of application. In general, Module is represented by one screen. Occasionally, part of a screen of any size can serve as a module.

`Module assembly` - is an assembler with a method `assemble` (might containt parameters)  returning UIViewController

example: 

```swift
/// Module configuration closure, which 
/// - passes a ModuleInput instance for necessary configurations
/// - returns an optional ModuleOutput instance for target module to hold and invoke when needed
typealias PasscodeConfiguration = (_ input: PasscodeModuleInput) -> PasscodeModuleOutput?

protocol PasscodeModuleAssemblying {
    /// Assembles Passcode Module for installing/editing user Passcode
    ///
    /// - Parameter configuration: optional configuration closure called by module owner
    /// - Returns: Assembled module's ViewController
    func assemble(_ configuration: PasscodeConfiguration?) -> UIViewController
}
```

Input and Output protocols of module:

```swift
/// Protocol for target module initial configuration or further changes, called by its invoker
protocol PasscodeModuleInput {
    /// Sets a custom passcode module title, ignoring one from PasscodeUseCase
    func set(titleText: String)
}

/// Protocol for parent modules to respond to target module result/output event methods (usually implemented by Parent module Presenter)
protocol PasscodeModuleOutput {
    func didFinishPasscode(with pin: String)
    func didCancel()
}
``` 

Implementation:

```swift
final class PasscodeModuleAssembly: PasscodeModuleAssemblying {
    func assemble(_ configuration: PasscodeConfiguration?) -> UIViewController {
        let viewCtrl = PasscodeViewController()
        // other micro-module logic and initializations
        // apply passed configuration parameter
        return viewCtrl 
    }
}
```

### Micro Architecture

Project uses MVVM as micro architecture. Root directory of app contains "Templates" folder for Generamba templates.

run `generamba gen [MODULE_NAME] translate_swift_mvvm` - to generate a new module
