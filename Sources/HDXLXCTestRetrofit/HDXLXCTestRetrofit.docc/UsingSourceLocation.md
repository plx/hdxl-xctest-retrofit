# Using Source Location

Learn how to use source location parameters for better error reporting in test helpers.

## Overview

HDXLXCTestRetrofit provides special variants of each assertion that accept a `Testing.SourceLocation` parameter. This enables precise error reporting when assertions fail within helper functions, pointing to the actual test that failed rather than the helper implementation.

## The Problem

When assertions fail inside helper functions, the error points to the helper, not the calling test:

```swift
func verifyPositive(_ value: Int) {
    #XCTAssertGreaterThan(value, 0)  // ❌ Failures point here
}

@Test func calculation() {
    let result = complexCalculation()
    verifyPositive(result)  // ❌ Not here where we want
}
```

## The Solution

Use the source location parameter to bubble up the actual failure location:

```swift
func verifyPositive(
    _ value: Int,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    #XCTAssertGreaterThan(value, 0, sourceLocation: sourceLocation)
}

@Test func calculation() {
    let result = complexCalculation()
    verifyPositive(result)  // ✅ Failures now point here
}
```

## Complete Example

Here's a real-world example with a validation helper for a user authentication system:

```swift
import Testing
import HDXLXCTestRetrofit

struct AuthenticationTests {
    
    /// Validates a complete authentication response
    func validateAuthResponse(
        _ response: AuthResponse,
        expectedUser: String,
        hasValidToken: Bool = true,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) {
        // User validation
        #XCTAssertEqual(
            response.username, 
            expectedUser,
            "Unexpected username in auth response",
            sourceLocation: sourceLocation
        )
        
        // Token validation
        if hasValidToken {
            #XCTAssertNotNil(
                response.accessToken,
                "Missing access token",
                sourceLocation: sourceLocation
            )
            #XCTAssertGreaterThan(
                response.expiresIn,
                0,
                "Invalid token expiration",
                sourceLocation: sourceLocation
            )
        } else {
            #XCTAssertNil(
                response.accessToken,
                "Unexpected access token for failed auth",
                sourceLocation: sourceLocation
            )
        }
        
        // Timestamp validation
        let now = Date()
        #XCTAssertLessThanOrEqual(
            response.issuedAt.timeIntervalSince(now),
            5.0,
            "Auth timestamp too far in future",
            sourceLocation: sourceLocation
        )
    }
    
    @Test func successfulLogin() async throws {
        let response = try await auth.login(
            username: "alice@example.com",
            password: "secure123"
        )
        
        // All assertion failures will point to this line
        validateAuthResponse(response, expectedUser: "alice@example.com")
    }
    
    @Test func failedLogin() async throws {
        let response = try await auth.login(
            username: "alice@example.com",
            password: "wrong"
        )
        
        // Failures point here, not inside validateAuthResponse
        validateAuthResponse(
            response,
            expectedUser: "alice@example.com",
            hasValidToken: false
        )
    }
}
```

## Best Practices

1. **Always provide the parameter**: Include `sourceLocation: Testing.SourceLocation = #_sourceLocation` in helper signatures
2. **Pass it through**: Forward the source location to all assertions within helpers
3. **Document expectations**: Use descriptive failure messages since they'll appear at the call site
4. **Consider helper depth**: Source location works through multiple levels of helpers

## Migrating Existing Helpers

When migrating XCTest helpers, replace file/line parameters with source location:

```swift
// Before: XCTest style
func verifyResponse(
    _ response: Response,
    statusCode: Int,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(response.statusCode, statusCode, file: file, line: line)
}

// After: Swift Testing style
func verifyResponse(
    _ response: Response,
    statusCode: Int,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    #XCTAssertEqual(response.statusCode, statusCode, sourceLocation: sourceLocation)
}
```