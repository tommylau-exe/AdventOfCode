//
//  Year2023+Day1.swift
//
//
//  Created by Tom Lauerman on 12/1/23.
//

import Foundation
import RegexBuilder

extension Year2023 {
    enum Day1 {}
}

extension Year2023.Day1 {
    static func part1(input: String) -> Int {
        input
            .split(whereSeparator: \.isNewline)
            .map { $0.compactMap(\.wholeNumberValue) }
            .map { $0.first! * 10 + $0.last! }
            .reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        let digit = ChoiceOf {
            .digit
            "one"
            "two"
            "three"
            "four"
            "five"
            "six"
            "seven"
            "eight"
            "nine"
        }
        
        let firstDigit = TryCapture(digit, transform: DigitParser.int(from:))
        
        let lastDigit = Regex {
            ZeroOrMore(.any)
            TryCapture(digit, transform: DigitParser.int(from:))
        }
        
        return input
            .split(whereSeparator: \.isNewline)
            .map { line in
                let firstDigit = line.firstMatch(of: firstDigit).map(\.output.1)!
                let lastDigit = line.firstMatch(of: lastDigit).map(\.output.1)!
                return firstDigit * 10 + lastDigit
            }
            .reduce(0, +)
    }
}

private struct DigitParser {
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter
    }()
    
    static func int(from digitString: some StringProtocol) -> Int? {
        digitString.first?.wholeNumberValue ?? formatter.number(from: String(digitString))?.intValue
    }
}
