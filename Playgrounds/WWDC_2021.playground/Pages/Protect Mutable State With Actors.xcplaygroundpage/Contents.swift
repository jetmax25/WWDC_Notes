//: [Previous](@previous)

import Foundation
import SwiftUI

var greeting = "Hello, playground"

//: [Next](@next)

class Counter {
    var value = 0
    
    func increment() -> Int {
        value = value + 1
        return value
    }
}

let counter = Counter()

//: Bad Timing
for _ in 0...5 {
    Task.detached {
        print(counter.increment())
    }
}


//: Value semantics help eliminate data races

var array1 = [1,2]
var array2 = array1

array1.append(3)
array2.append(4)

print(array1) // [1,2,3]
print(array2) // [1,2,4]

//: ## Actors
//: Actors issolate state and are exclusive acess

actor BetterCounter {
    var value = 0
    
    func increment() -> Int {
        value = value + 1
        return value
    }
    
    func resetSlowly(to newValue: Int) {
        value = 0
        for _ in 0..<newValue {
            increment()
        }
        assert(value == newValue)
    }
}

let betterCounter = BetterCounter()

print("Actor\n")
//: Good Timing
for _ in 0...5 {
    Task.detached {
        print(await betterCounter.increment())
    }
}

enum ImageError: Error {
    case badImage
}

func downloadImage(from url: URL) async throws -> Image {
    let (data, _ ) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
        throw ImageError.badImage
    }
    return Image(uiImage: image)
}

actor ImageDownloader {
    private var cache: [URL: Image] = [:]
    
    func image(from url: URL) async throws -> Image? {
        if let cached = cache[url] { return cached }
        let image = try await downloadImage(from: url)
        cache[url] = cache[url, default: image]
        return image
    }
}

//: ### Actor Reentrancy
//: Perform mutation in synchronous code, actor state could change during suspention, check assumtions after `await`

//: Actors can conform to protocol

struct Author {
    let name: String
}

struct Book {
    var title: String
    var authors: [Author]
}

actor LibraryAccount {
    let idNumber: UUID
    var booksOnLoan: [Book] = []
    
    init() {
        idNumber = UUID()
    }
}

extension LibraryAccount: Equatable {
    static func ==(lhs: LibraryAccount, rhs: LibraryAccount) -> Bool {
        lhs.idNumber == rhs.idNumber
    }
}

extension LibraryAccount: Hashable {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(idNumber)
    }
}

//: ## Nonisolated
//: Treated as outside actor
//: Can only acces let properties

//: ### Closures
//: can be isolated to the actor

extension LibraryAccount {
    func readSome(_ book: Book) -> Int {
        1
    }
    
    func read() -> Int {
        booksOnLoan.reduce(0) { result, book in
            result + readSome(book)
        }
    }
    
    func readLater() {
        Task.detached {
            await self.read()
        }
    }
}


//: classes inside of actors can have race problems


//: ## Sendable
//: types that are safe to share concurrently
//: values and actors are sendable
//: immutable classes are sendable
