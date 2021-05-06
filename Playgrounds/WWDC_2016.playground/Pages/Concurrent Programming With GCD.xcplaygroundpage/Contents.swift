//: [Previous](@previous)

//: # Concurrent Programming With GCD
import Foundation

let group = DispatchGroup()
let queue = DispatchQueue(label: "My Queue")
let queue2 = DispatchQueue(label: "Other Queue")

queue.async(group: group) {
    sleep(3)
    print("Did Something")
}

queue2.async(group: group) {
    sleep(1)
    print("Sleep One")
}

group.notify(queue: DispatchQueue.main) {
    print("Done")
}

//: Can use subsystem serial queues for mutural exclusion

var count: Int {
    queue.sync { return 5 }
}

//: The 2nd one happens first  because it is higher priority
DispatchQueue.global(qos: .background).async {
    print("Background")
}

DispatchQueue.global(qos: .userInteractive).async {
    print("User Interactive")
}


//: ## Dispatch Work
let item = DispatchWorkItem(flags: .assignCurrentContext) {
    print("Item")
}


queue.async(execute: item)

//: User Queues to sync

class MyObject {
    private var internalState: Int
    private let internalQueue: DispatchQueue
    
    init() {
        internalState = 0
        internalQueue = DispatchQueue(label: "QueueObject")
    }
    
    var state: Int {
        get {
            return internalQueue.sync { internalState }
        }
        set (newState) {
            internalQueue.sync { internalState = newState }
        }
    }
}

//: ### Preconditions
//: Avoid data corruption

dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
dispatchPrecondition(condition: .notOnQueue(queue))

/*: ## Object Lifecycle
 
 1. Single threaded setup
 2. activate the concurrent state machine
 3. invalidate the concurrent state machine
 4. single threaded deallocation
 
 */



//: [Next](@next)
