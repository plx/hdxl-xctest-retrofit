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
- adopt the retrofit macros by prefixing all existing `XCTest` assertions with `#`:
  - change `XCTAssertEqual` to `#XCTAssertEqual`
  - change `XCTAssertTrue` to `#XCTAssertTrue`
  - change `XCTAssertNil` to `#XCTAssertNil` 
  - (and so on and so forth)

Here's a concrete example:

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

By this point, you've successfully ported `UserTests` from `XCTest` to Swift Testing.
In fact, you've done so *without* changing any test logic or assertions, thereby side-stepping the risk of introducing logical errors during your port.

For more discussion of the migration process, see <doc:MigratingFromXCTest> (and potentially also <doc:MigratingValidationFunctions>, which has additional tips for handling validation functions).

## Limitations

This package does *not* include any migration support for `XCTest` API beyond the assertions; in particular, at this time it doesn't handle things like:

- `XCTSkip`, `XCTExpectFailure`, etc.
- `XCTTestExpectation` (and friends)
- `XCTestCase.continueAfterFailure`
- `XCTestCase.record` (etc.)

These omissions are intentional, because they're out-of-scope: for tests using those constructs you'll need to make more-structural changes to your test code in order to migrate to Swift Testing.

## What's Next?

- See <doc:MigratingFromXCTest> for a complete migration guide
- Learn about <doc:MigratingValidationFunctions> if your tests use validation helpers
- Check the API documentation for all available assertions
