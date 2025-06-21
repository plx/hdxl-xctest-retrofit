import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public protocol XCTAssertionMacroProtocol: ExpressionMacro, SendableMetatype {
  
  static func expectedInvocationFunctionName() throws -> String
  static var mandatoryArgumentCount: Int { get }
  
  static var swiftTestingMacroName: String { get }
  
  static func swiftTestingMacroArguments(
    assertionExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) throws -> LabeledExprListSyntax

  static var addDefensiveParentheses: Bool { get }

}

extension XCTAssertionMacroProtocol {
  
  public static var addDefensiveParentheses: Bool { true }

  public static var swiftTestingMacroName: String { "expect"}
  
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
  
  public static func swiftTestingMacroArguments(
    assertionExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) -> LabeledExprListSyntax {
    LabeledExprListSyntax {
      LabeledExprSyntax(expression: assertionExpression)
      if let messageExpression = contextArguments.messageExpression {
        LabeledExprSyntax(expression: messageExpression)
      }
      if let fileExpression = contextArguments.fileExpression, let lineExpression = contextArguments.lineExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(file: \(fileExpression), line: \(lineExpression))" as ExprSyntax
        )
      } else if let fileExpression = contextArguments.fileExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(file: \(fileExpression))" as ExprSyntax
        )
      } else if let lineExpression = contextArguments.lineExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(line: \(lineExpression))" as ExprSyntax
        )
      }
    }
  }

}


public enum XCTAssertionMacroError: Error, CustomStringConvertible {
  
  case unableToInferXCTAssertionName(String)
  case unexpectedXCTAssertionName(String, String)
  case insufficientArgumentCount(String, Int, Int)
  case unableToExtractContextArguments(String)

  public var description: String {
    switch self {
    case .unableToInferXCTAssertionName(let macroName):
      """
      Unable to infer an XCT assertion name from `\(macroName)`!
      """
    case .unexpectedXCTAssertionName(let expected, let observed):
      """
      Expected assertion-name `\(expected)` but encountered `\(observed)` instead!
      """
    case .insufficientArgumentCount(let macroName, let minimum, let observed):
      """
      `\(macroName)` needs at-least \(minimum) arguments, but only saw `\(observed)`, instead!
      """
    case .unableToExtractContextArguments(let macroName):
      """
      `\(macroName)` failed to extract usable context arguments!
      """
    }
  }
  
}
