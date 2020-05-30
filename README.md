# Minimalist

[![Build Status](https://travis-ci.com/nalexn/Minimalist.svg?branch=master)](https://travis-ci.com/nalexn/Minimalist) [![codecov](https://codecov.io/gh/nalexn/Minimalist/branch/master/graph/badge.svg)](https://codecov.io/gh/nalexn/Minimalist)

Utilizing the capabilities of Swift 5.1 for building data-driven UI without `Rx`

## What is that?

I'm a big fan of reactive frameworks. I've used RxSwift, ReactiveSwift, Combine, and I suffer every time I join the project where the team cannot adopt one for some reason.

* Problem #1: Teams beware the complexity and steep learning curve
* Problem #2: Traditional frameworks are too bulky for small projects

This library is a take on cutting off everything non-essential. In fact, all you need to build the data-driven UI is **observable property** and **event broadcaster**. And that's all that you get with this micro-framework (just 100 lines of code):

### @Property

Also known as:

* `BehaviorRelay` in RxSwift
* `MutableProperty` in ReactiveSwift
* `CurrentValueSubject` in Combine

```swift
class ViewModel {
    @Property var items: [Items]
}

// Access the current value:
viewModel.items.count

// Subscribe on changes of the value:
viewModel.$items.observe(with: self) { (obj, items) in
    ...
}
```

### @Signal

Also known as:

* `PublishRelay` in RxSwift
* `Signal` in ReactiveSwift
* `PassthroughSubject` in Combine

```swift
class ViewModel {
    @Signal var didReceiveMessage: Accepts<Message>
}

// Broadcast a notification:
didReceiveMessage.send(message)

// Subscribe on updates:
viewModel.$didReceiveMessage.observe(with: self) { (obj, message) in
    ...
}
```

## Features

### Access control

You can restrict the write access from outside of the module using just Swift's access control:

```swift
class ViewModel {
    @Property private(set) var value: String = ""
    @Signal private(set) var signal: Accepts<Void>
}

// Cannot change property or trigger a signal:
viewModel.value = "abc" // ❌
viewModel.signal.send(()) // ❌
```

### Automatic memory management

Subscription is bound to the lifetime of the supplied object and gets detached automatically. That object is also provided in the callback along with the value, so you don't need to do the `[weak self]` dance all the time:

```swift
class ViewController: UIViewController {
    var tableView: UITableView
    
    func viewDidLoad() {
        ...
        viewModel.$items.observe(with: self) { (vc, items) in
            vc.tableView.reloadData()
        }
    }
}
```

### Filter state updates (Redux)

Data-driven UI works best with unidirectional data flow design, which may involve using a centralized state in the app.

Upon subscription, you can specify the `KeyPath` to the value inside the state container to receive scoped and filtered updates (like with `distinctUntilChanged`):

```swift
$appState.observe(\.screens.loginScreen, with: self) { (obj, state) in
    ...
}
```

---

[![blog](https://img.shields.io/badge/blog-github-blue)](https://nalexn.github.io/?utm_source=nalexn_github) [![venmo](https://img.shields.io/badge/%F0%9F%8D%BA-Venmo-brightgreen)](https://venmo.com/nallexn)
