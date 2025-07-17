# Validation Helpers

Design patterns for creating reusable test validation functions with HDXLXCTestRetrofit.

## Overview

Well-designed test suites often include validation helpers that encapsulate complex assertions. HDXLXCTestRetrofit ensures these helpers work seamlessly with Swift Testing while maintaining clear error reporting.

## Basic Validation Pattern

Start with simple, focused validation functions:

```swift
func validateEmail(
    _ email: String,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    #XCTAssertFalse(email.isEmpty, "Email cannot be empty", sourceLocation: sourceLocation)
    #XCTAssertTrue(email.contains("@"), "Email must contain @", sourceLocation: sourceLocation)
    #XCTAssertTrue(email.contains("."), "Email must contain domain", sourceLocation: sourceLocation)
}

@Test func userRegistration() {
    let user = User(email: "alice@example.com")
    validateEmail(user.email)
}
```

## Composable Validators

Build complex validations from simpler ones:

```swift
struct OrderValidation {
    
    static func validateItem(
        _ item: OrderItem,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) {
        #XCTAssertGreaterThan(item.quantity, 0, "Invalid quantity", sourceLocation: sourceLocation)
        #XCTAssertGreaterThan(item.price, 0, "Invalid price", sourceLocation: sourceLocation)
        #XCTAssertFalse(item.name.isEmpty, "Item needs a name", sourceLocation: sourceLocation)
    }
    
    static func validateShipping(
        _ shipping: ShippingInfo,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) {
        #XCTAssertFalse(shipping.address.isEmpty, "Missing address", sourceLocation: sourceLocation)
        #XCTAssertEqual(shipping.zipCode.count, 5, "Invalid ZIP code", sourceLocation: sourceLocation)
    }
    
    static func validateCompleteOrder(
        _ order: Order,
        itemCount: Int? = nil,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) {
        // Validate items
        #XCTAssertFalse(order.items.isEmpty, "Order has no items", sourceLocation: sourceLocation)
        if let expectedCount = itemCount {
            #XCTAssertEqual(order.items.count, expectedCount, sourceLocation: sourceLocation)
        }
        
        for item in order.items {
            validateItem(item, sourceLocation: sourceLocation)
        }
        
        // Validate shipping
        validateShipping(order.shipping, sourceLocation: sourceLocation)
        
        // Validate totals
        let calculatedTotal = order.items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        #XCTAssertEqual(order.subtotal, calculatedTotal, accuracy: 0.01, sourceLocation: sourceLocation)
    }
}
```

## Property-Based Validation

Create validators that check invariants and properties:

```swift
extension Comparable {
    static func validateComparableContract<T: Comparable>(
        less: T,
        equal1: T,
        equal2: T,
        greater: T,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) {
        // Reflexivity
        #XCTAssertEqual(equal1, equal1, "Reflexivity failed", sourceLocation: sourceLocation)
        
        // Symmetry
        #XCTAssertEqual(equal1, equal2, "Symmetry failed", sourceLocation: sourceLocation)
        #XCTAssertEqual(equal2, equal1, "Symmetry failed", sourceLocation: sourceLocation)
        
        // Transitivity
        #XCTAssertLessThan(less, equal1, sourceLocation: sourceLocation)
        #XCTAssertLessThan(equal1, greater, sourceLocation: sourceLocation)
        #XCTAssertLessThan(less, greater, "Transitivity failed", sourceLocation: sourceLocation)
        
        // Consistency with equality
        #XCTAssertFalse(less == equal1, sourceLocation: sourceLocation)
        #XCTAssertTrue(equal1 == equal2, sourceLocation: sourceLocation)
        #XCTAssertFalse(equal1 == greater, sourceLocation: sourceLocation)
    }
}
```

## State Transition Validators

Validate objects through state changes:

```swift
class StateMachineValidator {
    private var previousState: State?
    
    func validateTransition(
        from: State,
        to: State,
        via action: Action,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) {
        // Check previous state if tracked
        if let previous = previousState {
            #XCTAssertEqual(previous, from, "Unexpected starting state", sourceLocation: sourceLocation)
        }
        
        // Validate allowed transitions
        let allowedTransitions = from.allowedTransitions
        #XCTAssertTrue(
            allowedTransitions.contains { $0.action == action },
            "Action \(action) not allowed from state \(from)",
            sourceLocation: sourceLocation
        )
        
        // Validate target state
        let transition = allowedTransitions.first { $0.action == action }
        #XCTAssertEqual(
            transition?.targetState,
            to,
            "Unexpected target state for action \(action)",
            sourceLocation: sourceLocation
        )
        
        previousState = to
    }
}
```

## Async Validation Helpers

Handle asynchronous validation scenarios:

```swift
func validateEventualConsistency<T: Equatable>(
    expected: T,
    timeout: Duration = .seconds(5),
    sourceLocation: Testing.SourceLocation = #_sourceLocation,
    provider: () async throws -> T
) async throws {
    let deadline = Date.now + timeout.timeInterval
    
    while Date.now < deadline {
        let current = try await provider()
        if current == expected {
            return  // Success
        }
        try await Task.sleep(for: .milliseconds(100))
    }
    
    // Final check with assertion
    let final = try await provider()
    #XCTAssertEqual(
        final,
        expected,
        "Value did not reach expected state within \(timeout)",
        sourceLocation: sourceLocation
    )
}

// Usage
@Test func eventuallyUpdates() async throws {
    triggerAsyncUpdate()
    
    try await validateEventualConsistency(expected: .completed) {
        await service.status
    }
}
```

## Best Practices

1. **Single Responsibility**: Each validator should check one concept
2. **Clear Names**: Use descriptive names that explain what's being validated
3. **Meaningful Messages**: Provide context in assertion messages
4. **Optional Parameters**: Allow callers to skip certain validations when needed
5. **Return Values**: Consider returning validated values for chaining

```swift
@discardableResult
func validateAndTransform(
    _ input: String,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) -> ProcessedData {
    #XCTAssertFalse(input.isEmpty, sourceLocation: sourceLocation)
    
    let processed = ProcessedData(from: input)
    #XCTAssertNotNil(processed.id, sourceLocation: sourceLocation)
    #XCTAssertGreaterThan(processed.timestamp, 0, sourceLocation: sourceLocation)
    
    return processed  // Can be used in further assertions
}
```