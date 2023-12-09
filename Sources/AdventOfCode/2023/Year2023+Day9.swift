//
//  Year2023+Day9.swift
//
//
//  Created by Tom Lauerman on 12/8/23.
//

import Foundation

extension Year2023 {
    enum Day9 {}
}

extension Year2023.Day9 {
    static func part1(input: String) -> Int {
        let sequences = input.split(whereSeparator: \.isNewline)
            .map { line in line.split(whereSeparator: \.isWhitespace).map { Int($0)! } }
        
        return sequences.map(deriveNextValue(in:)).reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        let sequences = input.split(whereSeparator: \.isNewline)
            .map { line in line.split(whereSeparator: \.isWhitespace).map { Int($0)! } }
        
        return sequences.map(derivePreviousValue(in:)).reduce(0, +)
    }
}

private func deriveNextValue(in sequence: [Int]) -> Int {
    guard !sequence.allSatisfy({ $0 == 0 }) else {
        return 0
    }
    
    let deltas = sequence.windows(ofCount: 2).map { $0.last! - $0.first! }
    return sequence.last! + deriveNextValue(in: deltas)
}

private func derivePreviousValue(in sequence: [Int]) -> Int {
    guard !sequence.allSatisfy({ $0 == 0 }) else {
        return 0
    }
    
    let deltas = sequence.windows(ofCount: 2).map { $0.last! - $0.first! }
    return sequence.first! - derivePreviousValue(in: deltas)
}
