# Getting Started

Here's how to add `HDXLXCTestRetrofit` to your project and get started usng it

## Installation

Add `HDXLXCTestRetrofit` to your package dependencies:

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
    .product(name: "HDXLXCTestRetrofit", package: "hdxl-xctest-retrofit"),
  ]
)
```

## Basic Usage

Here's how you can use `HDXLXCTestRetrofit` to efficiently migrate existing `XCTest`-based unit tests to Swift Testing.

1. Remove `XCTest` import, and import both Swift Testing and `HDXLXCTestRetrofit`:

```swift
// remove this:
// import XCTest
//
// ...then add these:
import Testing
import HDXLXCTestRetrofit
```

2. Update the existing `XCTestCase` test-case code like so:

- changing the `XCTestCase` class to a struct
- adding the `@Suite` attribute
- changing test methods to `@Test` functions
- replceadopt the retrofit macros all existing `XCTest` assertions with `#`

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
  @Test 
  func testUserCreation() {
    let user = User(name: "Alice")
    #XCTAssertEqual(user.name, "Alice")
    #XCTAssertTrue(user.isActive)
  }
}
```

At this point, you will have successfully migrated your unit test from `XCTest` to Swift Testing, and without having materially changed the test logic or assertions. Although you won't (yet) have taken full advantage of Swift Testing's features, you'll also have side-stepped the risk of a more-"bespoke" migration introducing logical errors into your test code. 

## Limitations

This package does *not* include any migration support for `XCTest` API beyond the assertions; in particular, at this time it doesn't handle:

- `XCTTestExpectation` (and friends)
- `XCTExpectFailure` (and friends)
- `XCTestCase.continueAfterFailure`
- `XCTestCase.record` (etc.)

These omissions are intentional: whereas the assertions can be migrated on an individual basis and in a purely-mechanical fashion, mapping the above capabilities into Swift Testing would typically requires contextually-dependent structural changes to the test code.

## What's Next?

- See <doc:MigratingFromXCTest> for a complete migration guide
- Learn about <doc:MigratingValidationFunctions> if your tests use validation helpers
- Check the API documentation for all available assertions
