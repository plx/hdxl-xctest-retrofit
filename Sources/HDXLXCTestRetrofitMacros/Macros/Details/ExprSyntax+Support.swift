import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension ExprSyntax {
  
  func conditionallyWrappedInParentheses(shouldWrap: Bool) -> ExprSyntax {
    guard shouldWrap else {
      return self
    }
    
    return "(\(self))"
  }
  
}
