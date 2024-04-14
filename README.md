
NetworkPinger
========

NetworkPinger is a lightweight, powerful framework designed for system administrators, network engineers, and IT professionals who need to monitor network connectivity and performance. This package offers a streamlined approach to pinging a list of hosts and provides real-time insights into their response times and availability

## Features

- [x] Effortlessly configure and ping multiple hosts simultaneously to ensure their operational status.
- [x] Simple setup allows you to incorporate NetworkPinger into existing systems with minimal configuration.
- [x] Fine-tune the frequency, timeout settings, and other parameters to suit specific network monitoring needs.

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

NetworkPinger is available through [Swift Package Manager](https://swift.org/package-manager/).

### Swift Package Manager

in `Package.swift` add the following:

```swift
dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/muneerkk66/NetWorkPinger", from: "1.0.0")
],
targets: [
    .target(
        name: "MyProject",
        dependencies: [..., "NetWorkPinger"]
    )
    ...
]
```


## Basic Usage

This example demonstrates using the NetworkPinger class to concurrently ping multiple hosts—"www.google.com" and "www.yahoo.com".

### Concurrent Execution: Performs ping operations in parallel for efficiency.

```swift
let pinger = NetworkPinger()
let hosts = ["www.google.com", "www.yahoo.com"]

var cancellables = Set<AnyCancellable>()

pinger.ping(hosts: hosts, count: 5)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Ping operation completed successfully.")
        case .failure(let error):
            print("Ping operation failed with error: \(error)")
        }
    }, receiveValue: { response in
        print("Ping response duration: \(response.duration)")
    })
    .store(in: &cancellables)
```

```swift
ping(hosts: count:) 
```
Count = Number of concurrent request

## Example Apps

an example app using NetworkPinger can be found on [GitHub](https://github.com/muneerkk66/PingMaster).



## Credits

The NetworkPinger features of SwiftyPing are inspired by:

- [SwiftyPing]- [samiyr](https://github.com/samiyr/SwiftyPing.git).


## License

MIT license. See the [LICENSE file](LICENSE) for details.
