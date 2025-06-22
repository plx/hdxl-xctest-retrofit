import Testing
import HDXLXCTestRetrofit

@Suite
struct UnconditionalFailureTests {
  
  @Test("XCTFail")
  func testXCTFail() {
    withKnownIssue {
      #XCTFail()
    }
  }

  @Test("XCTFail")
  func testXCTFailWithSourceLocation() {
    let sourceLocation = #_sourceLocation
    withKnownIssue {
      #XCTFail("Boo!", sourceLocation: sourceLocation)
    }
  }

  @Test("XCTFail")
  func testXCTFailWithMessage() {
    withKnownIssue {
      #XCTFail("Boo!")
    }
  }

  @Test("XCTFail")
  func testXCTFailWithMessageAndSourceLocation() {
    let sourceLocation = #_sourceLocation
    withKnownIssue {
      #XCTFail("Boo!", sourceLocation: sourceLocation)
    }
  }
  
}
