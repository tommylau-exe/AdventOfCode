//
//  Year2023+Day8.swift
//
//
//  Created by Tom Lauerman on 12/7/23.
//

import Foundation
import RegexBuilder

extension Year2023 {
    enum Day8 {}
}

extension Year2023.Day8 {
    static func part1(input: String) -> Int {
        let directionsAndNodes = input.split(maxSplits: 1, whereSeparator: \.isNewline)
        let directions = Array(directionsAndNodes.first!)
        let nodes = Nodes.from(directionsAndNodes.last!)
        let map = Map(nodes: Dictionary(nodes.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first }))
        
        var steps = 0
        var currentNode = map.get("AAA")
        while currentNode.id != "ZZZ" {
            let nextStep = directions[steps % directions.count]
            switch nextStep {
            case "L":
                currentNode = map.get(currentNode.left)
            case "R":
                currentNode = map.get(currentNode.right)
            default:
                fatalError()
            }
            
            steps += 1
        }
        
        return steps
    }
    
    static func part2(input: String) -> Int {
        let directionsAndNodes = input.split(maxSplits: 1, whereSeparator: \.isNewline)
        let directions = Array(directionsAndNodes.first!)
        let nodes = Nodes.from(directionsAndNodes.last!)
        let map = Map(nodes: Dictionary(nodes.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first }))
        
        // Number of steps each node needs to get to the end (1 cycle)
        var cycleSteps: [String: Int] = [:]
        
        var steps = 0
        var currentNodes = nodes.filter { $0.id.last! == "A" }
        while currentNodes.contains(where: { $0.id.last! != "Z" }) {
            guard cycleSteps.count < currentNodes.count else {
                return leastCommonMultiple(Array(cycleSteps.values))
            }
            
            for node in currentNodes where node.id.last! == "Z" && cycleSteps[node.id] == nil {
                cycleSteps[node.id] = steps
            }
            
            let nextStep = directions[steps % directions.count]
            switch nextStep {
            case "L":
                currentNodes = currentNodes.map { map.nodes[$0.left]! }
            case "R":
                currentNodes = currentNodes.map { map.nodes[$0.right]! }
            default:
                fatalError()
            }
            
            steps += 1
        }
        
        return steps
    }
}

private struct Node {
    let id: String
    let left: String
    let right: String
}

private enum Nodes {
    static func from(_ input: Substring) -> [Node] {
        let nodePattern = Regex {
            Capture(OneOrMore(.word))
            " = ("
            Capture(OneOrMore(.word))
            ", "
            Capture(OneOrMore(.word))
        }
        
        return input.matches(of: nodePattern)
            .map(\.output)
            .map { Node(id: String($1), left: String($2), right: String($3)) }
    }
}

private struct Map {
    let nodes: [String: Node]
    
    func get(_ id: String) -> Node {
        nodes[id]!
    }
}

// Had to use math to make this fast smh
private func leastCommonMultiple(_ arr: [Int]) -> Int {
    arr.reduce(arr.first!, leastCommonMultiple)
}

private func leastCommonMultiple(_ x: Int, _ y: Int) -> Int {
    abs(x * y) / greatestCommonDivisor(x, y)
}

// Implementation of the Euclidean algorithm
private func greatestCommonDivisor(_ x: Int, _ y: Int) -> Int {
    var x = x
    var y = y
    
    while x % y > 0 {
        let r = x % y
        x = y
        y = r
    }
    
    return y
}
