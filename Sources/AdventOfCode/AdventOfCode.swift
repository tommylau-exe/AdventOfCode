//
//  AdventOfCode.swift
//
//
//  Created by Tom Lauerman on 11/29/23.
//

import ArgumentParser
import Foundation

@main
struct AdventOfCode: ParsableCommand {
    @Argument(help: "The year of the puzzle to run (e.g. 2023)")
    var year: Int
    
    @Argument(help: "The day of the puzzle to run (e.g. 25 for December 25th)")
    var day: Int
    
    @Argument(help: "The part of the puzzle to run (e.g. 1 for part 1)")
    var part: Int
    
    @Argument(help: "The puzzle input file to use.")
    var input: String = "input"
    
    func run() throws {
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
        print(solution(input))
    }
}

extension AdventOfCode {
    enum Error: Swift.Error {
        case solutionNotFound
        case inputFileNotFound
    }
}
