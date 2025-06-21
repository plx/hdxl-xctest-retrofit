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
    #XCTAssertFalse(true)
    #XCTAssertFalse(!false)
    
    #XCTAssertFalse(true, "really")
    #XCTAssertFalse(!false, "again")
  }

}
