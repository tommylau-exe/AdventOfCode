//
//  Day2.swift
//
//
//  Created by Tom Lauerman on 11/30/23.
//

import Foundation

extension Year2022 {
    enum Day2 {}
}

extension Year2022.Day2 {
    static func part1(input: String) -> Int {
        input
            .components(separatedBy: .newlines)
            .compactMap { Round(from: $0, parser: .part1) }
            .map(\.points)
            .reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        input
            .components(separatedBy: .newlines)
            .compactMap { Round(from: $0, parser: .part2) }
            .map(\.points)
            .reduce(0, +)
    }
}

// MARK: - Round
private struct Round {
    let opponent: RockPaperScissors
    let player: RockPaperScissors
    
    var points: Int {
        player.points + player.outcome(against: opponent).points
    }
}

private extension Round {
    init?(from string: String, parser: Parser) {
        let players = string.components(separatedBy: .whitespaces)
        
        guard
            let opponent = players.first,
            let player = players.last,
            let round = parser.parse(opponent, player)
        else {
            return nil
        }
        
        self = round
    }
}

// MARK: - RockPaperScissors
private enum RockPaperScissors: Int {
    case rock = 1
    case paper = 2
    case scissors = 3
    
    var points: Int {
        rawValue
    }
    
    var weakness: Self {
        switch self {
        case .rock:
            .paper
        case .paper:
            .scissors
        case .scissors:
            .rock
        }
    }
    
    var resistance: Self {
        switch self {
        case .rock:
            .scissors
        case .paper:
            .rock
        case .scissors:
            .paper
        }
    }
    
    func outcome(against other: Self) -> Outcome {
        switch other {
        case weakness:
            .lose
        case self:
            .tie
        default:
            .win
        }
    }
}

// MARK: - Outcome
private enum Outcome: Int {
    case win = 6
    case tie = 3
    case lose = 0
    
    var points: Int {
        rawValue
    }
}

// MARK: - Round.Parser
private extension Round {
    struct Parser {
        let parse: (String, String) -> Round?
    }
}

private extension Round.Parser {
    static let part1 = Round.Parser { opponent, player in
        func parse(from string: String) -> RockPaperScissors? {
            switch string {
            case "A", "X":
                .rock
            case "B", "Y":
                .paper
            case "C", "Z":
                .scissors
            default:
                nil
            }
        }
        
        guard let opponent = parse(from: opponent), let player = parse(from: player) else {
            return nil
        }
        
        return Round(opponent: opponent, player: player)
    }
}

private extension Round.Parser {
    static let part2 = Round.Parser { opponent, player in
        let opponent: RockPaperScissors? = switch opponent {
        case "A":
            .rock
        case "B":
            .paper
        case "C":
            .scissors
        default:
            nil
        }
        
        guard let opponent else {
            return nil
        }
        
        let player: RockPaperScissors? = switch player {
        case "X":
            opponent.resistance
        case "Y":
            opponent
        case "Z":
            opponent.weakness
        default:
            nil
        }
        
        guard let player else {
            return nil
        }
        
        return Round(opponent: opponent, player: player)
    }
}
