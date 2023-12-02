//
//  Year2023+Day2.swift
//  
//
//  Created by Tom Lauerman on 12/1/23.
//

import Foundation

extension Year2023 {
    enum Day2 {}
}

extension Year2023.Day2 {
    static func part1(input: String) -> Int {
        let configuration = CubeGroup(redCubes: 12, greenCubes: 13, blueCubes: 14)
        
        return input
            .split(whereSeparator: \.isNewline)
            .compactMap(Game.init(from:))
            .filter { $0.observations.allSatisfy { $0.isSubset(of: configuration) } }
            .map(\.id)
            .reduce(0, +)
    }
    
    static func part2(input: String) -> Int {
        input
            .split(whereSeparator: \.isNewline)
            .compactMap(Game.init(from:))
            .map { $0.minimumGroup().power() }
            .reduce(0, +)
    }
}

private struct Game {
    let id: Int
    let observations: [CubeGroup]
    
    func minimumGroup() -> CubeGroup {
        observations
            .reduce(into: CubeGroup.empty) { result, next in
                result.redCubes = max(result.redCubes, next.redCubes)
                result.greenCubes = max(result.greenCubes, next.greenCubes)
                result.blueCubes = max(result.blueCubes, next.blueCubes)
            }
    }
}

private extension Game {
    init?(from string: some StringProtocol) {
        let parts = String(string).split(separator: /:|;\s/)
        let id = parts.first?.split(separator: " ").last.flatMap { Int($0) }
        let observations = parts[1...].map(CubeGroup.init(from:))
        
        self.init(id: id!, observations: observations)
    }
}

private struct CubeGroup {
    var redCubes: Int
    var greenCubes: Int
    var blueCubes: Int
    
    func isSubset(of other: CubeGroup) -> Bool {
        redCubes <= other.redCubes && greenCubes <= other.greenCubes && blueCubes <= other.blueCubes
    }
    
    func power() -> Int {
        redCubes * greenCubes * blueCubes
    }
}

private extension CubeGroup {
    static let empty = CubeGroup(redCubes: 0, greenCubes: 0, blueCubes: 0)
    
    init(from string: some StringProtocol) {
        let parts = string.split(separator: ", ")
        let redCubes = parts.first { $0.contains("red") }?.split(separator: " ").first.flatMap { Int($0) }
        let greenCubes = parts.first { $0.contains("green") }?.split(separator: " ").first.flatMap { Int($0) }
        let blueCubes = parts.first { $0.contains("blue") }?.split(separator: " ").first.flatMap { Int($0) }
        
        self.init(redCubes: redCubes ?? 0, greenCubes: greenCubes ?? 0, blueCubes: blueCubes ?? 0)
    }
}
