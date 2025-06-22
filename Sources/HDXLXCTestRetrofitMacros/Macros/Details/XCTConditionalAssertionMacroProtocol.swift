import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: XCTConditionalAssertionMacroProtocol

public protocol XCTConditionalAssertionMacroProtocol: XCTAssertionMacroProtocol {
  
  static var addDefensiveParentheses: Bool { get }
  
  static func rewrittenArgumentList(
    assertionExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) throws -> LabeledExprListSyntax
  
}

// MARK: - Default Implementations

extension XCTConditionalAssertionMacroProtocol {
  
  public static var addDefensiveParentheses: Bool { true }
  
  public static func rewrittenArgumentList(
    assertionExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) -> LabeledExprListSyntax {
    LabeledExprListSyntax(
      assertionExpression: assertionExpression,
      contextArguments: contextArguments
    )
  }
  
}
