import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import HDXLXCTestRetrofitMacros

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(HDXLXCTestRetrofitMacros)

let testMacros: [String: XCTAssertionMacroProtocol.Type] = [
  "XCTAssert": XCTAssertMacro.self,
  "XCTAssertTrue": XCTAssertTrueMacro.self,
  "XCTAssertFalse": XCTAssertFalseMacro.self,
  "XCTAssertNotNil": XCTAssertNotNilMacro.self,
  "XCTAssertNil": XCTAssertNilMacro.self,
  "XCTAssertEqual": XCTAssertEqualMacro.self,
  "XCTAssertNotEqual": XCTAssertNotEqualMacro.self,
  "XCTAssertIdentical": XCTAssertIdenticalMacro.self,
  "XCTAssertNotIdentical": XCTAssertNotIdenticalMacro.self,
  "XCTAssertGreaterThan": XCTAssertGreaterThanMacro.self,
  "XCTAssertGreaterThanOrEqual": XCTAssertGreaterThanOrEqualMacro.self,
  "XCTAssertLessThan": XCTAssertLessThanMacro.self,
  "XCTAssertLessThanOrEqual": XCTAssertLessThanOrEqualMacro.self
]
#endif

final class HDXLXCTestRetrofitMacrosTests : XCTestCase {
  
  
  func testXCTAssertExpansion() throws {
#if canImport(HDXLXCTestRetrofitMacros)
    assertMacroExpansion(
      """
      #XCTAssert(true)
      """,
      expandedSource:
      """
      #expect(true)
      """,
      macros: testMacros
    )
    
    assertMacroExpansion(
      """
      #XCTAssert(true, "boo!")  
      """,
      expandedSource:
      """
      #expect(true, "boo!")
      """,
      macros: testMacros
    )
    
    assertMacroExpansion(
      """
      #XCTAssert(true, "boo!", file: file, line: line)  
      """,
      expandedSource:
      """
      #expect(true, "boo!", sourceLocation: SourceLocation(file: file, line: line))
      """,
      macros: testMacros
    )
#endif
  }
  
  func testXCTAssertEqualExpansion() throws {
#if canImport(HDXLXCTestRetrofitMacros)
    assertMacroExpansion(
      """
      #XCTAssertEqual(a, b)
      """,
      expandedSource:
      """
      #expect((a) == (b))
      """,
      macros: testMacros
    )
    
    assertMacroExpansion(
      """
      #XCTAssertEqual(a, b, "boo!")
      """,
      expandedSource:
      """
      #expect((a) == (b), "boo!")
      """,
      macros: testMacros
    )
    
    assertMacroExpansion(
      """
      #XCTAssertEqual(a, b, "boo!", file: file, line: line)
      """,
      expandedSource:
      """
      #expect((a) == (b), "boo!", sourceLocation: SourceLocation(file: file, line: line))
      """,
      macros: testMacros
    )
#endif
  }
}
