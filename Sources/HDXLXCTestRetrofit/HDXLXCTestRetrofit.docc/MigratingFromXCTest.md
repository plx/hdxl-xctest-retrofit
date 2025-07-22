# Migrating from XCTest

A step-by-step guide to migrating your XCTest suite to Swift Testing using `HDXLXCTestRetrofit`.

## Overview

This guide walks through migrating a real test suite from XCTest to Swift Testing, demonstrating how `HDXLXCTestRetrofit` makes the process straightforward and risk-free.

## Migration Strategy

### Step 1: Add Dependencies

First, add Swift Testing and `HDXLXCTestRetrofit` to your test target:

```swift
.testTarget(
  name: "MyAppTests",
  dependencies: [
    "MyApp",
    "HDXLXCTestRetrofit"
  ]
)
```

### Step 2: Convert Test Structure

Transform your XCTest classes into Swift Testing suites:

```swift
// Before: XCTest
import XCTest

class ShoppingCartTests: XCTestCase {
  var cart: ShoppingCart!

  override func setUp() {
    super.setUp()
    cart = ShoppingCart()
  }

  override func tearDown() {
    cart = nil
    super.tearDown()
  }

  func testAddItem() {
    let item = Item(name: "Coffee", price: 4.99)
    cart.add(item)
    XCTAssertEqual(cart.items.count, 1)
    XCTAssertEqual(cart.total, 4.99, accuracy: 0.01)
  }
}
```

```swift
// After: Swift Testing with HDXLXCTestRetrofit
import Testing
import HDXLXCTestRetrofit

@Suite
struct ShoppingCartTests {
  var cart: ShoppingCart

  init() {
    self.cart = ShoppingCart()
  }

  @Test 
  func addItem() {
    let item = Item(name: "Coffee", price: 4.99)
    cart.add(item)
    #XCTAssertEqual(cart.items.count, 1)
    #XCTAssertEqual(cart.total, 4.99, accuracy: 0.01)
  }
}
```

### Step 3: Update Assertions

Simply prefix each XCTest assertion with `#`:

| XCTest | HDXLXCTestRetrofit |
|--------|-------------------|
| `XCTAssertTrue(condition)` | `#XCTAssertTrue(condition)` |
| `XCTAssertEqual(a, b)` | `#XCTAssertEqual(a, b)` |
| `XCTAssertNil(value)` | `#XCTAssertNil(value)` |
| `XCTAssertThrowsError(try risky())` | `#XCTAssertThrowsError(try risky())` |

### Step 4: Handle Helper Functions

If your tests use validation helpers, you have options. See <doc:MigratingValidationFunctions> for detailed guidance, but here's a quick example:

```swift
// Your existing helper - just add # to assertions
func verifyCart(
  _ cart: ShoppingCart,
  itemCount: Int,
  total: Double,
  file: StaticString = #file,
  line: UInt = #line
) {
  #XCTAssertEqual(cart.items.count, itemCount, file: file, line: line)
  #XCTAssertEqual(cart.total, total, accuracy: 0.01, file: file, line: line)
}
```

In a similar vein, each retrofit macro also comes in a variant that accepts a `sourceLocation: Testing.SourceLocation` parameter instead of `file: StaticString, line: UInt`; this can be helpful during a migration, as it allows you keep your logic while switching over to the Swift Testing framework's error-attribution convention. 

```swift
// A helper that's been partly-migrated
func verifyCart(
  _ cart: ShoppingCart,
  itemCount: Int,
  total: Double,
  sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
  #XCTAssertEqual(cart.items.count, itemCount, sourceLocation: sourceLocation)
  #XCTAssertEqual(cart.total, total, accuracy: 0.01, sourceLocation: sourceLocation)
  
  for item in cart.items {
    // adding new assertions using native #expect macro, etc.
    #expect(item.price <= total, sourceLocation: sourceLocation)
  }
}
```

For more details, you can review <doc:MigratingValidationFunctions>.

## Summary

HDXLXCTestRetrofit makes migrating from XCTest to Swift Testing a mechanical process:

1. Add the package dependency
2. Convert test classes to `@Suite` structs
3. Change test methods to `@Test` functions
4. Prefix assertions with `#`

Your tests continue working exactly as before, but now you can gradually adopt Swift Testing's modern features like parameterized tests, tags, and better diagnostics.
