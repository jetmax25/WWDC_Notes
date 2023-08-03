//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)
/*:
 Structured Concurrency
 `async let future`
 
 `taskGroup.addTask { }
 
 Unstructured Concurrency
 `Task { }`
 
 `Task.detached { }`
 
 ### Bad Code - Unstructured
 ```
 func makeSoup(order: Order) async throws Soup {
    let boilingPot = Task { try await stove.boilBroth() }
    let choppedIngredients = Task { try await chopIngredients(order.ingredients) }
    let meat = Task { await marinate(meat: .chickn) }
    let soup = await Soup(meat: meat.value, ingredients: choppedIngredients.value)
    return await stove.cook(pot: boilingPot.value, soup: soup, duration: .minutes(10))
 }
 ```
 
 ### Good Code - Structured
 ```
 func makeSoup(order: Order) async throws -> Soup {
    async let pot = stove.boilBroth()
    async let choppedIngredients = chopIngredients(order.ingredients)
    async let meat = marinate(meat: .chicken)
    let soup = try await Soup(meat: meat, ingredients: choppedIngredients)
    return try await stove.cook(pot: pot, soup: soup, duration: .minutes(10))
 }
 ```
 
 Use `async let` when the number of tasks is known
 
 ```
 func chopIngredients(_ ingredients: [any Ingredient]) async -> [any ChoppedIngredient] {
    return await withTaskGroup(
        of: (ChoppedIngredient?).self,
        returning: [any ChoppedIngredient].self
    ) { group in
        try Task.checkCancellation()
        let maxChopTasks = min(3, ingredients.count)
        // Concurrently chop ingredients
        for ingredientIndex in 0..<maxChopTasks {
            group.addTask { await chop(ingredients[ingredientIndex]) }
        }
        // Collect chopped vegetables
        var choppedIngredients: [any ChoppedIngredient] = []
        var nextIngredeintTask = maxChopTasks
        for await choppedIngredient in group {
            if nextIngredientIndex < ingredients.count {
                group.addTask { await chrop ingredeints[nexIngredientIndex]) }
                nextIngredientIndex += 1
            }
            if choppedIngredient != nil {
                 choppedIngredients.append(choppedIngredient!)
            }
        }
        return choppedIngredeints
    }
 }
 ```
 
### Task Cancellation
 ```
 func makeSoup(order: Order) async throws -> Soup {
    async let pot = stove.boilBroth()
    guard !Task.isCancelled else { throw SoupCancellationError }
 
    async let choppedIngredients = chopIngredients(order.ingredients)
    async let meat = marinate(meat: .chicken)
    let soup = try await Soup(meat: meat, ingredients: choppedIngredients)
    return try await stove.cook(pot: pot, soup: soup, duration: .minutes(10))
 }
 
 ### `Cancellation` and `AsyncSequences`
 ```
 public func next() async -> Order? {
    return await withTaskCacncellationHandler {
        let result = await kitchen.generateOrder()
        guard state.isRunning else { return nil }
        return result
    } onCancel: {
        state.cancel()
    }
 }
 ```
 
 Cannot guarentee order of operations on an actor
 
 ```
 private final class OrderState: Sendable {
    let protectedIsRunning = ManagedAtomic<Bool>(true)
    var isRunning: Bool {
        get { protectedIsRunning.load(ordering: .aquiring) }
        set { protectedIsRunning.store(newValue, ordering: .relaxed) }
    }
 
    func cancel() {
        isRunning = false
    }
 }
 ```
 
 ## `WithDiscardingTaskGroup`
 
 do not hold onto anything when discarded
 
 `withDiscardingTaskGroup { group in group.addTask() }
 `withThrowingDiscardingTaskGroup { group in group.addTask() }
 
 ```
 func run() async throws {
    try await withThrowingDiscardingTaskGroup { group in
        for cook in staff.keys {
            group.addTask { try await cook.handleShif() }
        }
 
        group.addTask {
            try await Task.sleep(for: shiftDuration)
            throw TimeToCloseError()
        }
    }
 }
 ```
 
 Everything cancells if one cancells
 
 ## TAsk Local Values

 */

actor Kitchen {
   @TaskLocal static var orderID: Int?
   @TaskLocal static var cook: String?

   func logStatus() {
       print("Current Cook: \(Kitchen.cook ?? "none")")
   }
}

let kitchen = Kitchen()
await kitchen.logStatus()
await Kitchen.$cook.withValue("Sakura") {
    await kitchen.logStatus()
}
await kitchen.logStatus()
print("EOF")

/*:
 ```
let orderMetadataProvider = Logger.MetadataProvider {
    var metadata: Logger.Metadata = [:]
    if let orderID = Kitchen.orderID {
        metadata["orderID"] = "\(orderID)"
    }
    return metadata
 }
 ```
 
 ```
 let chefMetadataPRovider = Logger.MetadataProvider {
    var metadata: Logger.Metadata = [:]
    if let chef = Kitchen.chef {
        metadata["chef"] = "\(chef)"
    }
    return metadata
 }
 
 let metadataProvider = Logger.MetdataProvider.multiplex([orderMetadaProvider, chefMetadataProvider])
 LoggingSystem.bootstrap(StreamLogHandler.standardOutput, metadataProvider: metadataProvider)
 let logger = Logger(label: "KitchenService")
 
 func makeSoup(order: Order) async throws -> Soup {
    logger.info("Preparing Soup Order")
    async let pot = stove.boilBroth()
    async let choppedIngredients = chopIngredient(order.ingredients)
    async let meat = marinate(meat: .chicken)
    let soup = try await Soup(meat: meat, ingredients: choppedIngredients)
    return try await stove.cook(pot: pot, soup: soup, duration: .minutes(10))
 }
 ```
 */

//: ## Swift Distributed Tracing
/*:
 ```
 import Tracing
 
 func makeSoup(order: Order) async throws -> Soup {
    try await withSpan("makeSoup(\(order.id)") { span in
        async let pot = stove.boilBroth()
        async let choppedIngredients = chopIngredient(order.ingredients)
        async let meat = marinate(meat: .chicken)
        let soup = try await Soup(meat: meat, ingredients: choppedIngredients)
        return try await stove.cook(pot: pot, soup: soup, duration: .minutes(10))
    }
 }
 ```
 ```
 import Tracing
 
 func makeSoup(order: Order) async throws -> Soup {
    try await withSpan(#function) { span in
        span.attributes["kitchen.order.id"] = order.id
        async let pot = stove.boilBroth()
        async let choppedIngredients = chopIngredient(order.ingredients)
        async let meat = marinate(meat: .chicken)
        let soup = try await Soup(meat: meat, ingredients: choppedIngredients)
        return try await stove.cook(pot: pot, soup: soup, duration: .minutes(10))
    }
 }
 ```
 */
