
//: [Previous](@previous)

//: # Whats New In Swift

import SwiftData
/*:
### Unique
 
 macro that defines what properties must be unique
 an array is set and one of the properties must be unique
 */

@Model
class Trip {
    ///Can have the same name as long as either start or end date are unique
    #Unique<Trip>([\.name, \.startDate, \.endDate])
    
    
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    
    var bucketList: [BucketListItem] = [BucketListItem]()
    var livingAccomodation: LivingAccommodation?
}


/*:
 ### History
 
 Track inserted updated and deleted models
 
 opt in to preserve values on deletion
 works with custom data stores
 
 
 `@Attribute(.preserveValueOnDeletion)`
 allows a delted model to be searched via the history api

 
 */

@main
struct TripsApp: App {
    var container: ModelContainer = {
        do {
            let configuration = JSONStoreConfiguration(schema: Schema([Trip.self]), url: fileURL)
        } catch { ... }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}


/*:
 Preview Modifier
 */

struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfigurationi(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Trip.self, configurations: config)
        Trip.makesSampleTrips
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        context.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}

#Preview(traits: .sampleData) {
    @Previewable @Query var trips: [Trip]
    BucketListItemView(trip: trips.first)
}

//: ## Predicate

let predicate = #Predicate<Trip> {
    searchText.isEmpty ? true: $0.name.localizedStandardContains(searchText)
}

//: ## Expressions

let unplannedItemsExpression = #Expression<[BucketListItem], Int> { items in
    items.filter { !$0.isInPlan }.count
}
let today = Date.now
let tripsWithUnplannedItems = #Predicate<Trip> { trip in
    (trip.startDate..< trip.endDate).contains(today) && unplannedItemsExpression.evaluate(trip.bucketList) > 0
}

//: ## Index
//: Used to help index commonly used keypaths for lookups

