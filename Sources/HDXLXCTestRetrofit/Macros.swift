
// MARK: Unary

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

@freestanding(expression)
public macro XCTUnwrap<T>(
  _ expression: @autoclosure () throws -> T?,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTUnwrapMacro"
)

// MARK: Binary

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

@freestanding(expression)
public macro XCTAssertGreaterThan<T>(
  _ expression1: @autoclosure () throws -> T,
  _ expression2: @autoclosure () throws -> T,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) = #externalMacro(
  module: "HDXLXCTestRetrofitMacros",
  type: "XCTAssertGreaterThanOrEqualMacro"
) where T: Comparable

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


