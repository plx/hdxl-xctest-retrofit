import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: XCTBinaryAssertionMacroProtocol

public protocol XCTBinaryAssertionWithToleranceMacroProtocol: XCTConditionalAssertionMacroProtocol {
  
  static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext,
    lhsExpression: ExprSyntax,
    rhsExpression: ExprSyntax,
    toleranceExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) throws -> ExprSyntax
  
  static func prepareAssertionExpression(
    lhsExpression: ExprSyntax,
    rhsExpression: ExprSyntax,
    toleranceExpression: ExprSyntax
  ) throws -> ExprSyntax
  
}

// MARK: - Default Implementations

extension XCTBinaryAssertionWithToleranceMacroProtocol {
    
  public static var mandatoryArgumentCount: Int {
    3
  }
    
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext,
    lhsExpression: ExprSyntax,
    rhsExpression: ExprSyntax,
    toleranceExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) throws -> ExprSyntax {
    let assertionExpression = try prepareAssertionExpression(
      lhsExpression: lhsExpression,
      rhsExpression: rhsExpression,
      toleranceExpression: toleranceExpression
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
    
    let (lhsExpression, rhsExpression, toleranceExpression, contextArguments) = try extractBinaryAssertionWithToleranceComponents(
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
      toleranceExpression: toleranceExpression.conditionallyWrappedInParentheses(
        shouldWrap: addDefensiveParentheses
      ),
      contextArguments: contextArguments
    )
  }
  
}

// MARK: Core API

extension XCTBinaryAssertionWithToleranceMacroProtocol {
  
  package static func extractBinaryAssertionWithToleranceComponents(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> (ExprSyntax, ExprSyntax, ExprSyntax, XCTAssertionContextArguments) {
    precondition(node.arguments.count >= mandatoryArgumentCount)
    return (
      node.arguments[node.arguments.startIndex].expression,
      node.arguments[node.arguments.index(
        node.arguments.startIndex,
        offsetBy: 1
      )].expression,
      node.arguments[node.arguments.index(
        node.arguments.startIndex,
        offsetBy: 2
      )].expression,
      try extractContextArguments(of: node)
    )
  }

}
