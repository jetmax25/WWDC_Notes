//: [Previous](@previous)
//: ## Meet SwiftData
//: [Link](https://developer.apple.com/videos/play/wwdc2023/10187/)
//: [Sample](https://developer.apple.com/documentation/coredata/adopting_swiftdata_for_a_core_data_app)
import Foundation
import SwiftUI

//: `@Model` to define schema
/*:
 ```
 @Model
 class Trip {
     @Attribute(.unique) var name: String
     var destination: String
     var endDate: Date
     var startDate: Date
 
    @Relationship(.cascade) var bucketList: [BucketListItem]? = []
 }
 ```
 
 Control how properties are inferred with `@Attribute` and `@Relationship`
 
 exclude properties with `@Transient`
 
 ## Model Container
 
 `let container = try ModelContainer(for: [Trip.self, LivingAccomodation.self], configurations: ModelConfiguration(url: URL("path")))`
 
 ### ModelContext
 * Tracking Updates
 * Fetching Models
 * Saving Changes
 * Undoing Changes
 
 
 ## Predicates
 
 ```
 let tripPRedicate = #Predicate<Trip> {
 $0.destination == "New York"" &&
 $0.name.contains("birthday")
 }
 
 let descriptor = FetchDescriptor<Trip>(predicate: tripPredicate)
 let trips = try context.fetch(descriptor)
 */
 

//: [Next](@next)
