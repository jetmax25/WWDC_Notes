//: [Previous](@previous)

//: # Whats New In Swift


/*:
### Non Copyable types
 */

struct Test: ~Copyable {
    
}

/*:
 `Embedded swift` allows standa alown binaries
 */


/*:
 ### Typed throw errors
 */
enum MyError: Error {
    case forceThrow
}
func testThrow() throws(MyError) -> Int {
    throw MyError.forceThrow
}

/*:
 ### Synchronization
 */

import Synchronization

let counter = Atomic<Int>(0)

DispatchQueue.concurrentPerform(iterations: 10) { _ in
    for _ in 0..<1_000_000 {
        counter.wrappingAdd(1, ordering: .relaxed)
    }
}

print(counter.load(orderingg: .relaxed))

final class LockingResourceManager: Sendable {
    let cache = Mutex<[String: Resource]>([:])
    
    func save(_ resource: Resource, as key: String) {
        cache.withLock {
            $[key] = resource
        }
    }
}
