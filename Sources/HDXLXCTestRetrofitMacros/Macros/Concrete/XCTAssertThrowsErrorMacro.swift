import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum XCTAssertThrowsErrorMacro: XCTAssertionMacroProtocol {
  
  public static let mandatoryArgumentCount: Int = 1
  
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> ExprSyntax {
    try verifyStandardProperties(of: node)
    let contextArguments = try extractContextArguments(of: node)
    
    guard let expression = node.arguments.first?.expression else {
      throw XCTAssertionMacroError.unableToExtractContextArguments(String(reflecting: self))
    }
    
    // Extract the error handler if present
    // The error handler would be the last argument if it's a closure without a label
    let errorHandler: ClosureExprSyntax? = node.trailingClosure ?? node.arguments.reversed().first(where: { arg in
      arg.label == nil && arg.expression.is(ClosureExprSyntax.self)
    })?.expression.as(ClosureExprSyntax.self)
    
    // Build the Swift Testing equivalent
    if let errorHandler {
      // When we have an error handler, we need to use a do-catch block
      // Create new context arguments with our custom message
      let issueContextArgs = XCTAssertionContextArguments(
        messageExpression: contextArguments.messageExpression ?? ExprSyntax(stringLiteral: "\"Expected an error to be thrown\""),
        fileExpression: contextArguments.fileExpression,
        lineExpression: contextArguments.lineExpression,
        sourceLocationExpression: contextArguments.sourceLocationExpression
      )
      let issueRecordArgs = LabeledExprListSyntax(contextArguments: issueContextArgs)
      
      return ExprSyntax("""
      {
        do {
          _ = \(expression.conditionallyWrappedInParentheses(shouldWrap: true))
          Issue.record(\(issueRecordArgs))
        } catch {
          (\(errorHandler))(error)
        }
      }()
      """)
    } else {
      // Without an error handler, we can use #expect with throws
      let contextArgs = LabeledExprListSyntax(contextArguments: contextArguments)
      
      // Build the arguments list
      let expectArgs: LabeledExprListSyntax = LabeledExprListSyntax {
        LabeledExprSyntax(
          label: "throws",
          expression: "(any Error).self" as ExprSyntax
        )
        for arg in contextArgs {
          arg
        }
      }
      
      // Build the #expect macro call with proper syntax
      let expectCall = MacroExpansionExprSyntax(
        leadingTrivia: node.leadingTrivia,
        macroName: "expect" as TokenSyntax,
        leftParen: .leftParenToken(),
        arguments: expectArgs,
        rightParen: .rightParenToken(),
        trailingClosure: ClosureExprSyntax(
          statements: CodeBlockItemListSyntax {
            CodeBlockItemSyntax(
              item: .expr(expression.conditionallyWrappedInParentheses(shouldWrap: true))
            )
          }
        ),
        trailingTrivia: node.trailingTrivia
      )
      
      // Wrap in a statement that discards the return value
      return try SequenceExprSyntax {
        DiscardAssignmentExprSyntax()
        AssignmentExprSyntax(equal: .equalToken(leadingTrivia: .space, trailingTrivia: .space))
        expectCall
      }.validatedAndErasedToExprSyntax()
    }
  }
  
}