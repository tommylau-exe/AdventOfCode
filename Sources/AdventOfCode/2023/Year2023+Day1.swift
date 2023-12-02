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
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
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
        
        let firstDigit = TryCapture(digit, transform: integer(from:))
        
        let lastDigit = Regex {
            ZeroOrMore(.any)
            TryCapture(digit, transform: integer(from:))
        }
        
        func integer(from digitString: some StringProtocol) -> Int? {
            if digitString.count == 1 {
                return digitString.first?.wholeNumberValue
            } else {
                let formatter = NumberFormatter()
                formatter.numberStyle = .spellOut
                
                return formatter.number(from: String(digitString))?.intValue
            }
        }
        
        return input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(whereSeparator: \.isWhitespace)
            .map { line in
                let firstDigit = line.firstMatch(of: firstDigit).map(\.output.1)!
                let lastDigit = line.firstMatch(of: lastDigit).map(\.output.1)!
                
                return (firstDigit, lastDigit)
            }
            .map { firstDigit, lastDigit in
                firstDigit * 10 + lastDigit
            }
            .reduce(0, +)
    }
}
