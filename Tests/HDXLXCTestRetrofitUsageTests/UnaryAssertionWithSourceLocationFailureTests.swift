import Testing
import HDXLXCTestRetrofit

@Suite
struct UnaryAssertionWithSourceLocationFailureTests {
  
  let sourceLocation: SourceLocation = #_sourceLocation

  @Test("XCTAssert (failure)")
  func testXCTAssertFailure() {
    withKnownIssue {
      #XCTAssert(false, sourceLocation: sourceLocation)
      #XCTAssert(false, "this should fail", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTAssertTrue (failure)")
  func testXCTAssertTrueFailure() {
    withKnownIssue {
      #XCTAssertTrue(false, sourceLocation: sourceLocation)
      #XCTAssertTrue(false, "this should fail", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTAssertFalse (failure)")
  func testXCTAssertFalseFailure() {
    withKnownIssue {
      #XCTAssertFalse(true, sourceLocation: sourceLocation)
      #XCTAssertFalse(true, "this should fail", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTAssertNil (failure)")
  func testXCTAssertNilFailure() {
    withKnownIssue {
      #XCTAssertNil(1 as Int?, sourceLocation: sourceLocation)
      #XCTAssertNil(1 as Int?, "this should fail", sourceLocation: sourceLocation)
    }
  }
  
  @Test("XCTAssertNotNil (failure)")
  func testXCTAssertNotNilFailure() {
    withKnownIssue {
      #XCTAssertNotNil(nil as Int?, sourceLocation: sourceLocation)
      #XCTAssertNotNil(nil as Int?, "this should fail", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTUnwrap (failure)")
  func testXCTUnwrapFailure() throws {
    let wrapped: Int? = nil
    withKnownIssue {
      _ = try #XCTUnwrap(wrapped, sourceLocation: sourceLocation)
    }
  }

}
