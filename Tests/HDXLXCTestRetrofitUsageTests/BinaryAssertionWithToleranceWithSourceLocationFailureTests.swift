import Testing
import HDXLXCTestRetrofit

@Suite
struct BinaryAssertionWithToleranceWithSourceLocationFailureTests {
  
  let sourceLocation = #_sourceLocation

  @Test("XCTAssertEqual (failure)")
  func testXCTAssertEqual() {
    withKnownIssue {
      #XCTAssertEqual(1.0, 0.9, accuracy: 0.05, sourceLocation: sourceLocation)
      #XCTAssertEqual(1.0, 0.9, accuracy: 0.05, "close!", sourceLocation: sourceLocation)
    }
  }
  
  @Test("XCTAssertNotEqual (failure)")
  func testXCTAssertNotEqual() {
    withKnownIssue {
      #XCTAssertNotEqual(1.0, 0.9, accuracy: 0.2, sourceLocation: sourceLocation)
      #XCTAssertNotEqual(1.0, 0.9, accuracy: 0.2, "not close enough!", sourceLocation: sourceLocation)
    }
  }

}
