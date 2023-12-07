//
//  Year2023+Day7.swift
//
//
//  Created by Tom Lauerman on 12/6/23.
//

import Foundation
import RegexBuilder

extension Year2023 {
    enum Day7 {}
}

extension Year2023.Day7 {
    static func part1(input: String) -> Int {
        let bidPattern = Regex {
            Capture(OneOrMore(.word))
            " "
            Capture(OneOrMore(.digit)) { Int($0)! }
        }
        
        return input.matches(of: bidPattern)
            .map(\.output)
            .map { Hand(cards: Array($1), bid: $2) }
            .sorted { $0.isStrongerThan($1) }
            .reversed()
            .enumerated()
            .map { ($0+1, $1) }
            .map { $0 * $1.bid }
            .reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        fatalError()
    }
}

private typealias Card = Character

private let cardRankings: [Card: Int] = Dictionary(
    "AKQJT98765432".enumerated().map { ($1, $0) },
    uniquingKeysWith: { first, _ in first }
)

private extension Card {
    func isStrongerThan(_ other: Self) -> Bool {
        cardRankings[self]! < cardRankings[other]!
    }
}

private struct Hand {
    let cards: [Card]
    let bid: Int
    
    var kind: Kind {
        let cardCounts: [Card: Int] = cards.reduce(into: [:]) { $0[$1] = ($0[$1] ?? 0) + 1 }
        
        if cardCounts.count == 1 {
            return .fiveOfAKind
        }
        
        if cardCounts.count == 2 && cardCounts.values.contains(where: { $0 == 4 }) {
            return .fourOfAKind
        }
        
        if cardCounts.count == 2 {
            return .fullHouse
        }
        
        if cardCounts.count == 3 && cardCounts.values.contains(where: { $0 == 3 }) {
            return .threeOfAKind
        }
        
        if cardCounts.count == 3 {
            return .twoPair
        }
        
        if cardCounts.count == 4 {
            return .onePair
        }
        
        return .highCard
    }
    
    func isStrongerThan(_ other: Self) -> Bool {
        let kind = kind
        let otherKind = other.kind
        
        guard kind == otherKind else {
            return kind.isStrongerThan(otherKind)
        }
        
        for (card, otherCard) in zip(cards, other.cards) {
            guard card != otherCard else { continue }
            return card.isStrongerThan(otherCard)
        }
        
        return false
    }
}

private extension Hand {
    enum Kind: Int {
        case fiveOfAKind
        case fourOfAKind
        case fullHouse
        case threeOfAKind
        case twoPair
        case onePair
        case highCard
        
        func isStrongerThan(_ other: Self) -> Bool {
            rawValue < other.rawValue
        }
    }
}
