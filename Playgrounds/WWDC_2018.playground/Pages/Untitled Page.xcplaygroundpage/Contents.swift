//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

extension Collection {
    var midIndex: Index {
        guard count > 1 else { return startIndex }
        return index(startIndex, offsetBy: count / 2)
    }
}

extension RandomAccessCollection where Element: Comparable {
    func sortedInsertionPoint(of value: Element) -> Index {
        
        var slice: SubSequence = self[...]
        
        while !slice.isEmpty {
            if value < slice[midIndex] {
                slice = slice[..<midIndex]
            } else {
                slice = slice[index(after: midIndex)...]
            }
        }
        return slice.startIndex
    }
}

//: Associated types can be recursive and can have default values

protocol Node {
    associatedtype Element
    associatedtype InnerNode: Node where InnerNode.Element == Element
}

//: Required inits must be implemented by all subclasses
//: [Next](@next)

