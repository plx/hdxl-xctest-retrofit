import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: XCTAssertionMacroProtocol

public protocol XCTAssertionMacroProtocol: ExpressionMacro {
  
  static var mandatoryArgumentCount: Int { get }
  static var rewrittenInvocationName: String { get }

  static func expectedInvocationFunctionName() throws -> String

}

// MARK: - Default Implementations

extension XCTAssertionMacroProtocol {
  
  public static var rewrittenInvocationName: String { "expect"}
  
  public static func expectedInvocationFunctionName() throws -> String {
    var macroName = String(describing: self)
    guard
      macroName.hasPrefix("XCT"),
      macroName.hasSuffix("Macro"),
      let hdxlRange = macroName.range(of: "XCT"),
      let macroRange = macroName.range(of: "Macro", options: .backwards)
    else {
      throw XCTAssertionMacroError.unableToInferXCTAssertionName(String(reflecting: self))
    }
    // back-to-front
    macroName.removeSubrange(macroRange)
    macroName.removeSubrange(hdxlRange)
    return "XCT" + macroName
  }
  
}

// MARK: - Convenience API

extension XCTAssertionMacroProtocol {
  
  package static func verifyInvocationName(of node: some FreestandingMacroExpansionSyntax) throws {
    let expectedName = try expectedInvocationFunctionName()
    let observedName = node.macroName.trimmed.text
    guard observedName == expectedName else {
      throw XCTAssertionMacroError.unexpectedXCTAssertionName(expectedName, observedName)
    }
  }
  
  package static func verifyArgumentCount(of node: some FreestandingMacroExpansionSyntax) throws {
    guard node.arguments.count >= mandatoryArgumentCount else {
      throw XCTAssertionMacroError.insufficientArgumentCount(
        String(reflecting: self),
        mandatoryArgumentCount,
        node.arguments.count
      )
    }
  }
  
  package static func verifyStandardProperties(of node: some FreestandingMacroExpansionSyntax) throws {
    try verifyInvocationName(of: node)
    try verifyArgumentCount(of: node)
  }

  package static func extractContextArguments(
    of node: some FreestandingMacroExpansionSyntax
  ) throws -> XCTAssertionContextArguments {
    guard
      let contextArguments = XCTAssertionContextArguments(
        labeledExprListSyntax: node.arguments,
        mandatoryArgumentCount: mandatoryArgumentCount
      )
    else {
      throw XCTAssertionMacroError.unableToExtractContextArguments(String(reflecting: self))
    }
    
    return contextArguments
  }
  
}

