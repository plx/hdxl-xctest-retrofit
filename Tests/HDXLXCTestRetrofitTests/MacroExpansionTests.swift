import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import HDXLXCTestRetrofitMacros

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(HDXLXCTestRetrofitMacros)

private func allTestMacros() -> [String: XCTAssertionMacroProtocol.Type] {
  [
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
    "XCTAssertLessThanOrEqual": XCTAssertLessThanOrEqualMacro.self,
    "XCTAssertThrowsError": XCTAssertThrowsErrorMacro.self,
    "XCTAssertNoThrow": XCTAssertNoThrowMacro.self
  ]
}

#if swift(>=6.1)
let testMacros: [String: XCTAssertionMacroProtocol.Type] = allTestMacros()
#else
nonisolated(unsafe) let testMacros: [String: XCTAssertionMacroProtocol.Type] = allTestMacros()
#endif
#endif

final class MacroExpansionTests: XCTestCase {
  
  
func testXCTAssertExpansion() throws {
#if canImport(HDXLXCTestRetrofitMacros)
    assertTrimmedMacroExpansion(
      """
      #XCTAssert(true)
      """,
      expandedSource:
      """
      #expect(Bool((true)))
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
      """
      #XCTAssert(true, "boo!")
      """,
      expandedSource:
      """
      #expect(Bool((true)), "boo!")
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
      """
      #XCTAssert(true, "boo!", file: file, line: line)
      """,
      expandedSource:
      """
      #expect(Bool((true)), "boo!", sourceLocation: SourceLocation(file: file, line: line))
      """,
      macros: testMacros
    )
#endif
  }
  
  func testXCTAssertEqualExpansion() throws {
#if canImport(HDXLXCTestRetrofitMacros)
    assertTrimmedMacroExpansion(
      """
      #XCTAssertEqual(a, b)
      """,
      expandedSource:
      """
      #expect((a) == (b))
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
      """
      #XCTAssertEqual(a, b, "boo!")
      """,
      expandedSource:
      """
      #expect((a) == (b), "boo!")
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
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
  
  func testXCTAssertNoThrowExpansion() throws {
#if canImport(HDXLXCTestRetrofitMacros)
    assertTrimmedMacroExpansion(
      """
      #XCTAssertNoThrow(nonThrowingFunction())
      """,
      expandedSource:
      """
      {
        do {
          let _ =  try (nonThrowingFunction())
        } catch let error {
          Issue.record("Unexpected error thrown: \\(error)")
        }
      }()
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
      """
      #XCTAssertNoThrow(nonThrowingFunction(), "Should not throw")
      """,
      expandedSource:
      """
      {
        do {
          let _ =  try (nonThrowingFunction())
        } catch let error {
          Issue.record("Unexpected error thrown: \\(error) - \\("Should not throw")")
        }
      }()
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
      """
      #XCTAssertNoThrow(nonThrowingFunction(), "Should not throw", file: file, line: line)
      """,
      expandedSource:
      """
      {
        do {
          let _ =  try (nonThrowingFunction())
        } catch let error {
          Issue.record("Unexpected error thrown: \\(error) - \\("Should not throw")")
        }
      }()
      """,
      macros: testMacros
    )
#endif
  }

  func testXCTAssertThrowsErrorExpansion() throws {
#if canImport(HDXLXCTestRetrofitMacros)
    assertTrimmedMacroExpansion(
      """
      #XCTAssertThrowsError(try throwingFunction())
      """,
      expandedSource:
      """
      #expect(throws: (any Error).self) {
          (try throwingFunction())
      }
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
      """
      #XCTAssertThrowsError(try throwingFunction(), "Expected to throw")
      """,
      expandedSource:
      """
      #expect(throws: (any Error).self, "Expected to throw") {
          (try throwingFunction())
      }
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
      """
      #XCTAssertThrowsError(try throwingFunction(), "Expected to throw", file: file, line: line)
      """,
      expandedSource:
      """
      #expect(throws: (any Error).self, "Expected to throw", sourceLocation: SourceLocation(file: file, line: line)) {
          (try throwingFunction())
      }
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
      """
      #XCTAssertThrowsError(try throwingFunction()) { error in
        print(error)
      }
      """,
      expandedSource:
      """
      {
        let __macro_local_11thrownErrorfMu_ = #expect(throws: (any Error).self) {
            (try throwingFunction())
        }
        if let __macro_local_11thrownErrorfMu_ {
          { error in
            print(error)
          }(__macro_local_11thrownErrorfMu_)
        }

        return __macro_local_11thrownErrorfMu_
      }()
      """,
      macros: testMacros
    )
    
    assertTrimmedMacroExpansion(
      """
      #XCTAssertThrowsError(try throwingFunction(), "custom message") { error in
        print(error)
      }
      """,
      expandedSource:
      """
      {
        let __macro_local_11thrownErrorfMu_ = #expect(throws: (any Error).self, "custom message") {
            (try throwingFunction())
        }
        if let __macro_local_11thrownErrorfMu_ {
          { error in
            print(error)
          }(__macro_local_11thrownErrorfMu_)
        }

        return __macro_local_11thrownErrorfMu_
      }()
      """,
      macros: testMacros
    )
#endif
  }
}


func assertTrimmedMacroExpansion(
  _ originalSource: String,
  expandedSource expectedExpandedSource: String,
  diagnostics: [DiagnosticSpec] = [],
  macros: [String: Macro.Type],
  applyFixIts: [String]? = nil,
  fixedSource expectedFixedSource: String? = nil,
  testModuleName: String = "TestModule",
  testFileName: String = "test.swift",
  indentationWidth: Trivia = .spaces(4),
  file: StaticString = #filePath,
  line: UInt = #line
) {
  assertMacroExpansion(
    originalSource.trimmingTrailingWhitespace(),
    expandedSource: expectedExpandedSource.trimmingTrailingWhitespace(),
    diagnostics: diagnostics,
    macros: macros,
    applyFixIts: applyFixIts,
    fixedSource: expectedFixedSource,
    testModuleName: testModuleName,
    testFileName: testFileName,
    indentationWidth: indentationWidth,
    file: file,
    line: line
  )
}
