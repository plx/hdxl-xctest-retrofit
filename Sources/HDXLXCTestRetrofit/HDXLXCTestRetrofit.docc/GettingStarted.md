# Getting Started

Learn how to add HDXLXCTestRetrofit to your project and start using it immediately.

## Installation

Add HDXLXCTestRetrofit to your package dependencies:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/hdxl/hdxl-xctest-retrofit.git", from: "1.0.0")
]
```

Then add it to your test target:

```swift
.testTarget(
    name: "MyAppTests",
    dependencies: [
        "HDXLXCTestRetrofit",
        .product(name: "Testing", package: "swift-testing"),
    ]
)
```

## Basic Usage

1. Import both Swift Testing and HDXLXCTestRetrofit:

```swift
import Testing
import HDXLXCTestRetrofit
```

2. Convert your test class to a suite and methods to tests:

```swift
// Before
class UserTests: XCTestCase {
    func testUserCreation() {
        let user = User(name: "Alice")
        XCTAssertEqual(user.name, "Alice")
        XCTAssertTrue(user.isActive)
    }
}

// After
@Suite
struct UserTests {
    @Test func userCreation() {
        let user = User(name: "Alice")
        #XCTAssertEqual(user.name, "Alice")
        #XCTAssertTrue(user.isActive)
    }
}
```

## What's Next?

- See <doc:MigratingFromXCTest> for a complete migration guide
- Explore <doc:ValidationHelpers> to learn about advanced patterns
- Check the API documentation for all available assertions