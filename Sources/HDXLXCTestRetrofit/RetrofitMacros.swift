import Testing

// MARK: Unconditional

/// Emulation of `XCTFail`
///
/// - Parameters:
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// - Returns: An `Issue` describing the failure.
///
/// This macro unconditionally generates a test failure with an optional message.
/// Use this when you want to explicitly fail a test at a certain point.
@freestanding(expression)
@discardableResult
public macro XCTFail(
  _ message: String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) -> Issue = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTFailMacro"
)

// MARK: Unary

/// Emulation of `XCTAssert`
///
/// - Parameters:
///   - expression: A boolean expression to evaluate.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that an expression is true. Generates a failure when the expression is false.
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

/// Emulation of `XCTAssertTrue`
///
/// - Parameters:
///   - expression: A boolean expression to evaluate.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that an expression is true. Generates a failure when the expression is false.
/// Functionally identical to `#XCTAssert`.
@freestanding(expression)
public macro XCTAssertTrue(
  _ expression: @autoclosure () throws -> Bool,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertTrueMacro"
)

/// Emulation of `XCTAssertFalse`
///
/// - Parameters:
///   - expression: A boolean expression to evaluate.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that an expression is false. Generates a failure when the expression is true.
@freestanding(expression)
public macro XCTAssertFalse(
  _ expression: @autoclosure () throws -> Bool,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertFalseMacro"
)

/// Emulation of `XCTAssertNil`
///
/// - Parameters:
///   - expression: An expression of optional type.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that an expression is nil. Generates a failure when the expression is not nil.
@freestanding(expression)
public macro XCTAssertNil<T>(
  _ expression: @autoclosure () throws -> T?,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertNilMacro"
)

/// Emulation of `XCTAssertNotNil`
///
/// - Parameters:
///   - expression: An expression of optional type.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that an expression is not nil. Generates a failure when the expression is nil.
@freestanding(expression)
public macro XCTAssertNotNil<T>(
  _ expression: @autoclosure () throws -> T?,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertNotNilMacro"
)

/// Emulation of `XCTUnwrap`
///
/// - Parameters:
///   - expression: An optional expression to unwrap.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// - Returns: The unwrapped value of type T.
///
/// Asserts that an optional expression is not nil and returns the unwrapped value.
/// Throws an error if the optional is nil. This is a throwing function, so test
/// methods using it must be marked as `throws`.
@freestanding(expression)
public macro XCTUnwrap<T>(
  _ expression: @autoclosure () throws -> T?,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) -> T = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTUnwrapMacro"
)

// MARK: Binary

/// Emulation of `XCTAssertEqual`
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that two values are equal using the `==` operator.
/// The values must conform to `Equatable`.
@freestanding(expression)
public macro XCTAssertEqual<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertEqualMacro"
) where T: Equatable

/// Emulation of `XCTAssertNotEqual`
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that two values are not equal using the `!=` operator.
/// The values must conform to `Equatable`.
@freestanding(expression)
public macro XCTAssertNotEqual<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertNotEqualMacro"
) where T: Equatable

/// Emulation of `XCTAssertIdentical`
///
/// - Parameters:
///   - expression1: First object to compare.
///   - expression2: Second object to compare.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that two objects are identical (same instance) using the `===` operator.
/// Only works with reference types (`AnyObject`).
@freestanding(expression)
public macro XCTAssertIdentical(
  _ expression1: @autoclosure () throws -> AnyObject?,
  _ expression2: @autoclosure () throws -> AnyObject?,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertIdenticalMacro"
)

/// Emulation of `XCTAssertNotIdentical`
///
/// - Parameters:
///   - expression1: First object to compare.
///   - expression2: Second object to compare.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that two objects are not identical (different instances) using the `!==` operator.
/// Only works with reference types (`AnyObject`).
@freestanding(expression)
public macro XCTAssertNotIdentical(
  _ expression1: @autoclosure () throws -> AnyObject?,
  _ expression2: @autoclosure () throws -> AnyObject?,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertNotIdenticalMacro"
)

