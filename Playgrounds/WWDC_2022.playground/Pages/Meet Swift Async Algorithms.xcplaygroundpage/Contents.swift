//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

/*:
 
 ## Zip
 
 upload attachments of videos and previews such that every video has a preview that are created concurrently so neither blocks each other
 
 ```
 for try await (vid, preview) in zip(videos, previews)  {
    try await upload(vid, preview)
 }
 ```
 
 ## Merge
 
 * Combine multiple `AsyncSequences` into one `AsyncSequence`
 * Element types must be the same
 * Awaits elements concurrently and rethrows failures
 
 */

let clock = SuspendingClock()
var deadline = clock.now + .seconds(1)
try await clock.sleep(until: deadline)

func someLongRunningWork() async {
    sleep(1)
}

//: Measure elapsed duration of work
let elapsed = await clock.measure {
    await someLongRunningWork()
}

let continousClock = ContinuousClock()
let elapsedContinous = await clock.measure {
    await someLongRunningWork()
}

print(elapsed, elapsedContinous)

/*:
 ```
 class SearchController {
     let searchResults = AsyncChannel<SearchResult>()
     
     func search<SearchValues: AsyncSequence>(_ searchValues: SearchValues) where SearchValues.Element == String
 }
 ```
 
 Debounce input
 ```
 let queries = searchValues.debounce(for: .milliseconds(300))
 for await query in queries {
    let results = try await performSearch(query)
    await channel.send(results)
 }
 ```
 
 ## Chunks
 Groups elements into collections
 * by count
 * by time
 * by content
 
 ```
 let batches = outbountMessages.chuncked(by: .repeating(every: .milliseconds(500))
 
 let encoder = JSONEncoder()
 for await batch in batches {
    let data = try encoder.encode(batch)
    try await postToServer(data)
 }
 ```
 */

