//: [Previous](@previous)
//: Add SharePlay to your app

import Foundation
import GroupActivities



struct OrderTogerther: GroupActivity {
    static let activityIdentifier = "com.example.apple-samplecode.TacoTruck.OrderTogether"
    let orderUUID: UUID
    let truckName: String
    
    var metaData: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = "Ordering Tacos Together"
        metadata.subtitle = truckName
        metadata.previewImage = UIImage(named: "ActivityImage")?.CGImage
        metadata.type = .shopTogether
        return metadata
    }
}

//: Facetime shows all apps with shareplay
//: Use `NSItemProvider` for sharing with friends
//: [Next](@next)
