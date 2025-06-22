import Testing
import HDXLXCTestRetrofit

@Suite
struct BinaryAssertionTests {
  
  @Test("XCTAssertEqual")
  func testXCTAssertEqual() {
    #XCTAssertEqual(1, 1)
    #XCTAssertEqual(1, 1, "one")
  }
  
  @Test("XCTAssertNotEqual")
  func testXCTAssertNotEqual() {
    #XCTAssertNotEqual(1, 2)
    #XCTAssertNotEqual(2, 1)
    #XCTAssertNotEqual(1, 2, "one")
    #XCTAssertNotEqual(2, 1, "one")
  }

  @Test("XCTAssertIdentical")
  func testXCTAssertIdentical() {
    let object = EmptyObject()
    #XCTAssertIdentical(object, object)
    #XCTAssertIdentical(object, object, "one")

    #XCTAssertIdentical(nil, nil)
    #XCTAssertIdentical(nil, nil, "one")
  }

  @Test("XCTAssertNotIdentical")
  func testXCTAssertNotIdentical() throws {
    let a = EmptyObject()
    let b = EmptyObject()
    try #require(a !== b)
    #XCTAssertNotIdentical(a, b)
    #XCTAssertNotIdentical(a, b, "one")
    
    #XCTAssertNotIdentical(a, nil)
    #XCTAssertNotIdentical(a, nil, "one")

    #XCTAssertNotIdentical(nil, b)
    #XCTAssertNotIdentical(nil, b, "one")
  }

  @Test("XCTAssertGreaterThan")
  func testXCTAssertGreaterThan() {
    #XCTAssertGreaterThan(3, 2)
    #XCTAssertGreaterThan(3, 2, "foo")
  }

  @Test("XCTAssertLessThan")
  func testXCTAssertLessThan() {
    #XCTAssertLessThan(2, 3)
    #XCTAssertLessThan(2, 3, "foo")
  }

  @Test("XCTAssertGreaterThanOrEqual")
  func testXCTAssertGreaterThanOrEqual() {
    #XCTAssertGreaterThanOrEqual(3, 3)
    #XCTAssertGreaterThanOrEqual(3, 3, "foo")

    #XCTAssertGreaterThanOrEqual(3, 2)
    #XCTAssertGreaterThanOrEqual(3, 2, "foo")
  }
  
  @Test("XCTAssertLessThanOrEqual")
  func testXCTAssertLessThanOrEqual() {
    #XCTAssertLessThanOrEqual(2, 3)
    #XCTAssertLessThanOrEqual(2, 3, "foo")

    #XCTAssertLessThanOrEqual(3, 3)
    #XCTAssertLessThanOrEqual(3, 3, "foo")
  }

}

fileprivate class EmptyObject {}
