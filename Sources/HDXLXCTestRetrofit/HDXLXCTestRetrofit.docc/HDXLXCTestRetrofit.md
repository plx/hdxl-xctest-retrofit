# ``HDXLXCTestRetrofit``

Seamlessly migrate your XCTest assertions to Swift Testing with familiar, drop-in macro replacements.

## Overview

HDXLXCTestRetrofit bridges the gap between XCTest and Swift Testing, allowing you to modernize your test suites incrementally. By simply prefixing your existing XCTest assertions with `#`, you can leverage Swift Testing's improved features while maintaining your test logic and carefully crafted failure messages.

### Key Benefits

- **Zero Learning Curve**: Use the same assertion APIs you already know
- **Incremental Migration**: Update tests file-by-file or even assertion-by-assertion  
- **Preserve Test Logic**: Keep your validation helpers and custom assertions
- **Maintain Context**: All your descriptive failure messages work unchanged

## Topics

### Getting Started

- <doc:GettingStarted>
- <doc:MigratingFromXCTest>

### Essential Assertions

- ``XCTAssert(_:_:file:line:)``
- ``XCTAssertTrue(_:_:file:line:)``
- ``XCTAssertFalse(_:_:file:line:)``
- ``XCTAssertNil(_:_:file:line:)``
- ``XCTAssertNotNil(_:_:file:line:)``
- ``XCTFail(_:file:line:)``

### Equality and Comparison

- ``XCTAssertEqual(_:_:_:file:line:)``
- ``XCTAssertNotEqual(_:_:_:file:line:)``
- ``XCTAssertIdentical(_:_:_:file:line:)``
- ``XCTAssertNotIdentical(_:_:_:file:line:)``
- ``XCTAssertGreaterThan(_:_:_:file:line:)``
- ``XCTAssertGreaterThanOrEqual(_:_:_:file:line:)``
- ``XCTAssertLessThan(_:_:_:file:line:)``
- ``XCTAssertLessThanOrEqual(_:_:_:file:line:)``

### Floating Point Assertions

- ``XCTAssertEqual(_:_:accuracy:_:file:line:)-8xfxw``
- ``XCTAssertNotEqual(_:_:accuracy:_:file:line:)-68yf5``

### Error Handling

- ``XCTAssertThrowsError(_:_:file:line:_:)``
- ``XCTAssertNoThrow(_:_:file:line:)``
- ``XCTUnwrap(_:_:file:line:)``

### Advanced Usage

- <doc:UsingSourceLocation>
- <doc:ValidationHelpers>