//: [Previous](@previous)
//: # Embracing Algorithms

import Foundation

var test: [Int] = Array(1...10)
var test2: [Int] = Array(1...10)
print("Started")
//: [Next](@next)

extension MutableCollection where Self: RangeReplaceableCollection {
    mutating func customRemoveAll(where shouldRemove: (Element) -> Bool ) {
        let suffixStart = customHalfStablePartition(isSuffixElement: shouldRemove)
        removeSubrange(suffixStart...)
    }
    
    mutating func customBringToFront( where shouldBring: (Element) -> Bool) {
        partition { !shouldBring($0) }
    }
    
    mutating func customBringToBack( where shouldBring: (Element) -> Bool) {
        partition { shouldBring($0) }
    }
    
    mutating func bringForward( where shouldBring: (Element) -> Bool) {
        if let index = indexBeforeFirst(where: shouldBring) {
            self[index...].customBringToFront(where: shouldBring)
        }
    }
}

extension MutableCollection {
    mutating func customHalfStablePartition(isSuffixElement: (Element) -> Bool) -> Index {
        guard var i = firstIndex(where: isSuffixElement) else { return endIndex }
        var j = index(after: i)
        
        while j != endIndex {
            if !isSuffixElement(self[j]) {
                print(self[j], i, j)
                swapAt(i, j)
                formIndex(after: &i)
            }
            formIndex(after: &j)
        }
        return i
    }
    
//    mutating func stablePartition(count n: Int, isSuffixElement: (Element) -> Bool) -> Index {
//        if n == 0 { return startIndex }
//        if n == 1 { return isSuffixElement(self[startIndex]) ? startIndex : endIndex }
//        let midPoint = n / 2, i = index(startIndex, offsetBy: midPoint)
//        let j = self[..<i].stablePartition(count: midPoint, isSuffixElement: isSuffixElement)
//        let k = self[i...].stablePartition(count: n - midPoint, isSuffixElement: isSuffixElement)
//        return self[j..<k].rotate(shiftingToStart: i)
//    }

    
}

extension Collection {
    
    /// Returns element before the first one whose element satisfies `predicate`
    /// - Complexity: O(n) where n is the length of the collection
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#description#>
    func indexBeforeFirst(where predicate: (Element) -> Bool) -> Index? {
        return indices.first {
            let successor = index(after: $0)
            return successor != endIndex && predicate(self[successor])
        }
    }
}

let closure: (Int) -> Bool = { $0.isMultiple(of: 2)}
////test.customRemoveAll { $0.isMultiple(of: 2) }
////test2.customBringToFront { $0.isMultiple(of: 2)}
//test.customBringToFront { $0.isMultiple(of: 2)}
//print(test)
////print(test2)


print(test2)
