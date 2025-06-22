import Testing
import HDXLXCTestRetrofit

@Suite
struct BinaryAssertionWithSourceLocationTests {
  
  let sourceLocation: SourceLocation = #_sourceLocation
  
  @Test("XCTAssertEqual")
  func testXCTAssertEqual() {
    #XCTAssertEqual(1, 1, sourceLocation: sourceLocation)
    #XCTAssertEqual(1, 1, "one", sourceLocation: sourceLocation)
  }
  
  @Test("XCTAssertNotEqual")
  func testXCTAssertNotEqual() {
    #XCTAssertNotEqual(1, 2, sourceLocation: sourceLocation)
    #XCTAssertNotEqual(2, 1, sourceLocation: sourceLocation)
    #XCTAssertNotEqual(1, 2, "one", sourceLocation: sourceLocation)
    #XCTAssertNotEqual(2, 1, "one", sourceLocation: sourceLocation)
  }

  @Test("XCTAssertIdentical")
  func testXCTAssertIdentical() {
    let object = EmptyObject()
    #XCTAssertIdentical(object, object, sourceLocation: sourceLocation)
    #XCTAssertIdentical(object, object, "one", sourceLocation: sourceLocation)

    #XCTAssertIdentical(nil, nil, sourceLocation: sourceLocation)
    #XCTAssertIdentical(nil, nil, "one", sourceLocation: sourceLocation)
  }

  @Test("XCTAssertNotIdentical")
  func testXCTAssertNotIdentical() throws {
    let a = EmptyObject()
    let b = EmptyObject()
    try #require(a !== b)
    #XCTAssertNotIdentical(a, b, sourceLocation: sourceLocation)
    #XCTAssertNotIdentical(a, b, "one", sourceLocation: sourceLocation)
    
    #XCTAssertNotIdentical(a, nil, sourceLocation: sourceLocation)
    #XCTAssertNotIdentical(a, nil, "one", sourceLocation: sourceLocation)

    #XCTAssertNotIdentical(nil, b, sourceLocation: sourceLocation)
    #XCTAssertNotIdentical(nil, b, "one", sourceLocation: sourceLocation)
  }

  @Test("XCTAssertGreaterThan")
  func testXCTAssertGreaterThan() {
    #XCTAssertGreaterThan(3, 2, sourceLocation: sourceLocation)
    #XCTAssertGreaterThan(3, 2, "foo", sourceLocation: sourceLocation)
  }

  @Test("XCTAssertLessThan")
  func testXCTAssertLessThan() {
    #XCTAssertLessThan(2, 3, sourceLocation: sourceLocation)
    #XCTAssertLessThan(2, 3, "foo", sourceLocation: sourceLocation)
  }

  @Test("XCTAssertGreaterThanOrEqual")
  func testXCTAssertGreaterThanOrEqual() {
    #XCTAssertGreaterThanOrEqual(3, 3, sourceLocation: sourceLocation)
    #XCTAssertGreaterThanOrEqual(3, 3, "foo", sourceLocation: sourceLocation)

    #XCTAssertGreaterThanOrEqual(3, 2, sourceLocation: sourceLocation)
    #XCTAssertGreaterThanOrEqual(3, 2, "foo", sourceLocation: sourceLocation)
  }
  
  @Test("XCTAssertLessThanOrEqual")
  func testXCTAssertLessThanOrEqual() {
    #XCTAssertLessThanOrEqual(2, 3, sourceLocation: sourceLocation)
    #XCTAssertLessThanOrEqual(2, 3, "foo", sourceLocation: sourceLocation)

    #XCTAssertLessThanOrEqual(3, 3, sourceLocation: sourceLocation)
    #XCTAssertLessThanOrEqual(3, 3, "foo", sourceLocation: sourceLocation)
  }

}

fileprivate class EmptyObject {}
