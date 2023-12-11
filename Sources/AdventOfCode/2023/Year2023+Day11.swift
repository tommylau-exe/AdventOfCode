//
//  Year2023+Day11.swift
//
//
//  Created by Tom Lauerman on 12/10/23.
//

import Foundation

extension Year2023 {
    enum Day11 {}
}

extension Year2023.Day11 {
    static func part1(input: String) -> Int {
        let universe = Universe(content: input.split(whereSeparator: \.isNewline).map(Array.init)).expanded()
        let galaxies = universe.galaxies
        
        return galaxies.combinations(ofCount: 2)
            .map { ($0.first!, $0.last!) }
            .map { $0.distance(to: $1) }
            .reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        let universe = Universe(content: input.split(whereSeparator: \.isNewline).map(Array.init)).expanded()
        let galaxies = universe.galaxies
        
        return galaxies.combinations(ofCount: 2)
            .map { ($0.first!, $0.last!) }
            .map { $0.distance(to: $1) }
            .reduce(0, +)
    }
}

private struct Universe {
    let content: [[Character]]
    
    var galaxies: [Point] {
        var points: [Point] = []
        for x in content.first!.indices {
            for y in content.indices where content[y][x] == "#" {
                points.append(Point(x: x, y: y))
            }
        }
        
        return points
    }
    
    func expanded() -> Universe {
        var newContent = content
        
        for (rowNumber, row) in newContent.enumerated().reversed() where row.allSatisfy({ $0 == "." }) {
            // Insert duplicate row (empty row) at the same index
            newContent.insert(row, at: rowNumber)
        }
        
        for columnNumber in newContent.first!.indices.reversed() {
            let column = newContent.map { $0[columnNumber] }
            guard column.allSatisfy({ $0 == "." }) else { continue }
            
            for rowNumber in newContent.indices {
                newContent[rowNumber].insert(".", at: columnNumber)
            }
        }
        
        return Universe(content: newContent)
    }
}

private struct Point: Hashable {
    let x: Int
    let y: Int
    
    func distance(to other: Point) -> Int {
        abs(x - other.x) + abs(y - other.y)
    }
}
