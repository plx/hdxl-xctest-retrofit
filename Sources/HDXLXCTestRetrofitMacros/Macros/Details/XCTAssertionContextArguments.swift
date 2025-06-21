import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct XCTAssertionContextArguments {
  
  public var messageExpression: ExprSyntax?
  public var fileExpression: ExprSyntax?
  public var lineExpression: ExprSyntax?
  
  package init(messageExpression: ExprSyntax?, fileExpression: ExprSyntax?, lineExpression: ExprSyntax?) {
    self.messageExpression = messageExpression
    self.fileExpression = fileExpression
    self.lineExpression = lineExpression
  }
  
}

extension XCTAssertionContextArguments {
  
  package init?(
    labeledExprListSyntax: LabeledExprListSyntax,
    mandatoryArgumentCount: Int
  ) {
    guard labeledExprListSyntax.count >= mandatoryArgumentCount else {
      return nil
    }
    
    self.init(
      messageExpression: labeledExprListSyntax[labeledExprListSyntax.index(labeledExprListSyntax.startIndex, offsetBy: mandatoryArgumentCount)...].firstExpressionIfUnlabeled,
      fileExpression: labeledExprListSyntax.firstExpression(withLabel: "file"),
      lineExpression: labeledExprListSyntax.firstExpression(withLabel: "line")
    )
  }
}

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
  
}
