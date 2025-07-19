# Migrating Validation Functions

Learn how to adapt your existing XCTest validation helpers to work with HDXLXCTestRetrofit.

## Overview

If your test suite includes validation functions that encapsulate complex assertions, you can migrate them to HDXLXCTestRetrofit with minimal changes. This guide shows how to adapt these helpers while maintaining their functionality and improving error reporting.

## Basic Migration

Your existing validation functions likely accept `file` and `line` parameters for error reporting:

```swift
// Existing XCTest validation function
func validateUserState(
    _ user: User,
    isActive: Bool,
    hasSession: Bool = true,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(user.isActive, isActive, file: file, line: line)
    if hasSession {
        XCTAssertNotNil(user.sessionToken, "Active users must have session", file: file, line: line)
        XCTAssertGreaterThan(user.lastActivityTime, Date.distantPast, file: file, line: line)
    }
}
```

To migrate this function, simply prefix the assertions with `#`:

```swift
// Migrated to HDXLXCTestRetrofit - Option 1: Keep file/line parameters
func validateUserState(
    _ user: User,
    isActive: Bool,
    hasSession: Bool = true,
    file: StaticString = #file,
    line: UInt = #line
) {
    #XCTAssertEqual(user.isActive, isActive, file: file, line: line)
    if hasSession {
        #XCTAssertNotNil(user.sessionToken, "Active users must have session", file: file, line: line)
        #XCTAssertGreaterThan(user.lastActivityTime, Date.distantPast, file: file, line: line)
    }
}
```

This approach works perfectly and requires minimal changes to your codebase.

## Adopting Swift Testing's Source Location

Since you're migrating to Swift Testing, you might want to adopt its `SourceLocation` type for consistency with the framework's patterns:

```swift
// Option 2: Migrate to Testing.SourceLocation
func validateUserState(
    _ user: User,
    isActive: Bool,
    hasSession: Bool = true,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    #XCTAssertEqual(user.isActive, isActive, sourceLocation: sourceLocation)
    if hasSession {
        #XCTAssertNotNil(user.sessionToken, "Active users must have session", sourceLocation: sourceLocation)
        #XCTAssertGreaterThan(user.lastActivityTime, Date.distantPast, sourceLocation: sourceLocation)
    }
}
```

Both approaches produce identical results - failures point to the test that called the validation function, not the function itself.

## Complex Validation Hierarchies

For validation functions that call other validation functions, the migration process remains straightforward:

```swift
// Existing nested validators
func validateOrder(
    _ order: Order,
    expectedStatus: OrderStatus,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(order.status, expectedStatus, file: file, line: line)
    validateCustomer(order.customer, file: file, line: line)
    for item in order.items {
        validateOrderItem(item, file: file, line: line)
    }
}

func validateCustomer(
    _ customer: Customer,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertFalse(customer.email.isEmpty, file: file, line: line)
    XCTAssertNotNil(customer.accountId, file: file, line: line)
}
```

Migration options:

```swift
// Option 1: Keep file/line throughout
func validateOrder(
    _ order: Order,
    expectedStatus: OrderStatus,
    file: StaticString = #file,
    line: UInt = #line
) {
    #XCTAssertEqual(order.status, expectedStatus, file: file, line: line)
    validateCustomer(order.customer, file: file, line: line)
    for item in order.items {
        validateOrderItem(item, file: file, line: line)
    }
}

// Option 2: Adopt SourceLocation
func validateOrder(
    _ order: Order,
    expectedStatus: OrderStatus,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    #XCTAssertEqual(order.status, expectedStatus, sourceLocation: sourceLocation)
    validateCustomer(order.customer, sourceLocation: sourceLocation)
    for item in order.items {
        validateOrderItem(item, sourceLocation: sourceLocation)
    }
}
```

## Migration Strategies

### Incremental Migration

You can migrate validation functions one at a time:

1. Start with leaf functions (those that don't call other validators)
2. Work your way up to higher-level validators
3. Each function can be migrated independently

### Mixed Approaches

During migration, you can even mix approaches temporarily:

```swift
// This validation function uses SourceLocation
func validateResponse(
    _ response: APIResponse,
    expectedCode: Int,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    #XCTAssertEqual(response.statusCode, expectedCode, sourceLocation: sourceLocation)
}

// This one still uses file/line
func validateRequest(
    _ request: APIRequest,
    file: StaticString = #file,
    line: UInt = #line
) {
    #XCTAssertNotNil(request.authToken, file: file, line: line)
}
```

## Considerations

### When to Keep file/line

- If you have hundreds of validation functions, keeping `file`/`line` minimizes changes
- If your validation functions are used outside of Swift Testing contexts
- If you prefer gradual migration over time

### When to Adopt SourceLocation

- For new validation functions in migrated test suites
- When you're already updating function signatures
- To align with Swift Testing's conventions
- When you want to use other Swift Testing features in your validators

## Example: Complete Migration

Here's a real-world example showing a validation helper before and after migration:

```swift
// Before: XCTest validation helper
func validatePaymentTransaction(
    _ transaction: PaymentTransaction,
    expectedAmount: Decimal,
    expectedCurrency: String = "USD",
    requiresReceipt: Bool = true,
    file: StaticString = #file,
    line: UInt = #line
) {
    // Basic validation
    XCTAssertEqual(transaction.amount, expectedAmount, accuracy: 0.01, file: file, line: line)
    XCTAssertEqual(transaction.currency, expectedCurrency, file: file, line: line)
    
    // Status checks
    XCTAssertTrue(transaction.isCompleted, "Transaction should be completed", file: file, line: line)
    XCTAssertNil(transaction.error, "Completed transaction should have no error", file: file, line: line)
    
    // Receipt validation
    if requiresReceipt {
        XCTAssertNotNil(transaction.receiptId, "Transaction missing receipt", file: file, line: line)
        XCTAssertGreaterThan(
            transaction.receiptGeneratedAt ?? Date.distantPast,
            transaction.completedAt,
            "Receipt should be generated after completion",
            file: file,
            line: line
        )
    }
}

// After: Migrated with HDXLXCTestRetrofit (keeping file/line)
func validatePaymentTransaction(
    _ transaction: PaymentTransaction,
    expectedAmount: Decimal,
    expectedCurrency: String = "USD",
    requiresReceipt: Bool = true,
    file: StaticString = #file,
    line: UInt = #line
) {
    // Basic validation - just add # prefix
    #XCTAssertEqual(transaction.amount, expectedAmount, accuracy: 0.01, file: file, line: line)
    #XCTAssertEqual(transaction.currency, expectedCurrency, file: file, line: line)
    
    // Status checks
    #XCTAssertTrue(transaction.isCompleted, "Transaction should be completed", file: file, line: line)
    #XCTAssertNil(transaction.error, "Completed transaction should have no error", file: file, line: line)
    
    // Receipt validation
    if requiresReceipt {
        #XCTAssertNotNil(transaction.receiptId, "Transaction missing receipt", file: file, line: line)
        #XCTAssertGreaterThan(
            transaction.receiptGeneratedAt ?? Date.distantPast,
            transaction.completedAt,
            "Receipt should be generated after completion",
            file: file,
            line: line
        )
    }
}
```

The function works exactly as before - you've just added `#` to each assertion. When you're ready, you can optionally update to use `SourceLocation` for consistency with Swift Testing conventions.
