//
//  EndlessView.swift
//  SpaceTest
//
//  Created by Michael Isasi on 8/1/23.
//

import SwiftUI

struct EndlessView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(0..<2), id: \.self) { index in
                    Group {
                        if let photo = viewModel.photoForIndex(index) {
                            PhotoView<AstronomyPicOfTheDay>(photo: photo)
                                .listRowSeparator(.hidden)
                        } else {
                            ProgressView()
                                .frame(height: 400)
                        }
                    }.onAppear {
                        viewModel.checkAction(for: index)
                    }
                }
            }
            .navigationTitle("Recent")
            .listStyle(.plain)
        }.task {
            await viewModel.fetchPhotos()
        }
    }

    @MainActor
    class ViewModel: ObservableObject {
        enum Const {
            static let memorySize = 2
        }
        let photoSequence = AsyncPhotoOfTheDaySequence()
        
        @Published var inMemoryPhotos = [Int: AstronomyPicOfTheDay]()
        @Published var topValue = Const.memorySize
        
        var offset = 0 {
            didSet {
                topValue = max(topValue, offset + Const.memorySize)
            }
        }

        func increaseOffset() {
            offset += Const.memorySize
            Task {
                await fetchPhotos()
            }
        }
        
        func decreaseOffset() {
            if offset > Const.memorySize {
                offset -= Const.memorySize
            }
            Task {
                await fetchPhotos()
            }
        }
        
        func photoForIndex(_ index: Int) -> AstronomyPicOfTheDay? {
            print("Index: \(index) HasImage \(inMemoryPhotos[index] != nil)")
            return inMemoryPhotos[index]
        }
        
        func checkAction(for index: Int) {
            print("offset \(offset) top \(topValue) index: \(index)")
//            if index == topValue - 1 {
//                increaseOffset()
//            }
//
//            if index == offset {
//                decreaseOffset()
//            }
        }
        
        func fetchPhotos() async {
            var index = 0
            //inMemoryPhotos = [:]
            print("Fetching photos \(offset)")
            for await photo in photoSequence.dropFirst(offset).prefix(Const.memorySize) {
                defer{ index += 1 }
                print("adding \(offset + index)")
                inMemoryPhotos[offset + index] = photo
            }
        }
        
    }
}
