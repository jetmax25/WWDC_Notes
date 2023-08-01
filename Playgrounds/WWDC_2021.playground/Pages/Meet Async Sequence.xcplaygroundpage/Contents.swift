//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

struct QuakesTool {
    static func main() async throws {
        let endpointURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")!
        
        // skip the header line and iterate each one
        // to extract the magnitude, time, latitude and lognitude
        
        for try await event in endpointURL.lines.dropFirst() {
            let values = event.split(separator: ",")
            let time = values[0]
            let latitude = values[1]
            let longitude = values[2]
            let magnitude = values[4]
            
            print("Magnitude \(magnitude) on \(time) at \(latitude) \(longitude)")
        }
    }
}

Task {
    try await QuakesTool.main()
}

/**
 ```
 for await value in values {
    doSomething(value)
 }
 ```
 */

/** ### Bytes from a FileHandle
 read bytes asyncrounously from a `FileHandle`
 
 `public var bytes: AsyncBytes`
 `public var lines AsyncLineSequence<AsyncBytes>`
 
 ```
 for try await line in FileHandle.standardInput.bytes.lines {
 
 }
 ```
 
 ### Bytes from a URLSession
 
 read bytes asynchrounously from a `URLSession`
 
 `func bytes(from: URL) async throws -> (AsyncBytes, URLResponse)`
 `func bytes(for: URLRequest) async throws -> (AsyncBtyes, URLResponse)`
 
 ```
 let (bytes, response) = try await URLSession.shared.bytes(from: url)
 guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
 throw MyNetworkingError.invalidServerResponse
 }
 for try await byte in bytes {
 }
 ```
 
 ### Notifications
 
 Await notifications asynchronously
 `public func notifications(named: Notification.Name, object: AnyObject) -> Notifications`
 
 ```
 let center = NotifcationCenter.default
 let notification = await center.notifications(named: .NSPersistentStoreRemoteChange).first {
 $0.userInfo[NSStoreUUIDKey] == storeUUID
 }
 ```
 
 ### Converting to Async Sequence
 ```
 class QuakeMonitor {
    var quakeHandler(Quake) -> Void
    func startMonitoring()
    func stopMonitoring()
 }
 ```
 
 ```
 let quakes = AsyncStream(Quake.self) { continuation in
    let monitor = QuakeMonitor()
    monitor.quakeHandler = { quake in
        continuation.yield(quake)
    }
    continuation.onTermination = { _ in
        monitor.stopMonitoring()
    }
    monitor.startMonitoring()
 }
```
```
 let significantQuakes = quakes.filter { quake in
    quake.magnitude > 3
 }
 
 for await quake in significantQuakes {
 }
```
*/

/**
  `AsyncThrowingStream` can handle errors
 */
