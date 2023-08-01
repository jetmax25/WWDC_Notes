//
//  AsyncPhotoOfTheDaySequence.swift
//  SpaceTest
//
//  Created by Michael Isasi on 8/1/23.
//

import Foundation

class AsyncPhotoOfTheDaySequence: AsyncSequence {

    typealias Element = AstronomyPicOfTheDay
    
    struct AsyncIterator: AsyncIteratorProtocol {
        let fetcher = SpacePhotoFetcher(photoSource: AstronomyPicOfTheDayPhotoFetcher())
        
        private var currentDate: Date = Date.now
        
        mutating func next() async -> AstronomyPicOfTheDay? {
            defer { currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)! }
            
            if currentDate > Date.now {
                return nil
            } else {
                return try? await fetcher.photoForDate(currentDate) as? AstronomyPicOfTheDay
            }
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator()
    }
}
