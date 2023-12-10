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
        let map = Map(content: input.split(whereSeparator: \.isNewline).map(Array.init)).removeJunk()
        let emptyPoints = map.allPoints.filter { map.content[$0.y][$0.x] == "." }
        let borderPoints = map.allPoints.filter { $0.isOnBorder(of: map) }
        
        var innerOuterMap: [Map.Point: Bool] = [:]
        var pointsToSearch = borderPoints
        while !pointsToSearch.isEmpty {
            let point = pointsToSearch.removeFirst()
            
            if point.isOnBorder(of: map) || map.emptyNeighbors(of: point).contains(where: {})
        }
        fatalError()
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
        product(0..<width, 0..<height)
            .map { x, y in (Point(x: x, y: y), content[y][x]) }
            .first(where: { point, character in character == "S" })!
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
        case "S": [.north, .south, .east, .west]
        default: []
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
        validDirections(from: point)
            .map { dir in (dir, go(dir, from: point)) }
            .filter { _, point in contains(point) }
            .filter { dir, point in validDirections(from: point).contains(where: { $0 == dir.opposite}) }
            .map { _, point in point }
    }
    
    func removeJunk() -> Map {
        let junkPoints = Set(allPoints.filter { neighbors(for: $0).isEmpty })
        let cleanContent = allPoints.map { junkPoints.contains($0) ? content[$0.y][$0.x] : "." }
        
        return Map(content: Array(cleanContent.chunks(ofCount: width)).map(Array.init))
    }
    
    func emptyNeighbors(of point: Point) -> [Point] {
        Direction.allCases
            .map { go($0, from: point) }
            .filter(contains)
            .filter { point in content[point.y][point.x] == "." }
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
    enum Direction: CaseIterable {
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
