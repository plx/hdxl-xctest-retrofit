import Testing
import HDXLXCTestRetrofit

@Suite
struct BinaryAssertionWithToleranceFailureTests {
  
  @Test("XCTAssertEqual (failure)")
  func testXCTAssertEqual() {
    withKnownIssue {
      #XCTAssertEqual(1.0, 0.9, accuracy: 0.05)
      #XCTAssertEqual(1.0, 0.9, accuracy: 0.05, "close!")
    }
  }
  
  @Test("XCTAssertNotEqual (failure)")
  func testXCTAssertNotEqual() {
    withKnownIssue {
      #XCTAssertNotEqual(1.0, 0.9, accuracy: 0.2)
      #XCTAssertNotEqual(1.0, 0.9, accuracy: 0.2, "not close enough!")
    }
  }

}
