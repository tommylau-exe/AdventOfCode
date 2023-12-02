//
//  Day1.swift
//
//
//  Created by Tom Lauerman on 11/29/23.
//

extension Year2022 {
    enum Day1 {}
}

extension Year2022.Day1 {
    static func part1(input: String) -> Int {
        input
            .components(separatedBy: "\n\n")
            .map { $0.split(whereSeparator: \.isNewline).compactMap { Int($0) }.reduce(0, +) }
            .max() ?? 0
    }
    
    static func part2(input: String) -> Int {
        input
            .components(separatedBy: "\n\n")
            .map { $0.split(whereSeparator: \.isNewline).compactMap { Int($0) }.reduce(0, +) }
            .sorted(by: >)
            .prefix(3)
            .reduce(0, +)
    }
}
