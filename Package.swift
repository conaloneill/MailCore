// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: MailCore,
    platforms: [
       .macOS(.v10_14)
    ],
    products: [
        .library(name: MailCore, targets: [MailCore]),
    ],
    dependencies: [
        .package(url: https://github.com/vapor/vapor.git, from: 4.0.0-beta),
        .package(url: https://github.com/skelpo/sendgrid-provider.git, from: 4.0.0-beta),
    ],
    targets: [
        .target(name: MailCore, dependencies: [
            Vapor,
            SendGrid
        ]),
        .target(name: Run, dependencies: [MailCore]),
        .testTarget(name: AppTests, dependencies: [MailCore, XCTVapor])
    ]
)

