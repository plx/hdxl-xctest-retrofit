import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public protocol XCTBinaryOperatorWithToleranceAssertionMacroProtocol: XCTBinaryAssertionWithToleranceMacroProtocol {
  static var operatorSymbol: String { get }
}

extension XCTBinaryOperatorWithToleranceAssertionMacroProtocol {
  public static func prepareAssertionExpression(
    lhsExpression: ExprSyntax,
    rhsExpression: ExprSyntax,
    toleranceExpression: ExprSyntax
  ) throws -> ExprSyntax {
    "abs(\(lhsExpression) - \(rhsExpression)) \(raw: operatorSymbol) \(toleranceExpression)" as ExprSyntax
  }
}

public enum XCTAssertEqualWithToleranceMacro: XCTBinaryOperatorWithToleranceAssertionMacroProtocol {
  public static let operatorSymbol: String = "<="
  public static func expectedInvocationFunctionName() throws -> String {
    // need to override this b/c these macros don't fit the convention of the others
    "XCTAssertEqual"
  }
}

public enum XCTAssertNotEqualWithToleranceMacro: XCTBinaryOperatorWithToleranceAssertionMacroProtocol {
  public static let operatorSymbol: String = ">"

  public static func expectedInvocationFunctionName() throws -> String {
    // need to override this b/c these macros don't fit the convention of the others
    "XCTAssertNotEqual"
  }
}
