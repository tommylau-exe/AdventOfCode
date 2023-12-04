//
//  Year2023+Day3.swift
//
//
//  Created by Tom Lauerman on 12/2/23.
//

import Algorithms
import Foundation
import RegexBuilder

extension Year2023 {
    enum Day3 {}
}

extension Year2023.Day3 {
    static func part1(input: String) -> Int {
        let schematic = input.split(whereSeparator: \.isNewline)
        
        return schematic.partNumbers()
            .filter { partNumber in
                partNumber.location.neighbors(in: schematic)
                    .map(schematic.character(at:))
                    .contains { $0 != "." }
            }
            .map(\.value)
            .reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        let schematic = input.split(whereSeparator: \.isNewline)
        let partNumberAt = Dictionary<Location, PartNumber>(
            schematic.partNumbers()
                .flatMap { partNumber in
                    partNumber.location.discreteLocations
                        .map { location in (location, partNumber) }
                },
            uniquingKeysWith: { first, _ in first }
        )
        
        let gears = schematic.enumerated()
            .flatMap { row, line in
                line.matches(of: "*")
                    .map { match in line.distance(from: line.startIndex, to: match.startIndex) }
                    .map { column in Location(row: row, column: column) }
            }
        
        let gearRatios = gears
            .map { gear in gear.neighbors(in: schematic) }
            .map { neighbors in neighbors.compactMap { partNumberAt[$0] } }
            .map { partNumbers in Array(partNumbers.uniqued()) }
            .filter { partNumbers in partNumbers.count > 1 }
            .map { partNumbers in partNumbers.map(\.value).reduce(1, *) }
        
        return gearRatios.reduce(0, +)
    }
}

private typealias Schematic = [Substring]

private extension Schematic {
    func partNumbers() -> [PartNumber] {
        enumerated()
            .flatMap { row, line in
                line.matches(of: OneOrMore(.digit))
                    .map { match in
                        let firstColumn = line.distance(from: line.startIndex, to: match.startIndex)
                        let lastColumn = line.distance(from: line.startIndex, to: match.endIndex)
                        
                        return PartNumber(
                            value: Int(match.output)!,
                            location: PartNumber.Location(
                                row: row,
                                columns: firstColumn..<lastColumn
                            )
                        )
                    }
            }
    }
    
    func character(at location: Location) -> Character {
        let line = self[location.row]
        let index = line.index(line.startIndex, offsetBy: location.column)
        return line[index]
    }
}

private struct PartNumber: Hashable {
    var value: Int
    var location: Location
    
    struct Location: Hashable {
        var row: Int
        var columns: Range<Int>
    }
}

private extension PartNumber.Location {
    var discreteLocations: [Location] {
        columns.map { Location(row: row, column: $0) }
    }
    
    func neighbors(in schematic: Schematic) -> [Location] {
        var neighbors = Set(discreteLocations.flatMap { $0.neighbors(in: schematic) })
        neighbors.subtract(discreteLocations)
        return Array(neighbors)
    }
}

private struct Location: Hashable {
    var row: Int
    var column: Int
    
    func isWithinBounds(of schematic: Schematic) -> Bool {
        row >= 0 && row < schematic.count && column >= 0 && column < schematic.first!.count
    }
    
    func neighbors(in schematic: Schematic) -> [Location] {
        product(-1...1, -1...1)
            .filter { $0 != 0 || $1 != 0 }
            .map { Location(row: $0 + row, column: $1 + column) }
            .filter { location in location.isWithinBounds(of: schematic) }
    }
}
