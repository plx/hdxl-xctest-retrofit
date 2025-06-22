// MARK: XCTAssertionMacroError

public enum XCTAssertionMacroError: Error, CustomStringConvertible {
  
  case unableToInferXCTAssertionName(String)
  case unexpectedXCTAssertionName(String, String)
  case insufficientArgumentCount(String, Int, Int)
  case unableToExtractContextArguments(String)
  
  public var description: String {
    switch self {
    case .unableToInferXCTAssertionName(let macroName):
      """
      Unable to infer an XCT assertion name from `\(macroName)`!
      """
    case .unexpectedXCTAssertionName(let expected, let observed):
      """
      Expected assertion-name `\(expected)` but encountered `\(observed)` instead!
      """
    case .insufficientArgumentCount(let macroName, let minimum, let observed):
      """
      `\(macroName)` needs at-least \(minimum) arguments, but only saw `\(observed)`, instead!
      """
    case .unableToExtractContextArguments(let macroName):
      """
      `\(macroName)` failed to extract usable context arguments!
      """
    }
  }
  
}
