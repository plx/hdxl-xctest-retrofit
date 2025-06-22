import Testing
import HDXLXCTestRetrofit

@Suite
struct BinaryAssertionFailureTests {
  
  @Test("XCTAssertEqual (failure)")
  func testXCTAssertEqualFailure() {
    withKnownIssue {
      #XCTAssertEqual(0, 1)
      #XCTAssertEqual(0, 1, "one")
    }
  }
  
  @Test("XCTAssertNotEqual (failure)")
  func testXCTAssertNotEqualFailure() {
    withKnownIssue {
      #XCTAssertNotEqual(2, 2)
      #XCTAssertNotEqual(2, 2, "one")
    }
  }

  @Test("XCTAssertIdentical (failure)")
  func testXCTAssertIdenticalFailure() throws {
    let a = EmptyObject()
    let b = EmptyObject()
    try #require(a !== b)
    withKnownIssue {
      #XCTAssertIdentical(a, b)
      #XCTAssertIdentical(a, b, "one")
    }
  }

  @Test("XCTAssertNotIdentical (failure)")
  func testXCTAssertNotIdenticalFailure()  {
    let object = EmptyObject()
    withKnownIssue {
      #XCTAssertNotIdentical(object, object)
      #XCTAssertNotIdentical(object, object, "one")
    }
  }

  @Test("XCTAssertGreaterThan (failure)")
  func testXCTAssertGreaterThanFailure() {
    withKnownIssue {
      #XCTAssertLessThan(3, 2)
      #XCTAssertLessThan(3, 2, "foo")
    }
  }

  @Test("XCTAssertLessThan (failure)")
  func testXCTAssertLessThanFailure() {
    withKnownIssue {
      #XCTAssertLessThan(3, 3)
      #XCTAssertLessThan(3, 3, "foo")
    }
  }

  @Test("XCTAssertGreaterThanOrEqual (failure)")
  func testXCTAssertGreaterThanOrEqualFailure() {
    withKnownIssue {
      #XCTAssertGreaterThanOrEqual(2, 3)
      #XCTAssertGreaterThanOrEqual(2, 3, "foo")
    }
  }
  
  @Test("XCTAssertLessThanOrEqual (failure)")
  func testXCTAssertLessThanOrEqualFailure() {
    withKnownIssue {
      #XCTAssertLessThanOrEqual(3, 2)
      #XCTAssertLessThanOrEqual(3, 2, "foo")
    }
  }

}

fileprivate class EmptyObject {}
