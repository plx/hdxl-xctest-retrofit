import Testing
import HDXLXCTestRetrofit

@Suite
struct UnaryAssertionFailureTests {
  
  @Test("XCTAssert (failure)")
  func testXCTAssertFailure() {
    withKnownIssue {
      #XCTAssert(false)
      #XCTAssert(false, "this should fail")
    }
  }

  @Test("XCTAssertTrue (failure)")
  func testXCTAssertTrueFailure() {
    withKnownIssue {
      #XCTAssertTrue(false)
      #XCTAssertTrue(false, "this should fail")
    }
  }

  @Test("XCTAssertFalse (failure)")
  func testXCTAssertFalseFailure() {
    withKnownIssue {
      #XCTAssertFalse(true)
      #XCTAssertFalse(true, "this should fail")
    }
  }

  @Test("XCTAssertNil (failure)")
  func testXCTAssertNilFailure() {
    withKnownIssue {
      #XCTAssertNil(1 as Int?)
      #XCTAssertNil(1 as Int?, "this should fail")
    }
  }
  
  @Test("XCTAssertNotNil (failure)")
  func testXCTAssertNotNilFailure() {
    withKnownIssue {
      #XCTAssertNotNil(nil as Int?)
      #XCTAssertNotNil(nil as Int?, "this should fail")
    }
  }

  @Test("XCTUnwrap (failure)")
  func testXCTUnwrapFailure() throws {
    let wrapped: Int? = nil
    withKnownIssue {
      _ = try #XCTUnwrap(wrapped)
    }
  }

}
