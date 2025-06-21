import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public protocol XCTBinaryOperatorAssertionMacroProtocol : XCTBinaryAssertionMacroProtocol {
  static var operatorSymbol: String { get }
}

extension XCTBinaryOperatorAssertionMacroProtocol {
  public static func prepareAssertionExpression(
    lhsExpression: ExprSyntax,
    rhsExpression: ExprSyntax
  ) throws -> ExprSyntax {
    "\(lhsExpression) \(raw: operatorSymbol) \(rhsExpression)" as ExprSyntax
  }
}

public enum XCTAssertEqualMacro: XCTBinaryOperatorAssertionMacroProtocol {
  public static let operatorSymbol: String = "=="
}

public enum XCTAssertNotEqualMacro: XCTBinaryOperatorAssertionMacroProtocol {
  public static let operatorSymbol: String = "!="
}

public enum XCTAssertIdenticalMacro: XCTBinaryOperatorAssertionMacroProtocol {
  public static let operatorSymbol: String = "==="
}

public enum XCTAssertNotIdenticalMacro: XCTBinaryOperatorAssertionMacroProtocol {
  public static let operatorSymbol: String = "!=="
}

public enum XCTAssertLessThanMacro: XCTBinaryOperatorAssertionMacroProtocol {
  public static let operatorSymbol: String = "<"
}

public enum XCTAssertLessThanOrEqualMacro: XCTBinaryOperatorAssertionMacroProtocol {
  public static let operatorSymbol: String = "<="
}

public enum XCTAssertGreaterThanMacro: XCTBinaryOperatorAssertionMacroProtocol {
  public static let operatorSymbol: String = ">"
}

public enum XCTAssertGreaterThanOrEqualMacro: XCTBinaryOperatorAssertionMacroProtocol {
  public static let operatorSymbol: String = ">="
}
