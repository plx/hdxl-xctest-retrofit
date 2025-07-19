# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Swift package that provides macros to help migrate XCTest assertions to Swift Testing. It allows developers to use familiar XCTest syntax (e.g., `#XCTAssertEqual`) which expands to an equivalent expression using Swift Testing's `#expect` macro.

**Current Version**: Preparing for 1.0.0 release
**Repository**: https://github.com/hdxl/hdxl-xctest-retrofit

## Commands

The project uses [just](https://github.com/casey/just) for task automation.

During development you typically want to run `just check`, which builds the package and runs tests.

## Architecture

### Core Components

1. **Macro Declarations** (`Sources/HDXLXCTestRetrofit/`): Public API exposing XCTest-style macros that users import
2. **Macro Implementations** (`Sources/HDXLXCTestRetrofitMacros/`): The actual macro expansion logic
   - `Macros/Concrete/`: Individual macro implementations for each XCTest assertion
   - `Macros/Details/`: Supporting protocols and types for macro expansion
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
- **Usage Tests** (`Tests/HDXLXCTestRetrofitUsageTests/`): Verify macros work correctly in real test scenarios
- Tests are organized by assertion type (binary, unary, tolerance-based) and outcome (success, failure)

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
3. Add corresponding tests in both test suites
4. Update documentation if needed

## CI/CD

- **GitHub Actions**: Tests run on matrix of macOS 14/15 with Xcode 16.0/16.1/16.2
- **Documentation**: Auto-published to GitHub Pages on push to main
- **Badges**: README includes CI status, Swift version, platform support, and SPM compatibility badges

## Known Limitations

- Expected failures feature is not yet implemented
- Only supports platforms with Swift Testing (macOS 15+, iOS 18+, etc.)
- `XCTAssertNoThrow` is not implemented (use Swift Testing's native error handling instead)
