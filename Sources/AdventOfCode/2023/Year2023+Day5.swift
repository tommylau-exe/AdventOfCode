//
//  Year2023+Day5.swift
//
//
//  Created by Tom Lauerman on 12/4/23.
//

import Algorithms
import Foundation
import RegexBuilder

extension Year2023 {
    enum Day5 {}
}

extension Year2023.Day5 {
    static func part1(input: String) -> Int {
        let seedsAndAlmanac = input.split(separator: Repeat(.newlineSequence, count: 2), maxSplits: 1)
        let seeds = seedsAndAlmanac.first!.matches(of: OneOrMore(.digit))
            .map(\.output)
            .map { Int($0)! }
        let almanac = Almanac.from(seedsAndAlmanac.last!)
        
        return seeds
            .map(almanac.location(for:))
            .min()!
    }
    
    // This brute force solution took about 3 hours and 20 minutes on my M2 Max. I'm aware that there
    // are much better (faster) solutions, but it took me more than 3 hours and 20 minutes to try and
    // figure that out. So this is good enough ✅
    static func part2(input: String) async -> Int {
        let seedsAndAlmanac = input.split(separator: Repeat(.newlineSequence, count: 2), maxSplits: 1)
        let seedGroups = seedsAndAlmanac.first!.matches(of: OneOrMore(.digit))
            .map(\.output)
            .map { Int($0)! }
            .chunks(ofCount: 2)
            .map { ($0.first!, $0.last!) }
            .map { $0...($0 + $1) }
        let almanac = Almanac.from(seedsAndAlmanac.last!)
        
        return await withTaskGroup(of: Int.self, returning: Int.self) { group in
            // Get the local minimum of each group of seeds in parallel
            seedGroups.forEach { seeds in
                group.addTask {
                    seeds.lazy.map(almanac.location(for:)).min()!
                }
            }
            
            // Get the absolute minimum
            return await group.min()!
        }
    }
}

private struct Almanac {
    let maps: [Map]
    
    func location(for seed: Int) -> Int {
        maps.reduce(seed) { seed, map in
            map.mapping(for: seed)
        }
    }
}

private struct Map {
    let ranges: [Range]
    
    func mapping(for value: Int) -> Int {
        guard let range = ranges.first(where: { $0.contains(value) }) else {
            return value
        }
        
        return range.mapping(for: value)
    }
}

private extension Map {
    struct Range {
        let destinationStart: Int
        let sourceStart: Int
        let length: Int
        
        func contains(_ value: Int) -> Bool {
            sourceStart <= value && value < sourceStart + length
        }
        
        func mapping(for value: Int) -> Int {
            destinationStart + (value - sourceStart)
        }
    }
}

// MARK: - Parsing

private extension Almanac {
    static func from(_ input: Substring) -> Self {
        let maps = input.split(separator: Repeat(.newlineSequence, count: 2))
            .map(Map.from(_:))
        
        return Almanac(maps: maps)
    }
}

private extension Map {
    static func from(_ input: Substring) -> Map {
        let rangePattern = Regex {
            Capture(OneOrMore(.digit)) { Int($0)! }
            " "
            Capture(OneOrMore(.digit)) { Int($0)! }
            " "
            Capture(OneOrMore(.digit)) { Int($0)! }
        }
        
        let ranges = input.matches(of: rangePattern)
            .map(\.output)
            .map { Map.Range(destinationStart: $1, sourceStart: $2, length: $3) }
        
        return Map(ranges: ranges)
    }
}
