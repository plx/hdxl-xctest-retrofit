// swift-tools-version:6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "hdxl-xctest-retrofit",
  platforms: [
    .macOS(.v15),
    .iOS(.v18),
    .tvOS(.v18),
    .watchOS(.v11),
    .macCatalyst(.v18),
    .visionOS(.v2)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "HDXLXCTestRetrofit",
      targets: ["HDXLXCTestRetrofit"]
    ),
    .executable(
      name: "HDXLXCTestRetrofitClient",
      targets: ["HDXLXCTestRetrofitClient"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    // Macro implementation that performs the source transformation of a macro.
    .macro(
      name: "HDXLXCTestRetrofitMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),
    
    // Library that exposes a macro as part of its API, which is used in client programs.
    .target(
      name: "HDXLXCTestRetrofit",
      dependencies: ["HDXLXCTestRetrofitMacros"]
    ),
    
    // A client of the library, which is able to use the macro in its own code.
    .executableTarget(
      name: "HDXLXCTestRetrofitClient",
      dependencies: [
        "HDXLXCTestRetrofit"
      ]
    ),
    
    // A test target used to develop the macro implementation.
    .testTarget(
      name: "HDXLXCTestRetrofitTests",
      dependencies: [
        "HDXLXCTestRetrofitMacros",
        .product(
          name: "SwiftSyntaxMacrosTestSupport",
          package: "swift-syntax"
        ),
      ]
    ),

    // A test target used to verify the macro expansions produce expected results
    .testTarget(
      name: "HDXLXCTestRetrofitUsageTests",
      dependencies: [
        "HDXLXCTestRetrofit"
      ]
    ),
  ],
  swiftLanguageModes: [.v6, .v5]
)


