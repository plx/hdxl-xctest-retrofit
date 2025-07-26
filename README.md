# HDXLXCTestRetrofit

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![CI](https://github.com/plx/hdxl-xctest-retrofit/actions/workflows/swift.yml/badge.svg)](https://github.com/plx/hdxl-xctest-retrofit/actions/workflows/swift.yml)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%2015%2B%20|%20iOS%2018%2B%20|%20tvOS%2018%2B%20|%20watchOS%2011%2B%20|%20visionOS%202%2B-blue.svg)](https://swift.org)

Seamlessly migrate XCTest assertions to Swift Testing with familiar syntax.

## Overview

HDXLXCTestRetrofit provides drop-in replacements for XCTest assertions that work with Swift Testing. Simply prefix your existing XCTest assertions with `#` to use the new Swift Testing framework while keeping your test logic intact.

```swift
// Before: XCTest
func testAddition() {
  XCTAssertEqual(2 + 2, 4, "Math still works")
}

// After: Swift Testing with HDXLXCTestRetrofit
@Test
func addition() {
  #XCTAssertEqual(2 + 2, 4, "Math still works")
}
```

## Installation

Add HDXLXCTestRetrofit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/hdxl/hdxl-xctest-retrofit.git", from: "1.0.0")
]
```

Then add it as a dependency to your test target:

```swift
.testTarget(
    name: "MyTests",
    dependencies: [
        "HDXLXCTestRetrofit",
        // your other dependencies
    ]
)
```

## Quick Start

1. Import the package in your test files:
   ```swift
   import Testing
   import HDXLXCTestRetrofit
   ```

2. Convert test classes to `@Suite` and test methods to `@Test`

3. Prefix XCTest assertions with `#`:
   ```swift
   #XCTAssertTrue(user.isActive)
   #XCTAssertNil(error)
   #XCTAssertEqual(result, expected, "Custom failure message")
   ```

## Why Use This?

Migrating large test suites from XCTest to Swift Testing can be daunting when you have:

- Thousands of assertions across hundreds of test files
- Custom validation helpers built on XCTest assertions
- Carefully crafted failure messages providing context

HDXLXCTestRetrofit lets you migrate incrementally:
1. Update test structure (`@Suite`, `@Test`)
2. Add `#` prefix to assertions
3. Keep all your existing test logic and messages

## Supported Assertions

All standard XCTest assertions are supported:

### Basic Assertions
- `#XCTAssert` / `#XCTAssertTrue`
- `#XCTAssertFalse`
- `#XCTAssertNil` / `#XCTAssertNotNil`
- `#XCTFail`
- `#XCTUnwrap`

### Equality & Comparison
- `#XCTAssertEqual` / `#XCTAssertNotEqual`
- `#XCTAssertIdentical` / `#XCTAssertNotIdentical`
- `#XCTAssertGreaterThan` / `#XCTAssertGreaterThanOrEqual`
- `#XCTAssertLessThan` / `#XCTAssertLessThanOrEqual`

### Floating Point
- `#XCTAssertEqual` (with accuracy parameter)
- `#XCTAssertNotEqual` (with accuracy parameter)

### Error Handling
- `#XCTAssertThrowsError`
- `#XCTAssertNoThrow`

## Advanced Usage

### Custom Validation Helpers

Each assertion supports a `sourceLocation` parameter for better error reporting in helper functions:

```swift
func verifyUserState(
    _ user: User,
    isActive: Bool,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    #XCTAssertEqual(user.isActive, isActive, sourceLocation: sourceLocation)
    #XCTAssertNotNil(user.lastLogin, "Active users must have login history", sourceLocation: sourceLocation)
}

@Test func userValidation() {
    let user = User(name: "Test")
    verifyUserState(user, isActive: true)  // Failures point to this line
}
```

## Documentation

- [API Documentation](https://hdxl.github.io/hdxl-xctest-retrofit/documentation/hdxlxctestretrofit/)
- [Migration Guide](https://hdxl.github.io/hdxl-xctest-retrofit/tutorials/migrating-from-xctest)

## Requirements

- Swift 6.0+
- Xcode 16.0+
- Platforms: macOS 15+, iOS 18+, tvOS 18+, watchOS 11+, visionOS 2+

## License

MIT License - see [LICENSE](LICENSE) file for details.

