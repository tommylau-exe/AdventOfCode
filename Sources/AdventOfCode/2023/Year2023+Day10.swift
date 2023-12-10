//
//  Year2023+Day10.swift
//
//
//  Created by Tom Lauerman on 12/9/23.
//

import Algorithms
import Foundation

extension Year2023 {
    enum Day10 {}
}

extension Year2023.Day10 {
    static func part1(input: String) -> Int {
        let map = Map(content: input.split(whereSeparator: \.isNewline).map(Array.init))
        
        var distanceTo: [Map.Point: Int] = [:]
        var pointsToExplore = [(map.startingPoint, 0)]
        while !pointsToExplore.isEmpty {
            let (point, steps) = pointsToExplore.removeFirst()
            guard distanceTo[point] == nil else { continue }
            
            distanceTo[point] = steps
            pointsToExplore += map.neighbors(for: point).map { ($0, steps + 1)}
        }
        
        return distanceTo.values.max()!
    }
    
    static func part2(input: String) -> Int {
        let originalMap = Map(content: input.split(whereSeparator: \.isNewline).map(Array.init)).removeJunk()
        let scaledMap = originalMap.replaceStart().upscale()
        
        var outerPoints = Set<Map.Point>()
        var pointsToCheck = scaledMap.allPoints.filter { $0.isOnBorder(of: scaledMap) }
        while !pointsToCheck.isEmpty {
            let point = pointsToCheck.removeFirst()
            guard !outerPoints.contains(point) else { continue }
            
            let neighbors = scaledMap.neighbors(for: point)
            if point.isOnBorder(of: scaledMap) || !outerPoints.intersection(neighbors).isEmpty {
                outerPoints.insert(point)
            }
            
            pointsToCheck += neighbors
        }
        
        return originalMap.allPoints
            .filter { originalMap.content[$0.y][$0.x] == "." }
            .filter { !outerPoints.contains(Map.Point(x: 3*$0.x + 1, y: 3*$0.y + 1)) }
            .count
    }
}

private struct Map {
    let content: [[Character]]
    
    var width: Int {
        content.first!.count
    }
    
    var height: Int {
        content.count
    }
    
    var allPoints: some Collection<Point> {
        product(0..<width, 0..<height).map(Point.init)
    }
    
    var startingPoint: Point {
        allPoints
            .map { point in (point, content[point.y][point.x]) }
            .first { _, character in character == "S" }!
            .0
    }
    
    func contains(_ point: Point) -> Bool {
        point.x >= 0 && point.x < width && point.y >= 0 && point.y < height
    }
    
    func validDirections(from character: Character) -> [Direction] {
        return switch character {
        case "|": [.north, .south]
        case "-": [.east, .west]
        case "L": [.north, .east]
        case "J": [.north, .west]
        case "7": [.south, .west]
        case "F": [.south, .east]
        default: [.north, .south, .east, .west]
        }
    }
    
    func validDirections(from point: Point) -> [Direction] {
        validDirections(from: content[point.y][point.x])
    }
    
    func go(_ direction: Direction, from point: Point) -> Point {
        switch direction {
        case .north: Point(x: point.x, y: point.y - 1)
        case .south: Point(x: point.x, y: point.y + 1)
        case .east: Point(x: point.x + 1, y: point.y)
        case .west: Point(x: point.x - 1, y: point.y)
        }
    }
    
    func neighbors(for point: Point) -> [Point] {
        let neighbors = validDirections(from: point)
            .map { dir in (dir, go(dir, from: point)) }
            .filter { _, point in contains(point) }
            .filter { dir, point in validDirections(from: point).contains(where: { $0 == dir.opposite}) }
            .map { _, point in point }
        
        guard content[point.y][point.x] != "S" else {
            return neighbors.filter { point in content[point.y][point.x] != "." }
        }
        
        guard content[point.y][point.x] != "." else {
            return neighbors.filter { point in content[point.y][point.x] != "S" }
        }
        
        return neighbors
    }
    
    func removeJunk() -> Map {
        var loopPoints = Set<Point>()
        var pointsToExplore = [startingPoint]
        while !pointsToExplore.isEmpty {
            let point = pointsToExplore.removeFirst()
            guard !loopPoints.contains(point) else { continue }
            
            loopPoints.insert(point)
            pointsToExplore += neighbors(for: point)
        }
        
        var cleanContent = content
        for junkPoint in loopPoints.symmetricDifference(allPoints) {
            cleanContent[junkPoint.y][junkPoint.x] = "."
        }
        
        return Map(content: cleanContent)
    }
    
    func replaceStart() -> Map {
        let startingPoint = startingPoint
        let directions = validDirections(from: startingPoint)
            .map { dir in (dir, go(dir, from: startingPoint)) }
            .filter { _, point in contains(point) }
            .filter { dir, point in validDirections(from: point).contains(where: { $0 == dir.opposite}) }
            .map { dir, _ in dir }
        
        let replacement: Character = switch Set(directions) {
        case [.north, .south]: "|"
        case [.east,  .west]:  "-"
        case [.north, .east]:  "L"
        case [.north, .west]:  "J"
        case [.south, .west]:  "7"
        case [.south, .east]:  "F"
        default: fatalError()
        }
        
        var newContent = content
        newContent[startingPoint.y][startingPoint.x] = replacement
        
        return Map(content: newContent)
    }
    
    func upscale(_ character: Character) -> [[Character]] {
        switch character {
        case "|":
            [
                [".","|","."],
                [".","|","."],
                [".","|","."],
            ]
        case "-":
            [
                [".",".","."],
                ["-","-","-"],
                [".",".","."],
            ]
        case "L":
            [
                [".","|","."],
                [".","L","-"],
                [".",".","."],
            ]
        case "J":
            [
                [".","|","."],
                ["-","J","."],
                [".",".","."],
            ]
        case "7":
            [
                [".",".","."],
                ["-","7","."],
                [".","|","."],
            ]
        case "F":
            [
                [".",".","."],
                [".","F","-"],
                [".","|","."],
            ]
        default:
            [
                [".",".","."],
                [".",".","."],
                [".",".","."],
            ]
        }
    }
    
    func upscale() -> Map {
        var newContent = Array(repeating: Array(repeating: "." as Character, count: width * 3), count: height * 3)
        for y in content.indices {
            for x in content[y].indices {
                let upscaled = upscale(content[y][x])
                for dy in upscaled.indices {
                    for dx in upscaled[dy].indices {
                        let nx = 3*x + dx
                        let ny = 3*y + dy
                        newContent[ny][nx] = upscaled[dy][dx]
                    }
                }
            }
        }
        
        return Map(content: newContent)
    }
}

private extension Map {
    struct Point: Hashable {
        let x: Int
        let y: Int
        
        func isOnBorder(of map: Map) -> Bool {
            x == 0 || x == map.width - 1 || y == 0 || y == map.height - 1
        }
    }
}

private extension Map {
    enum Direction {
        case north
        case south
        case east
        case west
        
        var opposite: Direction {
            switch self {
            case .north: .south
            case .south: .north
            case .east: .west
            case .west: .east
            }
        }
    }
}
