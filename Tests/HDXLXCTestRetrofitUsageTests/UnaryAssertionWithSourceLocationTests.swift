import Testing
import HDXLXCTestRetrofit

@Suite
struct UnaryAssertionWithSourceLocationTests {
  
  let sourceLocation: SourceLocation = #_sourceLocation
  
  @Test("XCTAssert")
  func testXCTAssert() {
    #XCTAssert(true, sourceLocation: sourceLocation)
    #XCTAssert(!false, sourceLocation: sourceLocation)

    #XCTAssert(true, "really", sourceLocation: sourceLocation)
    #XCTAssert(!false, "again", sourceLocation: sourceLocation)
  }

  @Test("XCTAssertTrue")
  func testXCTAssertTrue() {
    #XCTAssertTrue(true, sourceLocation: sourceLocation)
    #XCTAssertTrue(!false, sourceLocation: sourceLocation)
    
    #XCTAssertTrue(true, "really", sourceLocation: sourceLocation)
    #XCTAssertTrue(!false, "again", sourceLocation: sourceLocation)
  }

  @Test("XCTAssertFalse")
  func testXCTAssertFalse() {
    #XCTAssertFalse(false, sourceLocation: sourceLocation)
    #XCTAssertFalse(!true, sourceLocation: sourceLocation)
    
    #XCTAssertFalse(false, "really", sourceLocation: sourceLocation)
    #XCTAssertFalse(!true, "again", sourceLocation: sourceLocation)
  }

  @Test("XCTAssertNil")
  func testXCTAssertNil() {
    #XCTAssertNil(nil as Int?, sourceLocation: sourceLocation)
    #XCTAssertNil(nil as Int?, "notnil", sourceLocation: sourceLocation)
  }
  
  @Test("XCTAssertNotNil")
  func testXCTAssertNotNil() {
    #XCTAssertNotNil(1 as Int?, sourceLocation: sourceLocation)
    #XCTAssertNotNil(1 as Int?, "not-nil", sourceLocation: sourceLocation)
  }
  
  @Test("XCTUnwrap")
  func testXCTUnwrap() throws {
    let wrapped: Int? = 7
    let unwrapped = try #XCTUnwrap(wrapped, sourceLocation: sourceLocation)
    #expect(
      unwrapped == wrapped
    )
  }


}
