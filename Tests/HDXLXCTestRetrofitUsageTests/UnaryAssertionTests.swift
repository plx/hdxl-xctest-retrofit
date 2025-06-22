import Testing
import HDXLXCTestRetrofit

@Suite
struct UnaryAssertionTests {
  
  @Test("XCTAssert")
  func testXCTAssert() {
    #XCTAssert(true)
    #XCTAssert(!false)

    #XCTAssert(true, "really")
    #XCTAssert(!false, "again")
  }

  @Test("XCTAssertTrue")
  func testXCTAssertTrue() {
    #XCTAssertTrue(true)
    #XCTAssertTrue(!false)
    
    #XCTAssertTrue(true, "really")
    #XCTAssertTrue(!false, "again")
  }

  @Test("XCTAssertFalse")
  func testXCTAssertFalse() {
    #XCTAssertFalse(false)
    #XCTAssertFalse(!true)
    
    #XCTAssertFalse(false, "really")
    #XCTAssertFalse(!true, "again")
  }

  @Test("XCTAssertNil")
  func testXCTAssertNil() {
    #XCTAssertNil(nil as Int?)
    #XCTAssertNil(nil as Int?, "notnil")
  }
  
  @Test("XCTAssertNotNil")
  func testXCTAssertNotNil() {
    #XCTAssertNotNil(1 as Int?)
    #XCTAssertNotNil(1 as Int?, "not-nil")
  }
  
  @Test("XCTUnwrap")
  func testXCTUnwrap() throws {
    let wrapped: Int? = 7
    let unwrapped = try #XCTUnwrap(wrapped)
    #expect(
      unwrapped == wrapped
    )
  }


}