/// Emulation of `XCTAssertGreaterThan`
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that the first value is greater than the second value using the `>` operator.
/// Values must conform to `Comparable`.
@freestanding(expression)
public macro XCTAssertGreaterThan<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertGreaterThanMacro"
) where T: Comparable

/// Emulation of `XCTAssertGreaterThanOrEqual`
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that the first value is greater than or equal to the second value using the `>=` operator.
/// Values must conform to `Comparable`.
@freestanding(expression)
public macro XCTAssertGreaterThanOrEqual<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertGreaterThanOrEqualMacro"
) where T: Comparable

/// Emulation of `XCTAssertLessThan`
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that the first value is less than the second value using the `<` operator.
/// Values must conform to `Comparable`.
@freestanding(expression)
public macro XCTAssertLessThan<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertLessThanMacro"
) where T: Comparable

/// Emulation of `XCTAssertLessThanOrEqual`
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that the first value is less than or equal to the second value using the `<=` operator.
/// Values must conform to `Comparable`.
@freestanding(expression)
public macro XCTAssertLessThanOrEqual<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertLessThanOrEqualMacro"
) where T: Comparable

// MARK: Binary With Tolerance

/// Emulation of `XCTAssertEqual` with tolerance
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - accuracy: The maximum difference allowed between the values.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that two values are equal within a specified accuracy. This is essential
/// for comparing floating-point numbers where exact equality may not be possible due
/// to precision limitations. The test passes if the absolute difference between the
/// two values is less than or equal to the accuracy parameter.
@freestanding(expression)
public macro XCTAssertEqual<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  accuracy: T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertEqualWithToleranceMacro"
) where T: FloatingPoint

/// Emulation of `XCTAssertEqual` with tolerance
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - accuracy: The maximum difference allowed between the values.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that two values are equal within a specified accuracy. This is essential
/// for comparing numeric values where exact equality may not be possible due
/// to precision limitations. The test passes if the absolute difference between the
/// two values is less than or equal to the accuracy parameter.
@freestanding(expression)
public macro XCTAssertEqual<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  accuracy: T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertEqualWithToleranceMacro"
) where T: Numeric

/// Emulation of `XCTAssertNotEqual` with tolerance
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - accuracy: The minimum difference required between the values.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that two floating-point values are not equal within a specified accuracy.
/// This is specifically designed for comparing floating-point values where you want
/// to ensure they differ by more than a certain threshold. The test passes if the
/// absolute difference between the two values is greater than the accuracy parameter.
@freestanding(expression)
public macro XCTAssertNotEqual<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  accuracy: T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertNotEqualWithToleranceMacro"
) where T: FloatingPoint

/// Emulation of `XCTAssertNotEqual` with tolerance
///
/// - Parameters:
///   - expression1: First value to compare.
///   - expression2: Second value to compare.
///   - accuracy: The minimum difference required between the values.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///
/// Asserts that two numeric values are not equal within a specified accuracy.
/// This is specifically designed for comparing numeric values where you want
/// to ensure they differ by more than a certain threshold. The test passes if the
/// absolute difference between the two values is greater than the accuracy parameter.
@freestanding(expression)
public macro XCTAssertNotEqual<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  accuracy: T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertNotEqualWithToleranceMacro"
) where T: Numeric

/// Emulation of `XCTAssertThrowsError`
///
/// - Parameters:
///   - expression: An expression that can throw an error.
///   - message: An optional description of the failure. (default: "")
///   - file: The file where failure occurred. (default: `#filePath`)
///   - line: The line number where failure occurred. (default: `#line`)
///   - errorHandler: An optional closure to handle the error that was thrown.
///
/// Asserts that an expression throws an error. The test passes if the expression
/// throws any error. If an errorHandler is provided, it receives the thrown error
/// for additional validation.
@freestanding(expression)
public macro XCTAssertThrowsError<T>(
  _ expression: @autoclosure () throws -> T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line,
  _ errorHandler: ((any Error) -> Void)? = nil
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertThrowsErrorMacro"
)
