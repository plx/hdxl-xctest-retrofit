import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension ExprSyntaxProtocol {
  
  package func validatedAndErasedToExprSyntax() throws -> ExprSyntax {
    try ExprSyntax(validating: ExprSyntax(self))
  }
  
}
