//: [Previous](@previous)

import Foundation
import UIKit

var greeting = "Hello, playground"

//: [Next](@next)

//: ### Task provides new async context for executing code concurrently

//: ## Async Let Binding
/**
 Sequential Binding
```
func fetchOneThumbnail(withId id: String) async throws -> UIImage {
    let imageReq = imageReques(for: id), metadataReq = metadataRequest(for: id)
    let (data, _) = try await URLSession.shared.data(for: imageReq)
    let (metadata, _) = try await URLSession.shared.data(for: metadataReq)
    guard
        let size = parseSize(from: metadata),
        let image = await UIImage(data: data)?.byPreparingThumbnail(ofSize: size)
    else {
        throw ThumbnailFailedError()
    }
    return image
 }
 ```
 Parallel Binding
 ```
 func fetchOneThumbnail(withId id: String) async throws -> UIImage {
     let imageReq = imageReques(for: id), metadataReq = metadataRequest(for: id)
     async let (data, _) = URLSession.shared.data(for: imageReq)
     async let (metadata, _) = URLSession.shared.data(for: metadataReq)
     guard
         let size = parseSize(from: try await metadata),
         let image = try await UIImage(data: data)?.byPreparingThumbnail(ofSize: size)
     else {
         throw ThumbnailFailedError()
     }
     return image
 }
  ```
 
 */

//: ## Use `async let` to get value before use is needed, use `await` only when needed

//: #### Tasks are not stoppped immediatly when cancelled

//: ### Cancellation Checking
/**
 ```
 func fetchThumbnails(for ids: [String]) async throws -> [String : UIImage] {
    var thumbnails: [String: UIImage] = [:]
    for id in ids {
        try Task.checkCancellation()
        //Can also use `if Task.isCancelled { break }` if you want partial result
        thumbnails[id] = try await fetchOneThumbnail(withID: id)
    }
    return thumbnails
 }
 ```
 */

//: ### Group Task
/**
 ```
 func fetchThumbnails(for ids: [String]) async throws -> [String: UIImage] {
     var thumbnails: [String: UIImage] = [:]
     try await withThrowingTaskGroup(of: (String, UIImage).self) { group in
        for id in ids {
            group.async {
                return (id, try await fetchOneThumbnail(withId: id))
            }
        }
        for try await(id, thumbnail) in group {
            thumbnails[id] = thumbnail
        }
    }
    return thumbnails
 }
 ```
 */

//: Task creation takes a `@Sendable` closure and cannot capture mutable variables

//: ## MainActor
/**
 ### Unscoped Task
 The Task performs on the main thread but only when the thread is available
 ```
 @MainActor
 class MyDelegate: UICollectionViewDelegate {
    var thumbnailTasks: [IndexPath: Task<Void, Never>] = [:]
     func collectionView(
         _ view: UICollectionView,
         willDisplay cell: UICollectionViewCell,
         forItemAt item: IndexPath
     ) {
         let ids = getThumbnailIDS(for: item)
         thumbnailTaks[item] = Task {
            defer { thumbnailTaks[item] = nil }
             let thumnails = await fetchThumbnails(for: ids)
            Task.detached(priority: .background) {
                writeToLocalCache(thumbnails)
            }
             display(thumnails, in: cell)
         }
     }
 
    func collectionView(
         _ view: UICollectionView,
         didEndDisplay cell: UICollectionViewCell,
         forITemAt item: IndexPath
    ) {
        thumbnailTasks[item]?.cancel()
    }
 }
 ```
 
 Detached Tasks can go on different threads for example from `@MainActor` to background
 
 ```
 withTaskGroup(of: Void.self) { g in
    g.async { writeToLocalCache(thumbnails) }
    g.async { log(thumbnails) }
    g.async { ... }
 }
 ```
 */

