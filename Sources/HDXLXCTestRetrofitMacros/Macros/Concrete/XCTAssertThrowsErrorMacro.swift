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
    
    let possibleErrorHandler = node.finalClosureIfPresent
        
    // Build the arguments list
    let expectArgs = LabeledExprListSyntax(
      initialArgument: LabeledExprSyntax(
        label: "throws",
        expression: "(any Error).self" as ExprSyntax
      ),
      contextArguments: contextArguments
    )
    
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
    
    let thrownError = context.makeUniqueName("thrownError")
    
    switch possibleErrorHandler?.closureExpression {
    case .some(let errorHandler):
      return
        """
        {
          let \(thrownError) = \(expectCall)
          if let \(thrownError) {
            \(errorHandler)(\(thrownError))
          }
          
          return \(thrownError)
        }()
        """
    case .none:
      return
        """
        \(expectCall)
        """
    }
  }
  
}

enum FinalClosure {
  case trailing(ClosureExprSyntax)
  case argument(ClosureExprSyntax)
  
  var isArgument: Bool {
    switch self {
    case .trailing: false
    case .argument: true
    }
  }
  
  var closureExpression: ClosureExprSyntax? {
    switch self {
    case .trailing(let closureExprSyntax):
      closureExprSyntax
    case .argument(let closureExprSyntax):
      closureExprSyntax
    }
  }
}

extension FreestandingMacroExpansionSyntax {
  
  
  var finalClosureIfPresent: FinalClosure? {
    if let trailingClosure {
      .trailing(trailingClosure)
    } else if let lastArgument = arguments.last, lastArgument.label == nil, let closureExpression = lastArgument.expression.as(ClosureExprSyntax.self) {
      .argument(closureExpression)
    } else {
      nil
    }
  }
  
}
