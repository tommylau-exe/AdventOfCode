//
//  Year2023+Day6.swift
//
//
//  Created by Tom Lauerman on 12/5/23.
//

import Foundation
import RegexBuilder

extension Year2023 {
    enum Day6 {}
}

extension Year2023.Day6 {
    static func part1(input: String) -> Int {
        let timesAndDistances = input.split(whereSeparator: \.isNewline)
        let times = timesAndDistances.first!.matches(of: OneOrMore(.digit)).map(\.output).map { Int($0)! }
        let distances = timesAndDistances.last!.matches(of: OneOrMore(.digit)).map(\.output).map { Int($0)! }
        
        return zip(times, distances)
            .map { Race(time: $0, recordDistance: $1) }
            .map { $0.countWaysToBeatTheRecord() }
            .reduce(1, *)
    }
    
    static func part2(input: String) -> Int {
        let timeAndDistance = input.split(whereSeparator: \.isNewline)
            .map { $0.filter(\.isNumber) }
            .map { Int($0)! }
        let time = timeAndDistance.first!
        let distance = timeAndDistance.last!
        let race = Race(time: time, recordDistance: distance)
        
        return race.countWaysToBeatTheRecord()
    }
}

private struct Race {
    let time: Int
    let recordDistance: Int
    
    func countWaysToBeatTheRecord() -> Int {
        (0...time)
            .map { (time - $0) * $0 }
            .filter { $0 > recordDistance }
            .count
    }
}
