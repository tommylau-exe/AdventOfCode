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
        let universe = Universe(content: input.split(whereSeparator: \.isNewline).map(Array.init))
        
        return universe.galaxies(withScaleFactor: 2)
            .combinations(ofCount: 2)
            .map { ($0.first!, $0.last!) }
            .map { $0.distance(to: $1) }
            .reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        let universe = Universe(content: input.split(whereSeparator: \.isNewline).map(Array.init))
        
        return universe.galaxies(withScaleFactor: 1_000_000)
            .combinations(ofCount: 2)
            .map { ($0.first!, $0.last!) }
            .map { $0.distance(to: $1) }
            .reduce(0, +)
    }
}

private struct Universe {
    let content: [[Character]]
    
    func scale(_ point: Point, by scaleFactor: Int) -> Point {
        var emptyRows = 0
        for rowNumber in 0..<point.y {
            let row = content[rowNumber]
            if row.allSatisfy({ $0 == "." }) {
                emptyRows += 1
            }
        }
        
        var emptyColumns = 0
        for columnNumber in 0..<point.x {
            let column = content.map { $0[columnNumber] }
            if column.allSatisfy({ $0 == "." }) {
                emptyColumns += 1
            }
        }
        
        return Point(x: point.x + emptyColumns * (scaleFactor-1), y: point.y + emptyRows * (scaleFactor-1))
    }
    
    func galaxies(withScaleFactor scaleFactor: Int) -> [Point] {
        var points: [Point] = []
        for x in content.first!.indices {
            for y in content.indices where content[y][x] == "#" {
                points.append(scale(Point(x: x, y: y), by: scaleFactor))
            }
        }
        
        return points
    }
}

private struct Point: Hashable {
    let x: Int
    let y: Int
    
    func distance(to other: Point) -> Int {
        abs(x - other.x) + abs(y - other.y)
    }
}
