# Migrating from XCTest

A step-by-step guide to migrating your XCTest suite to Swift Testing using HDXLXCTestRetrofit.

## Overview

This guide walks through migrating a real test suite from XCTest to Swift Testing, demonstrating how HDXLXCTestRetrofit makes the process straightforward and risk-free.

## Migration Strategy

### Step 1: Add Dependencies

First, add Swift Testing and HDXLXCTestRetrofit to your test target:

```swift
.testTarget(
    name: "MyAppTests",
    dependencies: [
        "MyApp",
        "HDXLXCTestRetrofit",
        .product(name: "Testing", package: "swift-testing"),
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
    
    @Test func addItem() {
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

## Advanced Migration Patterns

### Parameterized Tests

Convert data-driven XCTests to Swift Testing's parameterized tests:

```swift
// Before: Multiple test methods
func testDiscountTenPercent() {
    XCTAssertEqual(calculateDiscount(100, percent: 10), 90)
}

func testDiscountTwentyPercent() {
    XCTAssertEqual(calculateDiscount(100, percent: 20), 80)
}

// After: Single parameterized test
@Test(arguments: [
    (price: 100.0, percent: 10, expected: 90.0),
    (price: 100.0, percent: 20, expected: 80.0),
    (price: 50.0, percent: 50, expected: 25.0)
])
func discount(price: Double, percent: Int, expected: Double) {
    #XCTAssertEqual(calculateDiscount(price, percent: percent), expected)
}
```

### Test Organization

Use Swift Testing's tags and traits:

```swift
@Suite(.tags(.cart, .pricing))
struct ShoppingCartTests {
    @Test(.tags(.critical))
    func calculatesTotalCorrectly() {
        // Critical test for total calculation
    }
    
    @Test(.disabled("Waiting for API implementation"))
    func syncsWithServer() {
        // Future test
    }
}
```

## Best Practices

1. **Migrate incrementally**: Start with one test file at a time
2. **Run tests frequently**: Ensure tests still pass after each change
3. **Keep custom messages**: Your descriptive failure messages remain valuable
4. **Leverage new features gradually**: Adopt parameterized tests and tags as you go

## Common Pitfalls

### Setup and Teardown

XCTest's `setUp()` and `tearDown()` don't exist in Swift Testing. Use struct initialization and deinitialization:

```swift
@Suite
struct DatabaseTests {
    let database: TestDatabase
    
    init() throws {
        database = try TestDatabase.inMemory()
    }
    
    deinit {
        database.cleanup()
    }
}
```

### Async Tests

Both frameworks support async, but the syntax differs slightly:

```swift
// XCTest
func testAsync() async throws {
    let result = await fetchData()
    XCTAssertNotNil(result)
}

// Swift Testing
@Test
func fetchesData() async throws {
    let result = await fetchData()
    #XCTAssertNotNil(result)
}
```

## Summary

HDXLXCTestRetrofit makes migrating from XCTest to Swift Testing a mechanical process:

1. Add the package dependency
2. Convert test classes to `@Suite` structs
3. Change test methods to `@Test` functions
4. Prefix assertions with `#`

Your tests continue working exactly as before, but now you can gradually adopt Swift Testing's modern features like parameterized tests, tags, and better diagnostics.