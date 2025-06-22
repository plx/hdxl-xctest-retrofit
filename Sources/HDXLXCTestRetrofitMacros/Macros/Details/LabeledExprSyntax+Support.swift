import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension Collection where Element == LabeledExprSyntax {
  
  package var firstExpressionIfUnlabeled: ExprSyntax? {
    guard
      let firstLabeledExpression = first,
      firstLabeledExpression.label == nil
    else {
      return nil
    }
    
    return firstLabeledExpression.expression
  }
  
  package func firstExpression(withLabel label: String) -> ExprSyntax? {
    for labeledExpr in self {
      if labeledExpr.label?.text == label {
        return labeledExpr.expression
      }
    }
    
    return nil
  }
  
  package func lastExpression(withLabel label: String) -> ExprSyntax? {
    for labeledExpr in self.reversed() {
      if labeledExpr.label?.text == label {
        return labeledExpr.expression
      }
    }
    
    return nil
  }
  
}
