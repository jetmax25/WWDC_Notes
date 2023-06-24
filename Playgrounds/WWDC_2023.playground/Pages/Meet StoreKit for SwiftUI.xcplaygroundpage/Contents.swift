//: [Previous](@previous)
//: ## Meet Storekit for SwiftUI
//: [Link](https://developer.apple.com/videos/play/wwdc2023/10013/)
//: [Sample](https://developer.apple.com/documentation/SwiftUI/Backyard-birds-sample)

import Foundation

//: `StoreView` with id's autosets a list

//: `ProductView` for single id product
//: `.productViewStyle(.large)

//: `SubscriptoinStoreView(groupID: )` shows full subscription

/*:
 ```
 .onInAppPurchaseCompletion { product, result in
 if case .sucess(.sucess(let transaction)) = result {
    await BirdBrain.shared.process(transaction: transaction)
 dismiss()
 }
 }
 ```
 
 Handle Purchase Starting
 ```
 BirdFoodShop()
    .onInAppPurchaseStart { (product: Product) in
        self.isPurchasing = true
 }
 */
//: [Next](@next)
