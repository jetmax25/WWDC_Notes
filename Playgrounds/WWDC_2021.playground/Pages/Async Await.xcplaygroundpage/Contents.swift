//: [Previous](@previous)

import Foundation
import UIKit
import XCTest

var greeting = "Hello, playground"

//: [Next](@next)

enum FetchError: Error {
    case badID
    case badImage
}

//: ## Old Style
func fetchThumbnail(for id: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
    let request = thumbnailURLRequest(for: id)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
        } else if (response as? HTTPURLResponse)?.statusCode != 200 {
            completion(.failure(FetchError.badID))
        } else {
            guard let image = UIImage(data: data!) else {
                completion(.failure(FetchError.badImage))
                return
            }
            image.prepareThumbnail(of: CGSize(width: 40, height: 40)) { thumbnail in
                guard let thumbnail = thumbnail else {
                    completion(.failure(FetchError.badImage))
                    return
                }
                completion(.success(thumbnail))
            }
        }
    }
    task.resume()
}

func thumbnailURLRequest(for id: String) -> URLRequest {
    URLRequest(url: URL(string: "https://res.cloudinary.com/dzxqhkyqd/image/upload/v1554871230/planet-express.png")!)
}


//: ## Async Await

func fetchThumbnail(for id: String) async throws -> UIImage {
    let request = thumbnailURLRequest(for: id)
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badID }
    let maybeImage = UIImage(data: data)
    guard let thumbnail = await maybeImage?.thumbnail else { throw FetchError.badImage }
    print("Found thumbnail")
    return thumbnail
}


let image = try? await fetchThumbnail(for: "3")
print("EOF")

//: ### Async properties use `get`
extension UIImage {
    var thumbnail: UIImage? {
        get async {
            let size = CGSize(width: 40, height: 40)
            return await self.byPreparingThumbnail(ofSize: size)
        }
    }
}

//: ### Async Sequence

/**
 ```
 for await id in staticImageIdsURL.lines {
     let thumbnail = await fetchThumbnail(for: id)
     collage.add(thumbnail)
 }
 let result = await collage.draw()
 ```

 */

//: ## Old Test With Expectation
/**
 ```
 class MockViewModelSpec: XCTestCase {
     func testFetchThumbnails() throws {
         let expectation = XCTestExpectation(description: "Mock thumbnail completion")
         fetchThumbnail(for: "mockId") { result, error in
             XCTAssertEqual(result?.size, CGSize(width: 40, height: 40))
             expectation.fulfill()
         }
         wait(for: [expectation], timeout: 5.0)
     }
 }
 ```
 */


//: New Test
class MockViewModelSpec: XCTest {
    func testFetchThumbnails() async throws {
        let result = try await fetchThumbnail(for: "MockId")
        XCTAssertEqual(result.size, CGSize(width: 40, height: 40))
    }
}

//: ### User `Task` do use async on sync

//: ## dont use the word get in functions that are async


//: ## Continuation

func testCompletion(completion: @escaping (Result<Int, Error>) -> Void) {
    completion(.success(3))
}

func persistentPosts() async throws -> Int {
    typealias PostConinuation = CheckedContinuation<Int, Error>
    return try await withCheckedThrowingContinuation { (continuation: PostConinuation) in
        testCompletion { result in
            switch result {
            case let .failure(error): continuation.resume(throwing: error)
            case let .success(value): continuation.resume(returning: value)
            }
        }
    }
}

let postTest = try await persistentPosts()
