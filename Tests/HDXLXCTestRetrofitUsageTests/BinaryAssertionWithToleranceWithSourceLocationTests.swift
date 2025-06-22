import Testing
import HDXLXCTestRetrofit

@Suite
struct BinaryAssertionWithToleranceWithSourceLocationTests {

  let sourceLocation = #_sourceLocation

  @Test("XCTAssertEqual")
  func testXCTAssertEqual() {
    #XCTAssertEqual(1.0, 0.9, accuracy: 0.2, sourceLocation: sourceLocation)
    #XCTAssertEqual(1.0, 0.9, accuracy: 0.2, "close!", sourceLocation: sourceLocation)
  }
  
  @Test("XCTAssertNotEqual")
  func testXCTAssertNotEqual() {
    #XCTAssertNotEqual(1.0, 0.9, accuracy: 0.05, sourceLocation: sourceLocation)
    #XCTAssertNotEqual(1.0, 0.9, accuracy: 0.05, "not close enough!", sourceLocation: sourceLocation)
  }

}
