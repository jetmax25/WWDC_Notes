//: [Previous](@previous)
//: # [Explore logging in Swift](https://developer.apple.com/videos/play/wwdc2020/10168/)
import UIKit
import PlaygroundSupport
import os.log

//: # WARNING LOGS DO NOT WORK IN PLAYGROUND DIRECTLY USE SWIFT FILE

let logger = Logger(subsystem: "com.example.pickledGames", category: "PlaygroundLog")

(0...5).forEach { index in
    logger.log( "Loop Number \(index)" )
}

//: Non numeric types are redacted for security unless `privacy .public` is used

let password = "secret"
let userName = "PoopsMcgee"

logger.log("Password is \(password)")

//: used within the string interpolation itself
logger.log("Username is \(userName, privacy: .public)")
//: [Next](@next)
logger.log("Hashed Pass is \(password, privacy: .private(mask: .hash))")
