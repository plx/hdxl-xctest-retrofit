import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum XCTAssertNoThrowMacro: XCTAssertionMacroProtocol {
  
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
    
    // Build the arguments for Issue.record
    let issueRecordArgs: LabeledExprListSyntax
    if let messageExpression = contextArguments.messageExpression,
       let sourceLocationExpression = contextArguments.sourceLocationExpression {
      // With custom message and source location
      issueRecordArgs = LabeledExprListSyntax {
        LabeledExprSyntax(
          expression: ExprSyntax("\"Unexpected error thrown: \\(error) - \\(\(messageExpression))\"")
        )
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: sourceLocationExpression
        )
      }
    } else if let messageExpression = contextArguments.messageExpression {
      // With custom message but no explicit source location
      issueRecordArgs = LabeledExprListSyntax {
        LabeledExprSyntax(
          expression: ExprSyntax("\"Unexpected error thrown: \\(error) - \\(\(messageExpression))\"")
        )
      }
    } else if let sourceLocationExpression = contextArguments.sourceLocationExpression {
      // No custom message but explicit source location
      issueRecordArgs = LabeledExprListSyntax {
        LabeledExprSyntax(
          expression: ExprSyntax(stringLiteral: "\"Unexpected error thrown: \\(error)\"")
        )
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: sourceLocationExpression
        )
      }
    } else {
      // Default: no custom message, no explicit source location
      issueRecordArgs = LabeledExprListSyntax {
        LabeledExprSyntax(
          expression: ExprSyntax(stringLiteral: "\"Unexpected error thrown: \\(error)\"")
        )
      }
    }
    
    // Build the do-catch block that returns the value or records an issue
    return ExprSyntax("""
    try {
      do {
        return try \(expression.conditionallyWrappedInParentheses(shouldWrap: true))
      } catch {
        Issue.record(\(issueRecordArgs))
        throw error
      }
    }()
    """)
  }
  
}