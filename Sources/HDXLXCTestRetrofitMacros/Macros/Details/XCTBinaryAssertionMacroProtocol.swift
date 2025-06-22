import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: XCTBinaryAssertionMacroProtocol

public protocol XCTBinaryAssertionMacroProtocol: XCTConditionalAssertionMacroProtocol {
  
  static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext,
    lhsExpression: ExprSyntax,
    rhsExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) throws -> ExprSyntax
  
  static func prepareAssertionExpression(
    lhsExpression: ExprSyntax,
    rhsExpression: ExprSyntax
  ) throws -> ExprSyntax
  
}

// MARK: - Default Implementations

extension XCTBinaryAssertionMacroProtocol {
    
  public static var mandatoryArgumentCount: Int {
    2
  }
    
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext,
    lhsExpression: ExprSyntax,
    rhsExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) throws -> ExprSyntax {
    let assertionExpression = try prepareAssertionExpression(
      lhsExpression: lhsExpression,
      rhsExpression: rhsExpression
    )
    
    let rewrittenArguments = try rewrittenArgumentList(
      assertionExpression: assertionExpression,
      contextArguments: contextArguments
    )
    
    return try MacroExpansionExprSyntax(
      leadingTrivia: node.leadingTrivia,
      macroName: TokenSyntax.identifier(rewrittenInvocationName),
      genericArgumentClause: node.genericArgumentClause,
      leftParen: node.leftParen,
      arguments: rewrittenArguments,
      rightParen: node.rightParen,
      trailingClosure: node.trailingClosure,
      additionalTrailingClosures: node.additionalTrailingClosures,
      trailingTrivia: node.trailingTrivia
    ).trimmed.validatedAndErasedToExprSyntax()
  }

  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> ExprSyntax {
    try verifyStandardProperties(of: node)
    
    let (lhsExpression, rhsExpression, contextArguments) = try extractBinaryAssertionComponents(
      of: node,
      in: context
    )
    
    return try expansion(
      of: node,
      in: context,
      lhsExpression: lhsExpression.conditionallyWrappedInParentheses(
        shouldWrap: addDefensiveParentheses
      ),
      rhsExpression: rhsExpression.conditionallyWrappedInParentheses(
        shouldWrap: addDefensiveParentheses
      ),
      contextArguments: contextArguments
    )
  }
  
}

// MARK: Core API

extension XCTBinaryAssertionMacroProtocol {
  
  package static func extractBinaryAssertionComponents(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> (ExprSyntax, ExprSyntax, XCTAssertionContextArguments) {
    precondition(node.arguments.count >= mandatoryArgumentCount)
    return (
      node.arguments[node.arguments.startIndex].expression,
      node.arguments[node.arguments.index(after: node.arguments.startIndex)].expression,
      try extractContextArguments(of: node)
    )
  }

}
