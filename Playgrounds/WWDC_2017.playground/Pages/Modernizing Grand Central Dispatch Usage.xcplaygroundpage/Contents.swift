//: [Previous](@previous)
//: # Modernizing Grand Central Dispatch Usage

import Foundation


//: Parallel For Loop
DispatchQueue.concurrentPerform(iterations: 3) {
    print($0)
}

//: Use Instruments system trace to see what threads are doing

/*:
 * Unfair Lock - os_unfair_lock
    * Can steal lock
    * Waiter Starvation
 * Fair Lock - DispatchQueue.sync
    * context switches to next waiter
    * cannot cause waiter starvation
 
 
Queues
 * Single Owner
    * serial queues
    * DispatchWorkItem.wait
    * os_unfair_lock
    * pthread_mutex, NSLock
 * Now Owner
    * dispatch_semaphore
    * dispatch_group
    * pthread_cond, NSCondition
    * Queue suspension
 * Multiple Oner
    *
    *

 One Queue hierarchy for subsystem

*/



//: [Next](@next)
