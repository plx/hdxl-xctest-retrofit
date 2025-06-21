import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public protocol XCTUnaryAssertionMacroProtocol: XCTAssertionMacroProtocol {
  static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext,
    conditionExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) throws -> ExprSyntax
  
  static func prepareAssertionExpression(
    conditionExpression: ExprSyntax
  ) throws -> ExprSyntax

}

extension XCTUnaryAssertionMacroProtocol {
  
  public static var mandatoryArgumentCount: Int {
    1
  }
  
  public static var addDefensiveParentheses: Bool { false }
  
  package static func extractUnaryAssertionComponents(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> (ExprSyntax, XCTAssertionContextArguments) {
    precondition(node.arguments.count >= mandatoryArgumentCount)
    return (
      node.arguments[node.arguments.startIndex].expression,
      try extractContextArguments(of: node)
    )
  }
  
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext,
    conditionExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) throws -> ExprSyntax {
    let assertionExpression = try prepareAssertionExpression(
      conditionExpression: conditionExpression
    )
    
    let rewrittenArguments = try swiftTestingMacroArguments(
      assertionExpression: assertionExpression,
      contextArguments: contextArguments
    )
    
    return try MacroExpansionExprSyntax(
      leadingTrivia: node.leadingTrivia,
      macroName: TokenSyntax.identifier(swiftTestingMacroName),
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

    let (conditionExpression, contextArguments) = try extractUnaryAssertionComponents(
      of: node,
      in: context
    )
    
    return try expansion(
      of: node,
      in: context,
      conditionExpression: conditionExpression.conditionallyWrappedInParentheses(
        shouldWrap: addDefensiveParentheses
      ),
      contextArguments: contextArguments
    ).validatedAndErasedToExprSyntax()
  }

}

