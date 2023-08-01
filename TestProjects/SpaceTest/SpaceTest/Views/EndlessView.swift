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
                ForEach(Array(viewModel.photos.enumerated()), id: \.offset) { index, item in
                    PhotoView<AstronomyPicOfTheDay>(photo: item)
                        .listRowSeparator(.hidden)
                        .onAppear {
                            if index == viewModel.photos.count - 1 {
                                viewModel.updateCount()
                            }
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
        let photoSequence = AsyncPhotoOfTheDaySequence()
        @Published var photos: [AstronomyPicOfTheDay] = []

        func updateCount() {

            Task {
                await fetchPhotos()
            }
        }
        
        func fetchPhotos() async {
            for await photo in photoSequence.dropFirst(photos.count).prefix(10) {
                photos.append(photo)
            }
        }
        
    }
}
