# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Swift package that provides macros to help migrate XCTest assertions to Swift Testing. It allows developers to use familiar XCTest syntax (e.g., `#XCTAssertEqual`) which expands to an equivalent expression using Swift Testing's `#expect` macro.

**Current Version**: Preparing for 1.0.0 release
**Repository**: https://github.com/hdxl/hdxl-xctest-retrofit

## Commands

The project uses [just](https://github.com/casey/just) for task automation.

During development you typically want to run `just check`, which builds the package and runs tests. Run this frequently during macro development as Swift's error messages for macro expansion issues can be cryptic.

## Architecture

### Core Components

1. **Macro Declarations** (`Sources/HDXLXCTestRetrofit/`): Public API exposing XCTest-style macros that users import
   - this is the primary surface area for users of this package
   - *only* contains declarations (no implementation—this declaration/implementation split is inherent to Swift macros)
   - contains two parallel sets of macro declarations: 
       - `RetrofitMacros.swift`: Primary declarations exactly matching original `XCTest` assertion signatures (e.g. taking `file` and `line` parameters for attribution)
       - `RetrofitMacrosWithSourceLocation.swift`: Additional, analogous declarations, but replacing `file` and `line` parameters with `sourceLocation`
2. **Macro Implementations** (`Sources/HDXLXCTestRetrofitMacros/`): The actual macro expansion logic
   - `Macros/Concrete/`: Individual macro implementations for each XCTest assertion
   - `Macros/Details/`: Supporting protocols and types for macro expansion
3. **Macro Client**
   - a bare-bones executable target (`HDXLXCTestRetrofitClient`) that imports the package
   - not part of public API—just used for manual testing during development
3. **Documentation** (`Sources/HDXLXCTestRetrofit/HDXLXCTestRetrofit.docc/`): Swift-DocC documentation
   - Main landing page with API groupings
   - Getting started guide
   - Migration guides for tests and validation functions

### Key Design Patterns

- **Protocol-Based Architecture**: All macros conform to `RetrofitMacro` protocol for consistent behavior
- **Source Location Handling**: Separate macro variants with and without explicit source location parameters
- **Error Propagation**: Macros transform XCTest boolean assertions into Swift Testing's throwing expectations

### Testing Strategy

- **Implementation Tests** (`Tests/HDXLXCTestRetrofitTests/`): Verify macro expansion produces correct syntax
  - Use `assertTrimmedMacroExpansion` helper to test exact macro output
  - Test all parameter combinations: basic, with message, with source location
- **Usage Tests** (`Tests/HDXLXCTestRetrofitUsageTests/`): Verify macros work correctly in real test scenarios
  - Separate files for success and failure cases
  - Uses `withKnownIssue` blocks for expected failures (e.g. to check `#XCTAssertTrue(false)` fails the test)
- Tests are organized by assertion type (binary, unary, tolerance-based, throwing) and outcome (success, failure)

## Code Style

- **Indentation**: 2 spaces (configured in `.swift-format`)
- **Line Length**: 100 characters max
- **SwiftLint**: Extensive rules enabled including many opt-in rules
- Run `just format` before committing to ensure consistent formatting (Note: formatting requires swift-format to be installed)

## Documentation Guidelines

- **Focus**: Keep documentation focused on the library itself, not general testing concepts
- **Migration-Oriented**: Documentation assumes users already have XCTest code they want to migrate
- **Practical Examples**: Provide real-world examples showing before/after migration
- **DocC Structure**: Use proper topic groups and disambiguations for overloaded methods

## Adding New Macros

1. Add macro declaration in `Sources/HDXLXCTestRetrofit/RetrofitMacros.swift`
2. Implement macro in `Sources/HDXLXCTestRetrofitMacros/Macros/Concrete/`
3. Register the macro in `Sources/HDXLXCTestRetrofitMacros/Plugin.swift`
4. Add implementation tests in `Tests/HDXLXCTestRetrofitTests/`
5. Add usage tests in `Tests/HDXLXCTestRetrofitUsageTests/` (both success and failure cases)
6. Update documentation in `HDXLXCTestRetrofit.docc/HDXLXCTestRetrofit.md`

## CI/CD

- **GitHub Actions**: Tests run on matrix of macOS 14/15 with Xcode 16.0/16.1/16.2
- **Documentation**: Auto-published to GitHub Pages on push to main
- **Badges**: README includes CI status, Swift version, platform support, and SPM compatibility badges

## Macro Implementation Guidelines

### Working with String Interpolation in Macros
- When building messages with string interpolation in macro expansions, be careful with operator precedence
- Direct string concatenation (`+`) can cause issues with Swift's type system
- For simple cases, use string interpolation: `"Error: \\(value)"`
- For conditional messages, consider using the full conditional within the interpolation

### Handling Throwing Expressions
- Be mindful of `try` expression placement in macro expansions
- The macro's autoclosure parameter already handles `throws`, so don't double-wrap with `try`
- When the macro itself needs to throw, wrap the entire expansion in `try { ... }()`

### Testing Patterns
- Always test both success and failure paths
- Use `withKnownIssue` for expected failures in test suites
- For macros that return values (like `XCTAssertNoThrow`), ensure tests verify the return value
- Test with various expression types: simple function calls, closures, complex expressions

### Following Existing Patterns
- Study similar macros before implementing (e.g., `XCTAssertThrowsError` for `XCTAssertNoThrow`)
- Use `XCTAssertionContextArguments` for consistent source location handling
- Follow the established pattern for `LabeledExprListSyntax` construction
- Ensure proper use of `conditionallyWrappedInParentheses` for complex expressions

## Known Limitations

- Some `XCTest` features aren't supported (issue recording, asynchronous expectations, expected failures, test-skipping, etc.)
- Only supports platforms with Swift Testing (macOS 15+, iOS 18+, etc.)
