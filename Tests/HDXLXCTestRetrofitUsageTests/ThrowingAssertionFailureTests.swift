import Testing
import HDXLXCTestRetrofit

@Suite
struct ThrowingAssertionFailureTests {
  
  func functionThatDoesNotThrow() throws -> Int {
    42
  }
  
  @Test("XCTAssertThrowsError - Failure when no error thrown")
  func testXCTAssertThrowsErrorFailure() {
    withKnownIssue {
      #XCTAssertThrowsError(try functionThatDoesNotThrow())
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
}