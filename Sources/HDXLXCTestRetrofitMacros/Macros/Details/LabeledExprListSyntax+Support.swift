import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension LabeledExprListSyntax {

  init(
    contextArguments: XCTAssertionContextArguments
  ) {
    self = LabeledExprListSyntax {
      if let messageExpression = contextArguments.messageExpression {
        LabeledExprSyntax(expression: messageExpression)
      }
      if let sourceLocationExpression = contextArguments.sourceLocationExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: sourceLocationExpression
        )
      } else if let fileExpression = contextArguments.fileExpression, let lineExpression = contextArguments.lineExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(file: \(fileExpression), line: \(lineExpression))" as ExprSyntax
        )
      } else if let fileExpression = contextArguments.fileExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(file: \(fileExpression))" as ExprSyntax
        )
      } else if let lineExpression = contextArguments.lineExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(line: \(lineExpression))" as ExprSyntax
        )
      }
    }
  }

  init(
    assertionExpression: ExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) {
    self = LabeledExprListSyntax {
      LabeledExprSyntax(expression: assertionExpression)
      if let messageExpression = contextArguments.messageExpression {
        LabeledExprSyntax(expression: messageExpression)
      }
      if let sourceLocationExpression = contextArguments.sourceLocationExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: sourceLocationExpression
        )
      } else if let fileExpression = contextArguments.fileExpression, let lineExpression = contextArguments.lineExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(file: \(fileExpression), line: \(lineExpression))" as ExprSyntax
        )
      } else if let fileExpression = contextArguments.fileExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(file: \(fileExpression))" as ExprSyntax
        )
      } else if let lineExpression = contextArguments.lineExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(line: \(lineExpression))" as ExprSyntax
        )
      }
    }

  }

  init(
    initialArgument: LabeledExprSyntax,
    contextArguments: XCTAssertionContextArguments
  ) {
    self = LabeledExprListSyntax {
      initialArgument
      
      if let messageExpression = contextArguments.messageExpression {
        LabeledExprSyntax(expression: messageExpression)
      }
      if let sourceLocationExpression = contextArguments.sourceLocationExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: sourceLocationExpression
        )
      } else if let fileExpression = contextArguments.fileExpression, let lineExpression = contextArguments.lineExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(file: \(fileExpression), line: \(lineExpression))" as ExprSyntax
        )
      } else if let fileExpression = contextArguments.fileExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(file: \(fileExpression))" as ExprSyntax
        )
      } else if let lineExpression = contextArguments.lineExpression {
        LabeledExprSyntax(
          label: "sourceLocation",
          expression: "SourceLocation(line: \(lineExpression))" as ExprSyntax
        )
      }
    }
  }

}
