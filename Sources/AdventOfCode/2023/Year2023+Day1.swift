//
//  Day1.swift
//
//
//  Created by Tom Lauerman on 12/1/23.
//

import Foundation

extension Year2023 {
    enum Day1 {}
}

extension Year2023.Day1 {
    static func part1(input: String) -> Int {
        input
            .components(separatedBy: .newlines)
            .map { $0.compactMap(\.wholeNumberValue) }
            .map { $0.first! + $0.last! }
            .reduce(0, +)
    }
}
