# hdxl-xctest-retrofit

Macros to "retrofit" the `XCTest` assertions into macros you can invoke from Swift Testing code.

Basic idea is this:

- you have a lot of old, *complex* `XCTest` test cases with *lots* of assertions
- you want to port them to Swift Testing 
- you don't want to rewrite each `XCTAssertEqual(X, Y, message, file, line)` to the equivalent `#expect` 
- you haven't yet figured out how to get Claude Code to do it for you reliably

In that specific case, the code in this repo lets you do this:

```swift
// original, in an `XCTestCase` subclass:
func testWhatever() {
  XCTAssertEqual(foo, bar, "Expected \(foo) to be equal to \(bar), but it wasn't!")
}

// after, as a test:
@Test
func testWhatever() {
  #XCTAssertEqual(foo, bar, "Expected \(foo) to be equal to \(bar), but it wasn't!")
}

// which gets expanded-to this:
@Test
func testWhatever() {
  #expect((foo) == (bar), "Expected \(foo) to be equal to \(bar), but it wasn't!")
}
```

In other words, this lets you migrate existing assertions over to Swift Testing equivalents just by adding a `#` to your XCT assertions.