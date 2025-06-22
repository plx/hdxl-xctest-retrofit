import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum XCTFailMacro: XCTAssertionMacroProtocol {
  
  public static let mandatoryArgumentCount: Int = 0
  
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> ExprSyntax {
    try verifyStandardProperties(of: node)
    let contextArguments = try extractContextArguments(of: node)
    
    return try FunctionCallExprSyntax(
      leadingTrivia: node.leadingTrivia,
      calledExpression: "Issue.record" as ExprSyntax,
      leftParen: node.leftParen,
      arguments: LabeledExprListSyntax(
        contextArguments: contextArguments
      ),
      rightParen: node.rightParen,
      trailingClosure: node.trailingClosure,
      additionalTrailingClosures: node.additionalTrailingClosures,
      trailingTrivia: node.trailingTrivia
    ).validatedAndErasedToExprSyntax()
  }

}
