import Testing
import HDXLXCTestRetrofit

@Suite
struct BinaryAssertionWithToleranceTests {
  
  @Test("XCTAssertEqual")
  func testXCTAssertEqual() {
    #XCTAssertEqual(1.0, 0.9, accuracy: 0.2)
    #XCTAssertEqual(1.0, 0.9, accuracy: 0.2, "close!")
  }
  
  @Test("XCTAssertNotEqual")
  func testXCTAssertNotEqual() {
    #XCTAssertNotEqual(1.0, 0.9, accuracy: 0.05)
    #XCTAssertNotEqual(1.0, 0.9, accuracy: 0.05, "not close enough!")
  }

}
