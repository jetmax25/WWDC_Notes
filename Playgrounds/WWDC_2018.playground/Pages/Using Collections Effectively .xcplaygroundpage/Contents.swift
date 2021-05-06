//: [Previous](@previous)
//: # Using Collections Effectively

import Foundation

//: Get 2nd element from collection

extension Collection {
    var secondElement: Element? {
        dropFirst().first
    }
}

//: ## Lazy
//: Use lazy to only calculate on the items needed.
//:Lazy calculates when an element is used. Using lazy here allows 0.4 runtime, without lazy it takes over 5 seconds. We only needed the first element
let start = CFAbsoluteTimeGetCurrent()
let items = (1...400001).lazy.map { $0 * $0 }.filter { $0 < 100 }
print(items.first)
let diff = CFAbsoluteTimeGetCurrent() - start
print(diff)

//: The following only does a filter until it gets the element it needs, why filter the whole thing If I only need the first element
let bears = ["Grizzly", "Gummy", "Polar Bears", "Panda", "Chicago"]

let redundantBears = bears.lazy.filter {
    print("Checking '\($0)'")
    return $0.contains("Bear")
}

print(redundantBears.first)

//: But it would need to calculate it every time
print(redundantBears.first)

//: Unless we store it in an array

let redundantCopy = Array(redundantBears)
print(redundantCopy.first)
print("Don't need to recalculate")
print(redundantCopy.first)

//: **Mutation Renders Index's Invalid**

var nums = Array((0...5))
let index = nums.firstIndex(of: 2)!
print(nums[index])
nums.remove(at: nums.startIndex)
//: Prints a different value than expected
print(nums[index])

//: Dictionary Example

print("\nDictionary Exampple of Index Mutation\n")
var favorites: [String: String] = [
    "dessert" : "honey ice cream",
    "sleep" : "hibernation",
    "food" : "salmon"
]

let foodIndex = favorites.index(forKey: "food")!
print(favorites[foodIndex])
favorites["acessory"] = "tie"
favorites["hobby"] = "stand up"
//: Would be error or wrong answer
//print(favorites[foodIndex])

//: ## Threading
//: Collections are optimized from single thread access
print("\nThreading\n")

var sleepingBears = [String]()
let queue = DispatchQueue(label: "Bear Cave ")
queue.async { sleepingBears.append("Grandpa") }
queue.async { sleepingBears.append("Cub") }
queue.async { print(sleepingBears) }

//: **Avoid Mutable Collections Where Possible, Use Slices Instead**

// ## Reserve Capacity
print("\nBridging\n")
var arrayReseve = [Int]()
arrayReseve.reserveCapacity(5)

var set = Set<Int>()
set.reserveCapacity(5)

var dict = [String: String]()
dict.reserveCapacity(5)


//: ## Bridging

//: Use NSMutableArray and other C datatypes for reference. Swift types are value

var valueArray = [1]
var refArray: NSMutableArray = [1]

var valueCopy = valueArray
var refCopy = refArray

valueCopy.append(2)
refCopy.add(2)

print(valueArray)
print(refArray)

//: [Next](@next)
