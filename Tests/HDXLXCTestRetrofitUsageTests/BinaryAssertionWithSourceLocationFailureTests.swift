import Testing
import HDXLXCTestRetrofit

@Suite
struct BinaryAssertionWithSourceLocationFailureTests {

  let sourceLocation: SourceLocation = #_sourceLocation

  @Test("XCTAssertEqual (failure)")
  func testXCTAssertEqualFailure() {
    withKnownIssue {
      #XCTAssertEqual(0, 1, sourceLocation: sourceLocation)
      #XCTAssertEqual(0, 1, "one", sourceLocation: sourceLocation)
    }
  }
  
  @Test("XCTAssertNotEqual (failure)")
  func testXCTAssertNotEqualFailure() {
    withKnownIssue {
      #XCTAssertNotEqual(2, 2, sourceLocation: sourceLocation)
      #XCTAssertNotEqual(2, 2, "one", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTAssertIdentical (failure)")
  func testXCTAssertIdenticalFailure() throws {
    let a = EmptyObject()
    let b = EmptyObject()
    try #require(a !== b)
    withKnownIssue {
      #XCTAssertIdentical(a, b, sourceLocation: sourceLocation)
      #XCTAssertIdentical(a, b, "one", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTAssertNotIdentical (failure)")
  func testXCTAssertNotIdenticalFailure()  {
    let object = EmptyObject()
    withKnownIssue {
      #XCTAssertNotIdentical(object, object, sourceLocation: sourceLocation)
      #XCTAssertNotIdentical(object, object, "one", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTAssertGreaterThan (failure)")
  func testXCTAssertGreaterThanFailure() {
    withKnownIssue {
      #XCTAssertLessThan(3, 2, sourceLocation: sourceLocation)
      #XCTAssertLessThan(3, 2, "foo", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTAssertLessThan (failure)")
  func testXCTAssertLessThanFailure() {
    withKnownIssue {
      #XCTAssertLessThan(3, 3, sourceLocation: sourceLocation)
      #XCTAssertLessThan(3, 3, "foo", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTAssertGreaterThanOrEqual (failure)")
  func testXCTAssertGreaterThanOrEqualFailure() {
    withKnownIssue {
      #XCTAssertGreaterThanOrEqual(2, 3, sourceLocation: sourceLocation)
      #XCTAssertGreaterThanOrEqual(2, 3, "foo", sourceLocation: sourceLocation)
    }
  }
  
  @Test("XCTAssertLessThanOrEqual (failure)")
  func testXCTAssertLessThanOrEqualFailure() {
    withKnownIssue {
      #XCTAssertLessThanOrEqual(3, 2, sourceLocation: sourceLocation)
      #XCTAssertLessThanOrEqual(3, 2, "foo", sourceLocation: sourceLocation)
    }
  }

}

private class EmptyObject {}
