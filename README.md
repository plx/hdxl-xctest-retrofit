# hdxl-xctest-retrofit

Package with macros that "retrofit" the `XCTest` assertions into macros you can invoke from Swift Testing code:

```swift
// this is an XCTest-style unit test:
func testAddition() {
  XCTAssertEqual(2 + 2, 4, "2 + 2 == 4, of course")
}

// ...but now it's a Swift Testing test:
@Test
func testAddition() {
  #XCTAssertEqual(2 + 2, 4, "2 + 2 == 4, of course")
}

// ...that'll expand to this:
@Test
func testAddition() {
  #expect((2 + 2) == (4), "2 + 2 == 4, of course")
}
```

The motivating scenario was updating some packages with pre-existing, very large test suites with:

- *a lot* of tests with *a lot * of XCTest assertions
- *a lot* of validation functions encapsulating repeating, complicated checks
- *a lot* of high-quality on-failure messages

Given that situation, the macros in this package make porting a lot easier:

1. restructure test cases to `@Suite`s
2. restructure test methods to `@Test` functions (possibly parameterizing, tagging, etc.)
3. keep existing code, but prefix each XCT assertions with `#`

...and that's it!

## API Overview

The API for these macros is intended to match the original `XCTTest` APIs, and so prefixing with `#` should also work.

The one extension is that each `XCTAssertion` now also has a variant taking a `Testing.SourceLocation` argument, e.g.:

```swift
/// This emulates the original `XCTAssert` signature
@freestanding(expression)
public macro XCTAssert(
  _ expression: @autoclosure () throws -> Bool,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertMacro"
)

/// This replaces `file` and `line` with a `Testing.SourceLocation` parameter
@freestanding(expression)
public macro XCTAssert(
  _ expression: @autoclosure () throws -> Bool,
  _ message: @autoclosure () -> String = "",
  sourceLocation: SourceLocation
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertMacro"
)
```

The purpose of these variants is for simpler interoperation with `Testing` when code is organized into validation helpers, e.g.:

```swift
// nitpicky code making sure our `Comparable` conformance satisfies API contract
func verifyComparisonTransitivity<T: Comparable>(
  a: T,
  b: T,
  c: T,
  sourceLocation: Testing.SourceLocation = #_sourceLocation
) throws {
  // hard failures for test-setup problems: a <= b, b <= c
  try #require(a <= b, "Broken test steup, b/c we need a <= b but got a: \(a) and b: \(b) ", sourceLocation: sourceLocation)
  try #require(b <= c, "Broken test steup, b/c we need a <= b but got a: \(b) and b: \(c) ", sourceLocation: sourceLocation)

  // soft failures for property-uder-test failures
  #XCTAssertLessThanOrEqual(a, c, "Expected a <= c, but saw: a: \(a), c: \(c)", sourceLocation: sourceLocation)
  #XCTGreaterThanOrEqual(c, a, "Expected c >= a, but saw: c: \(c), c: \(a)", sourceLocation: sourceLocation)
  if a == c {
    #XCTAssertEqual(a, b, "If a <= b <= c && a == c then a == b, but a != b for a: \(a), b: \(b), c: \(c)", sourceLocation)
  }
  if A != b {
    #XCTAssertNotEqual(a, c, "If a <= b <= c && a != b then a != c, but a == c for a: \(a), b: \(b), c: \(c)", sourceLocation)
  }
}
```

Not necessarily the code you'd write if starting today, but still a nice convenience for incrementally migrating the logic for heavyweight test suites.

## Future Directions

I have no plans to grow this beyond being a way to port existing XCTest code to SwifT Testing by prefixing `#`.
Having said that, there are some XCTest capabilities I haven't addressed yet b/c they're not relevant to what I'm porting:

- [x] [`XCTAssertThrowsError`](https://developer.apple.com/documentation/xctest/xctassertthrowserror(_:_:file:line:_:)) - ✅ Implemented
- [ ] [Expected failures](https://developer.apple.com/documentation/xctest/expected-failures)

