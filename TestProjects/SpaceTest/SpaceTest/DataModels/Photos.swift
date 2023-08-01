//
//  Photos.swift
//  SpaceTest
//
//  Created by Michael Isasi on 7/31/23.
//

import Foundation

fileprivate enum Constants {
    static let standardCount = 10
}

@MainActor
class Photos<Photo: SpacePhotoProtocol>: ObservableObject {
    @Published var items: [Photo]
    
    private let photoFetcher: SpacePhotoFetcher
    
    init(photoSource: SpacePhotoFetcherProtocol) {
        items = []
        self.photoFetcher = .init(photoSource: photoSource)
    }
    
    func updateItems() async {
        let fetched = try? await photoFetcher.lastPhotos(count: Constants.standardCount) as? [Photo]
        self.items = fetched ?? []
    }
    
    func fetchPhotos() async -> [Photo] {
        var downloaded: [Photo] = []
        for date in randomPhotoDates() {
            if let photo = try? await photoFetcher.photoForDate(date) as? Photo {
                downloaded.append(photo)
            }
        }
        return downloaded.sorted { $0.date > $1.date }
    }
    
    func fetchPhoto() async -> Photo? {
        try? await photoFetcher.lastPhotos(count: 1).first as? Photo
    }
    
    private func randomPhotoDates() -> [Date] {
        [.now]
    }
}
