// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "TPSL",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .executable(name: "TPSL", targets: ["TPSLApp"])
  ],
  targets: [
    .executableTarget(
      name: "TPSLApp",
      linkerSettings: [
        .linkedFramework("AppKit"),
        .linkedFramework("WebKit")
      ]
    )
  ]
)
