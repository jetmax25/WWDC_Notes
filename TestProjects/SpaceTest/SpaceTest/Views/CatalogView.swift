//
//  CatalogView.swift
//  SpaceTest
//
//  Created by Michael Isasi on 7/31/23.
//

import SwiftUI

struct CatalogView: View {
    @StateObject private var photos = Photos<AstronomyPicOfTheDay>(photoSource: AstronomyPicOfTheDayPhotoFetcher())

    var body: some View {
        NavigationView {
            List {
                ForEach(photos.items) { item in
                    PhotoView<AstronomyPicOfTheDay>(photo: item)
                        .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Recent")
            .listStyle(.plain)
            .refreshable {
                await photos.updateItems()
            }
        }
        .task {
            await photos.updateItems()
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}
