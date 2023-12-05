//
//  AdventOfCode.swift
//
//
//  Created by Tom Lauerman on 11/29/23.
//

import ArgumentParser
import Foundation

@main
struct AdventOfCode: AsyncParsableCommand {
    @Argument(help: "The year of the puzzle to run (e.g. 2023)")
    var year: Int
    
    @Argument(help: "The day of the puzzle to run (e.g. 25 for December 25th)")
    var day: Int
    
    @Argument(help: "The part of the puzzle to run (e.g. 1 for part 1)")
    var part: Int
    
    @Argument(help: "The puzzle input file to use.")
    var input: String = "input"
    
    func run() async throws {
        let solution = switch (year, day, part) {
        case (2022, 1, 1):
            Year2022.Day1.part1
        case (2022, 1, 2):
            Year2022.Day1.part2
        case (2022, 2, 1):
            Year2022.Day2.part1
        case (2022, 2, 2):
            Year2022.Day2.part2
        case (2023, 1, 1):
            Year2023.Day1.part1
        case (2023, 1, 2):
            Year2023.Day1.part2
        case (2023, 2, 1):
            Year2023.Day2.part1
        case (2023, 2, 2):
            Year2023.Day2.part2
        case (2023, 3, 1):
            Year2023.Day3.part1
        case (2023, 3, 2):
            Year2023.Day3.part2
        case (2023, 4, 1):
            Year2023.Day4.part1
        case (2023, 4, 2):
            Year2023.Day4.part2
        case (2023, 5, 1):
            Year2023.Day5.part1
        case (2023, 5, 2):
            Year2023.Day5.part2
        case (2023, 6, 1):
            Year2023.Day6.part1
        case (2023, 6, 2):
            Year2023.Day6.part2
        default:
            throw Error.solutionNotFound
        }
        
        let inputFile = Bundle.module.url(
            forResource: ["Resources", String(year), String(day), input].joined(separator: "/"),
            withExtension: "txt"
        )
        
        guard let inputFile else {
            throw Error.inputFileNotFound
        }
        
        let input = try String(contentsOf: inputFile)
        let startTime = Date.now
        
        print(await solution(input))
        
        let computeTime = Measurement<UnitDuration>(
            value: Date.now.timeIntervalSince(startTime),
            unit: .seconds
        )
        print("Finished in \(computeTime.formatted())")
    }
}

extension AdventOfCode {
    enum Error: Swift.Error {
        case solutionNotFound
        case inputFileNotFound
    }
}
