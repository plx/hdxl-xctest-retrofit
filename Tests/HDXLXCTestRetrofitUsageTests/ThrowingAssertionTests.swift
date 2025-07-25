import Testing
import HDXLXCTestRetrofit

@Suite
struct ThrowingAssertionTests {
  
  enum TestError: Error, Equatable {
    case expectedError
    case unexpectedError
  }
  
  func functionThatThrows() throws -> Int {
    throw TestError.expectedError
  }
  
  func functionThatDoesNotThrow() throws -> Int {
    42
  }
  
  @Test("XCTAssertThrowsError - Basic")
  func testXCTAssertThrowsErrorBasic() {
    #XCTAssertThrowsError(try functionThatThrows())
    #XCTAssertThrowsError(try functionThatThrows(), "Should throw an error")
  }
  
  @Test("XCTAssertThrowsError - With error handler")
  func testXCTAssertThrowsErrorWithHandler() {
    var capturedError: Error?
    
    #XCTAssertThrowsError(try functionThatThrows()) { error in
      capturedError = error
    }
    
    #expect(capturedError as? TestError == TestError.expectedError)
  }
  
  @Test("XCTAssertThrowsError - With message and error handler")
  func testXCTAssertThrowsErrorWithMessageAndHandler() {
    var capturedError: Error?
    
    #XCTAssertThrowsError(try functionThatThrows(), "Expected to throw") { error in
      capturedError = error
    }
    
    #expect(capturedError as? TestError == TestError.expectedError)
  }
  
  @Test("XCTAssertThrowsError - Complex expression")
  func testXCTAssertThrowsErrorComplexExpression() {
    let value = 10
    
    #XCTAssertThrowsError(try {
      if value > 5 {
        throw TestError.expectedError
      }
      return value
    }())
  }
  
  @Test("XCTAssertThrowsError - Validate specific error type")
  func testXCTAssertThrowsErrorValidateErrorType() {
    #XCTAssertThrowsError(try functionThatThrows()) { error in
      #expect(error is TestError)
      #expect(error as? TestError == TestError.expectedError)
    }
  }
  
  // MARK: - XCTAssertNoThrow Tests
  
  @Test("XCTAssertNoThrow - Basic success")
  func testXCTAssertNoThrowBasic() throws {
    #XCTAssertNoThrow(functionThatDoesNotThrow())
  }
  
  @Test("XCTAssertNoThrow - With custom message")
  func testXCTAssertNoThrowWithMessage() throws {
    #XCTAssertNoThrow(functionThatDoesNotThrow(), "Should not throw")
  }
  
  @Test("XCTAssertNoThrow - Complex expression")
  func testXCTAssertNoThrowComplexExpression() throws {
    let value = 3
    
    #XCTAssertNoThrow({
      if value > 5 {
        throw TestError.unexpectedError
      }
      return value * 2
    }())
  }
  
  @Test("XCTAssertNoThrow - With optional unwrapping")
  func testXCTAssertNoThrowOptionalUnwrapping() throws {
    let optionalValue: Int? = 100
    
    #XCTAssertNoThrow({
      guard let value = optionalValue else {
        throw TestError.unexpectedError
      }
      return value
    }())
  }
  
  @Test("XCTAssertNoThrow - Closure is called")
  func testXCTAssertNoThrowVoidReturn() throws {
    var sideEffect = false
    
    // note: we need to include the explicit signature here,
    // or else we will get a warning after expansion b/c the
    // closure-literal will (correctly) be inferred to be throwing,
    // at which point we're wrapping a non-throwing bit of logic
    // in `do { try ... } catch { }`, which *does* deserve a warning.
    //
    #XCTAssertNoThrow({ () throws -> Void in
      sideEffect = true
      // Function that doesn't throw and returns Void
    }())
    
    #expect(sideEffect == true)
  }
}
