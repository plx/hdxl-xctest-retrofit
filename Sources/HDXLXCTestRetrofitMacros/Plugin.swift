import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct HDXLXCTestRetrofitPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    XCTAssertMacro.self,
    XCTAssertTrueMacro.self,
    XCTAssertFalseMacro.self,
    XCTAssertNotNilMacro.self,
    XCTAssertNilMacro.self,
    XCTUnwrapMacro.self,
    
    XCTAssertEqualMacro.self,
    XCTAssertNotEqualMacro.self,
    XCTAssertIdenticalMacro.self,
    XCTAssertNotIdenticalMacro.self,

    XCTAssertGreaterThanMacro.self,
    XCTAssertGreaterThanOrEqualMacro.self,
    XCTAssertLessThanMacro.self,
    XCTAssertLessThanOrEqualMacro.self
  ]
}

