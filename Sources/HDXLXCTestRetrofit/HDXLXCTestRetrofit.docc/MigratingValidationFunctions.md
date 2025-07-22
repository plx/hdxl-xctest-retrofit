# Migrating Validation Functions

Learn how to adapt your existing `XCTest` validation helpers to work with `HDXLXCTestRetrofit`.

## Overview

If your test suite includes validation functions that encapsulate complex assertions, you can migrate them to `HDXLXCTestRetrofit` with minimal changes. This guide shows how to adapt these helpers while maintaining their functionality and improving error reporting.

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

This approach migrates your existing logic as-is, and requires minimal changes to your codebase.

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

For *new* validation functions I would recommend using `SourceLocation`, but for existing validation functions it's entirely your preference. 

## Summary

Migrating validation functions to `HDXLXCTestRetrofit` is straightforward:

- *necessary*: prefix `XCTTest` assertions with `#`
- *optional*: migrate `file` and `line` parameters to `SourceLocation`
