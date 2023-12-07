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
        let handComparator = HandComparator(
            cardRankingStrategy: Part1.ranking,
            handKindStrategy: Part1.kind
        )
        
        return input.matches(of: bidPattern)
            .map(\.output)
            .map { Bid(hand: Hand(cards: Array($1)), amount: $2) }
            .sorted { handComparator.isStrongerThan($0.hand, $1.hand) }
            .reversed()
            .enumerated()
            .map { ($0+1, $1) }
            .map { $0 * $1.amount }
            .reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        let bidPattern = Regex {
            Capture(OneOrMore(.word))
            " "
            Capture(OneOrMore(.digit)) { Int($0)! }
        }
        let handComparator = HandComparator(
            cardRankingStrategy: Part2.ranking,
            handKindStrategy: Part2.kind
        )
        
        return input.matches(of: bidPattern)
            .map(\.output)
            .map { Bid(hand: Hand(cards: Array($1)), amount: $2) }
            .sorted { handComparator.isStrongerThan($0.hand, $1.hand) }
            .reversed()
            .enumerated()
            .map { ($0+1, $1) }
            .map { $0 * $1.amount }
            .reduce(0, +)
    }
}

private typealias Card = Character
private typealias CardRankingStrategy = (Card) -> Int
private typealias HandKindStrategy = (Hand) -> Hand.Kind

private struct Hand {
    let cards: [Card]
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

private struct Bid {
    let hand: Hand
    let amount: Int
}

private struct HandComparator {
    let cardRankingStrategy: CardRankingStrategy
    let handKindStrategy: HandKindStrategy
    
    func isStrongerThan(_ lhs: Hand, _ rhs: Hand) -> Bool {
        let kind = handKindStrategy(lhs)
        let otherKind = handKindStrategy(rhs)
        
        guard kind == otherKind else {
            return kind.isStrongerThan(otherKind)
        }
        
        for (card, otherCard) in zip(lhs.cards, rhs.cards) {
            guard card != otherCard else { continue }
            
            let firstCardIsStronger = cardRankingStrategy(card) < cardRankingStrategy(otherCard)
            return firstCardIsStronger
        }
        
        return false
    }
}

private enum Part1 {
    private static let cardRankings: [Card: Int] = Dictionary(
        "AKQJT98765432".enumerated().map { ($1, $0) },
        uniquingKeysWith: { first, _ in first }
    )
    
    static func ranking(for card: Card) -> Int {
        cardRankings[card]!
    }
    
    static func kind(for hand: Hand) -> Hand.Kind {
        let cardCounts = hand.cards.grouped(by: { $0 }).values.map(\.count)
        
        return switch (cardCounts.count) {
        case 1:
            .fiveOfAKind
        case 2 where cardCounts.contains(4):
            .fourOfAKind
        case 2:
            .fullHouse
        case 3 where cardCounts.contains(3):
            .threeOfAKind
        case 3:
            .twoPair
        case 4:
            .onePair
        default:
            .highCard
        }
    }
}

private enum Part2 {
    private static let cardRankings: [Card: Int] = Dictionary(
        "AKQT98765432J".enumerated().map { ($1, $0) },
        uniquingKeysWith: { first, _ in first }
    )
    
    static func ranking(for card: Card) -> Int {
        cardRankings[card]!
    }
    
    static func kind(for hand: Hand) -> Hand.Kind {
        guard hand.cards.contains(where: { $0 == "J" }) else {
            return Part1.kind(for: hand)
        }
        
        let cardCounts = hand.cards
            .filter { $0 != "J" }
            .grouped(by: { $0 })
            .values
            .map(\.count)
        
        return switch cardCounts.count {
        case 0, 1:
            .fiveOfAKind
        case 2 where cardCounts.allSatisfy({ $0 == 2}):
            .fullHouse
        case 2:
            .fourOfAKind
        case 3:
            .threeOfAKind
        default:
            .onePair
        }
    }
}
