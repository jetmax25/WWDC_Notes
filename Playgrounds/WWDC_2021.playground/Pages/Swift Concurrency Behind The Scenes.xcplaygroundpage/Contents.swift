//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

/**
 Modern syntax uses `continuations` on the cpu
 
 should create as many threads as CPU cores
*/

struct Article {}
struct Feed {
    let url: URL
}

let feedsToUpdate: [Feed] = []

func deserializeArticles(from data: Data) throws -> [Article] {
    []
}

func updateDatabase(with articles: [Article], for feed: Feed) async {
    
}


func updateFeed() async {
    await withThrowingTaskGroup(of: [Article].self) { group in
        for feed in feedsToUpdate {
            group.addTask {
                let (data, _) = try await URLSession.shared.data(from: feed.url)
                let articles = try deserializeArticles(from: data)
                await updateDatabase(with: articles, for: feed)
                return articles
            }
        }
    }
}

/**
 ```
 func add(_ newArticles: [Article]) async throws {
    let ids = try await database.save(newArticles, for: self)
    for (id, article) in zip(ids, newArticles) {
        articles[id] = article
    }
 }
 
 func updateDatabase(...) async {
    await feed.add(articles)
 }
 ```
 
 # Runtime Contract that threads always make forward progress
 
 * only spawns as many threads as CPU cores
 * cooperative thread pool
 * workers never block threads
 
 Cannot hold locks across await
 thread specific data is not proserved across `await`

Enviorment variable `LIBDISPATCH_COOPERATIVE_POOL_STRICT` value `1` forces forward progress and seeing hung threads show bad concurrency
 
 ### Actor Reentrancy
 actors are duplicated when needed while blocked
 */


