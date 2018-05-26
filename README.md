
##

[![Platforms](https://img.shields.io/badge/platforms-macOS%2010.13%20|%20Ubuntu%2016.04%20LTS-ff0000.svg?style=flat)](https://github.com/LiveUI/Boost)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Swift 4](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat)](http://swift.org)
[![Vapor 3](https://img.shields.io/badge/vapor-3.0-blue.svg?style=flat)](https://vapor.codes)


Mailing wrapper for  SendGrid

# Features

- [x] SendGrid
- [ ] Attachments
- [ ] Multiple emails sent at the same time
- [ ] Multiple recipint, CC & BCC fields

# Install

Just add following line package to your `Package.swift` file.

```swift
.package(url: "https://github.com/conaloneill/MailCore.git", .branch("master"))
```

# Usage

Usage is really simple mkey!

## 1/3) Configure

First create your client configuration:

#### SendGrid

```swift
let config = Mailer.Config.sendGrid(key: "{sendGridApiKey}")
```

## 2/3) Register service

Register and configure the service in your apps `configure` method.

```swift
Mailer(config: config, registerOn: &services)
```

`Mailer.Config` is an `enum` and you can choose from any integrated services to be used

## 3/3) Send an email

```swift
let mail = Mailer.Message(from: "admin@liveui.io", to: "bobby.ewing@southfork.com", subject: "Oil spill", text: "Oooops I did it again", html: "<p>Oooops I did it again</p>")
return try req.mail.send(mail).flatMap(to: Response.self) { mailResult in
    print(mailResult)
    // ... Return your response for example
}
```

# Testing

Mailcore provides a  `MailCoreTestTools` framework which you can import into your tests to get `MailerMock`.

To register, and potentially override any existing "real" Mailer service, just initialize `MailerMock` with your services.

```swift
// Register
MailerMock(services: &services)

// Retrieve in your tests
let mailer = try! req.make(MailerService.self) as! MailerMock
```

`MailerMock` will store the last used result as well as the received message and request. Structure of the moct can be seen below:

```swift
public class MailerMock: MailerService {

    public var result: Mailer.Result = .success
    public var receivedMessage: Mailer.Message?
    public var receivedRequest: Request?

    // MARK: Initialization

    @discardableResult public init(services: inout Services) {
        services.remove(type: Mailer.self)
        services.register(self, as: MailerService.self)
    }

    // MARK: Public interface

    public func send(_ message: Mailer.Message, on req: Request) throws -> Future<Mailer.Result> {
        receivedMessage = message
        receivedRequest = req
        return req.eventLoop.newSucceededFuture(result: result)
    }

    public func clear() {
        result = .success
        receivedMessage = nil
        receivedRequest = nil
    }

}
```


# Implemented thirdparty providers

* <b>SendGrid</b> - https://github.com/vapor-community/sendgrid-provider
