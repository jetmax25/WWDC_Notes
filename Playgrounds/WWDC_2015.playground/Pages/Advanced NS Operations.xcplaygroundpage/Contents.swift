//: [Previous](@previous)
//: # Advanced NS Operations
import Foundation

let queue = OperationQueue()
queue.maxConcurrentOperationCount = .max

let serialQueue = DispatchQueue(label: "adF", attributes: .concurrent)

(0...10).forEach { index in
    queue.addOperation {
        sleep(UInt32.random(in: 0...1))
        print(index)
    }
}
//: [Next](@next)
