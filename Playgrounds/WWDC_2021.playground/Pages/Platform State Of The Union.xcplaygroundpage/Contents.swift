//: [Previous](@previous)

import Foundation
#if swift(>=5.5)
//: ## [Platform State of the Union](https://developer.apple.com/videos/play/wwdc2021/102/)

//: Pull requests are now in Xcode 13

//: ### Concurency
//:#### Async Await

func loadImage(at url: URL) async -> Image
let image = await loadImage(at: url)

func prepareForShow() async throws -> Scene {
    let dancers = try await danceCompany.warmUp(duration: .minutes(45))
    let scenery = await crew.fetchStageScenery()
    let openingScene = setStage(with: scenery)
    return try await dancers.moveToPosition(in: openingScene)
}

//: #### Structured Concurency
//: Use `async let` to allow concurency
async let dancers = try await danceCompany.warmUp(duration: .minutes(45))
async let scenery = await crew.fetchStageScenery()


//: #### Actors
//: Protects its own state by allowing exclusive access
//: `DispatchQueue`'s were inspired by actors

actor StageManager {
    var stage: Stage
    
    func setStage(with scenery: Scenery) -> Scene {
        stage.backdrop = scenery.backdrop
        for prop in scenery.props {
            stage.addProp(prop)
        }
        return stage.currentScene
    }
}
//: using externally uses async await to guarentee exclusion
let scene = await stageManager.setStage(with: scenery)


//: `@MainActor` attribute assures that code is always run on the main thread

//* ### Reality Kit 2
//: Capture objects using device

let session = try! PhotommetrySession(input: imagesURL)
try! session.process(requests: [.modelFile("model.usdz"), detail: .medium])

async {
    for try await output in session.outputs {
        
    }
}
//:[Next](@next)

#endif
