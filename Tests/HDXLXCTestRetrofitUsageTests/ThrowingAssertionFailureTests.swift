import Testing
import HDXLXCTestRetrofit

@Suite
struct ThrowingAssertionFailureTests {
  
  enum TestError: Error {
    case expectedError
  }
  
  func functionThatDoesNotThrow() throws -> Int {
    42
  }
  
  func functionThatThrows() throws -> Int {
    throw TestError.expectedError
  }
  
  @Test("XCTAssertThrowsError - Failure when no error thrown")
  func testXCTAssertThrowsErrorFailure() {
    withKnownIssue {
      let _ = #XCTAssertThrowsError(try functionThatDoesNotThrow())
    }
  }
  
  @Test("XCTAssertThrowsError - Failure with message")
  func testXCTAssertThrowsErrorFailureWithMessage() {
    withKnownIssue {
      #XCTAssertThrowsError(try functionThatDoesNotThrow(), "Expected to throw")
    }
  }
  
  @Test("XCTAssertThrowsError - Failure with error handler")
  func testXCTAssertThrowsErrorFailureWithHandler() {
    var handlerCalled = false
    
    withKnownIssue {
      #XCTAssertThrowsError(try functionThatDoesNotThrow()) { _ in
        handlerCalled = true
      }
    }
    
    // The handler should not be called because no error was thrown
    #expect(handlerCalled == false)
  }
  
  // MARK: - XCTAssertNoThrow Failure Tests
  
  @Test("XCTAssertNoThrow - Failure when error thrown")
  func testXCTAssertNoThrowFailure() throws {
    withKnownIssue {
      #XCTAssertNoThrow(functionThatThrows())
    }
  }
  
  @Test("XCTAssertNoThrow - Failure with custom message")
  func testXCTAssertNoThrowFailureWithMessage() throws {
    withKnownIssue {
      #XCTAssertNoThrow(functionThatThrows(), "Expected not to throw")
    }
  }
    
  @Test("XCTAssertNoThrow - Failure with complex expression")
  func testXCTAssertNoThrowFailureComplexExpression() throws {
    let value = 10
    
    withKnownIssue {
      #XCTAssertNoThrow({
        if value > 5 {
          throw TestError.expectedError
        }
        return value
      }())
    }
  }
}
