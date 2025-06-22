import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum XCTAssertMacro: XCTUnaryAssertionMacroProtocol {
  public static func prepareAssertionExpression(conditionExpression: ExprSyntax) throws -> ExprSyntax {
    "Bool(\(conditionExpression))"
  }
}

public enum XCTAssertTrueMacro: XCTUnaryAssertionMacroProtocol {
  public static func prepareAssertionExpression(conditionExpression: ExprSyntax) throws -> ExprSyntax {
    "Bool(\(conditionExpression))" as ExprSyntax
  }
}

public enum XCTAssertFalseMacro: XCTUnaryAssertionMacroProtocol {
  public static func prepareAssertionExpression(conditionExpression: ExprSyntax) throws -> ExprSyntax {
    "Bool(!\(conditionExpression))" as ExprSyntax
  }
}

public enum XCTAssertNotNilMacro: XCTUnaryAssertionMacroProtocol {
  public static let addDefensiveParentheses = true
  public static func prepareAssertionExpression(conditionExpression: ExprSyntax) throws -> ExprSyntax {
    "\(conditionExpression) != nil" as ExprSyntax
  }
}

public enum XCTAssertNilMacro: XCTUnaryAssertionMacroProtocol {
  public static let addDefensiveParentheses = true
  
  public static func prepareAssertionExpression(conditionExpression: ExprSyntax) throws -> ExprSyntax {
    "\(conditionExpression) == nil" as ExprSyntax
  }
}

public enum XCTUnwrapMacro: XCTUnaryAssertionMacroProtocol {
  public static let rewrittenInvocationName: String = "require"
  
  public static func prepareAssertionExpression(conditionExpression: ExprSyntax) throws -> ExprSyntax {
    conditionExpression
  }
}

