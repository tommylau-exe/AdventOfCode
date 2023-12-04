//
//  Year2023+Day4.swift
//
//
//  Created by Tom Lauerman on 12/3/23.
//

import Algorithms
import Foundation
import RegexBuilder

extension Year2023 {
    enum Day4 {}
}

extension Year2023.Day4 {
    static func part1(input: String) -> Int {
        Cards.from(input)
            .map(\.points)
            .reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        let cards = Cards.from(input)
        var cardCounts = Array(repeating: 1, count: cards.count)
        
        for (cardNumber, card) in cards.enumerated() {
            let copiesToMake = card.matches
            guard copiesToMake > 0 else { continue }
            
            for copyNumber in 1...copiesToMake {
                cardCounts[cardNumber + copyNumber] += cardCounts[cardNumber]
            }
        }
        
        return cardCounts.reduce(0, +)
    }
}

private struct Card {
    var id: Int
    var winningNumbers: Set<Int>
    var numbers: [Int]
    
    var matches: Int {
        winningNumbers.intersection(numbers).count
    }
    
    var points: Int {
        guard matches > 0 else { return 0 }
        return Int(pow(2, Double(matches - 1)))
    }
}

private enum Cards {
    static func from(_ input: String) -> [Card] {
        let cardPattern = Regex {
            "Card"
            
            OneOrMore(.whitespace)
            
            Capture(OneOrMore(.digit)) { Int($0)! }
            
            ": "
            
            Capture {
                OneOrMore {
                    ZeroOrMore(.whitespace)
                    
                    OneOrMore(.digit)
                }
            } transform: { $0.split(whereSeparator: \.isWhitespace).map { Int($0)! } }
            
            " | "
            
            Capture {
                OneOrMore {
                    ZeroOrMore(.whitespace)
                    
                    OneOrMore(.digit)
                }
            } transform: { $0.split(whereSeparator: \.isWhitespace).map { Int($0)! } }
        }
        
        return input.matches(of: cardPattern)
            .map(\.output)
            .map { Card(id: $1, winningNumbers: Set($2), numbers: $3) }
    }
}
