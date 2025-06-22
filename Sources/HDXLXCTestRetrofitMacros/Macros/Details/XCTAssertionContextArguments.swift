import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: XCTAssertionContextArguments

public struct XCTAssertionContextArguments {
  
  public var messageExpression: ExprSyntax?
  public var fileExpression: ExprSyntax?
  public var lineExpression: ExprSyntax?
  public var sourceLocationExpression: ExprSyntax?
  
  package init(
    messageExpression: ExprSyntax?,
    fileExpression: ExprSyntax?,
    lineExpression: ExprSyntax?,
    sourceLocationExpression: ExprSyntax?
  ) {
    self.messageExpression = messageExpression
    self.fileExpression = fileExpression
    self.lineExpression = lineExpression
    self.sourceLocationExpression = sourceLocationExpression
  }
  
}

// MARK: - SwiftSyntax Interop

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
      lineExpression: labeledExprListSyntax.firstExpression(withLabel: "line"),
      sourceLocationExpression: labeledExprListSyntax.lastExpression(withLabel: "sourceLocation")
    )
  }
}
