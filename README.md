### Initial setup

Project contains:

- Coacoapods to configure depdendencies.

To apply them run following commands:

-  `pod install `

### Pods

 - **SnapKit** - For simplified canstraints management
 - **Swinject** - For Dependency injection
 - **Moya** - Network layer
 - **Kingfisher** - Load image from source

 ### Commit style

Project is commitizen-friendly. All of project commits follow the [`commitizen format`](https://gist.github.com/stephenparish/9941e89d80e2bc58a153#format-of-the-commit-message):

```
<type>(<optional_scope>): <subject>
<BLANK LINE>
<optional_body>
```

#### Examples

```
fix(search): fixed network failure
```

```
feat: implemented new authorization logic
```

Note that `<scope>` is optional, but highly encourage to include JIRA ticket ID, for example `ABC-777`.
Note: verbs are used in Past Tense

#### Action types and verb format

List of action types:

- `feat` - adding new functionality/logic
- `fix` - fixing functional bugs or non-functional defects
- `refactor` - refactoring source code
- `build` - editing build system, tooling scripts (e.g. - gradle, build phases, makefile etc)
- `docs` - creating/editing README, other docs or code comments
- `chore` - changes that are not bound by any action type listed above

Commit message should **describe some completed action**. There is no strict grammatic rule on sentence composing. 

Following commit messages are valid:

- `fix: fixed broken button height in main page`
- `feat(ABC-123): extended validation logic in search form`
- `refactor: all legacy methods are removed from some Service layer class`

Please use [`commitizen`](http://commitizen.github.io/cz-cli/) command-line tool for generating commit messages if you feel uncomfortable manually writing all these strongly-formatted messages.

* [Commitizen docs](http://commitizen.github.io/cz-cli)
*  [Extensive article in russian](https://anvilabs.co/blog/writing-practical-commit-messages/)
*  [Another article russian](https://habr.com/company/yandex/blog/431432/)

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

### Generamba module generation

Project uses generamba tool for new module boilerplate code generation. You should install it using `gem` or `brew` (make sure you have ruby and rvm installed).

If you want to create module "Something", then use:

` generamba gen Something translate_swift_mvvm ` - for NAME module

This will create a number of source files and add them automatically to `Source/Modules/`.

* [Generamba repo page](https://github.com/rambler-digital-solutions/Generamba)

### SwiftGen

Project uses SwiftGen for resources: Colors, Assets, AppConfigs. 

All info is in `swiftgen.yml` file. To add new resources modify it. Files are accesible in `SkyEngTranslate/Generated`

To lint and apply any modifications of `swiftgen.yml` file:
    run `swiftgen config lint` from command line tool,
    next run `swiftgen` to generate new outputs

* [SwiftGen repo page](https://github.com/SwiftGen/SwiftGen)

### Configuration.plist

In order to add configuration variables(keys, urls) you should add them in `Configuration.plist`(development, release) files. Since you added necessary values and project use `SwiftGen`, you should run `swiftgen`. Access your variables from `AppConfigs` class.
