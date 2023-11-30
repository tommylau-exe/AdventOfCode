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
    
    @Option(help: "The puzzle input file to use.")
    var input: String = "input"
    
    func run() throws {
        let solution = switch (year, day, part) {
        case (2022, 1, 1):
            Year2022.Day1.part1
        case (2022, 1, 2):
            Year2022.Day1.part2
        default:
            throw Error.solutionNotFound
        }
        
        let inputFilePath = ["Resources", String(year), String(day), input].joined(separator: "/")
        let inputFileUrl = Bundle.module.url(forResource: inputFilePath, withExtension: "txt")
        guard let inputFileUrl else {
            throw Error.inputFileNotFound
        }
        
        let input = try String(contentsOf: inputFileUrl)
        print(solution(input))
    }
}

extension AdventOfCode {
    enum Error: Swift.Error {
        case solutionNotFound
        case inputFileNotFound
    }
}
