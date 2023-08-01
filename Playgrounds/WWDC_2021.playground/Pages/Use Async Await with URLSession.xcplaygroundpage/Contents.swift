//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

enum DogsError: Error {
    case invalidServerResponse
    case unsupportedImage
}

func fetchPhoto(url: URL) async throws -> UIImage {
    let (data, response) = URLSession.shared.data(from: url)
    
    guard let httpReponse = response as? HTTPURLResponse, httpReponse.statusCode == 200 else {
        throw DogsError.invalidServerResponse
    }
    
    guard let image = UIImage(data: data) else {
        throw DogsError.unsupportedImage
    }
    return image
}


//: ### URLSession Download

/***
 ```
 func download(from url: URL) async throws -> (URL, URLResponse)
 func download(for request: URLRequest) async throws -> (URL, URLResponse)
 func download(resumeFrom resumeData: Data) async throws -> (URL, URLResponse)
 
 let (location, response) = try await URLSession.shared.download(from: url)
 guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
 throw DogsError.invalidServerResponse
 }
 
 try FileManager.default.moveItem(at: location, to: newLocation)
 ```
 */

let task = Task {
    let (data1, response1) = try await URLSession.shared.data(from: URL())
}

task?.cancel()

//: ### URLSession.bytes

/**
 ```
 func bytes(from url: URL) async throws -> (URLSession.AsyncBytes, URLResponse)
 func bytes(for request: URLRequest) async throws -> (URLSession.AsyncBytes, URLResponse)
 
 struct AsyncBytes: AsyncSequence {
 typealias Element = UInt8
 }
 ```
 */

private func sync() async throws {
    let request = URLRequest(url: endpoint)
    let (data, response) = try away URLSession.shared.data(for: request, delegate: AuthenticationDelegate(signInController: signInController))
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw DogsError.invalidServerResponse
    }
    
    let photos = try JSONDecoder().decode([PhotoMetadata].self, from: data)
    
    await updatePhotos(photos)
}

func onAppearHandler() async throws {
    let (bytes, response) = try await URLSession.shared.bytes(from: Self.eventStreamURL)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else  {
        throw DogsError.invalidServerResponse
    }
    
    for try await line in bytes.lines {
        let photoMetadata = try JSONDecoder().decode(PhotoMetadata.self, from Data(line.utf8))
        await updateFavoriteCount(with: photoMetadata)
    }
}

//# URLsessionTask-specific delegate

/**
 
```
func data(from url: URL)
func data(for request: URLRequest)

func upload(for request: URLRequest, fromFile url: URL)
func upload(for request: URLRequest, from data: Data)

func download(from url: URL)
func download(for request: URLRequest)
func download(resumeFrom resumeData: Data)

func bytes(from url: URL)
func bytes(for request: URLRequest)
 ```
 
 ^ all can also take `delegate: URLSEssionTaskDelegate?`
 */

class AuthenticationDelegate: NSObject, URLSessionTaskDelegate {
    private let signInController: SignInController
    
    init(signInController: SignInController) {
        self.signInController = signInController
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic {
            do {
                let (username, password) = try await signInController.promptForCredential()
                return (.useCredential, URLCredential(user: username, password: password, persistence: .forSession))
            } catch {
                return (.cancelAuthenticationChallenge, nil)
            }
        } else {
            return (.performDefaultHandling, nil)
        }
    }
}
