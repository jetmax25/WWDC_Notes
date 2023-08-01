//
//  SpacePhotoFetcher.swift
//  SpaceTest
//
//  Created by Michael Isasi on 7/31/23.
//

import Foundation


protocol SpacePhotoFetcherProtocol {
    func lastPhotos(count: Int) async throws -> [AstronomyPicOfTheDay]
    func photoForDate(_ date: Date) async throws -> AstronomyPicOfTheDay
}

struct AstronomyPicOfTheDayPhotoFetcher {
    private let plistBuilder = PListURLBuilder()
    
    let dateFormatter: DateFormatter
    var jsonDecoder: JSONDecoder
    
    init() {
        let dateFormatter = {
            let _dateFormatter = DateFormatter()
            _dateFormatter.dateFormat = "yyyy-MM-dd"
            return _dateFormatter
        }()
        
        self.dateFormatter = dateFormatter
        
        jsonDecoder = {
            let _jsonDecoder = JSONDecoder()
            _jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            return _jsonDecoder
        }()
    }
}

extension AstronomyPicOfTheDayPhotoFetcher: SpacePhotoFetcherProtocol {
    
    func photoForDate(_ date: Date) async throws -> AstronomyPicOfTheDay {
        let result = plistBuilder.createURL(parameters: ["date": dateFormatter.string(from: date)])
        switch result {
        case let .success(url):
            print(url.absoluteString)
            let (data, _) = try await URLSession.shared.data(from: url)
            let picture = try jsonDecoder.decode(AstronomyPicOfTheDay.self, from: data)
            return picture
        case let .failure(error): throw error
        }
    }
    
    func lastPhotos(count: Int) async throws -> [AstronomyPicOfTheDay] {
        let urlResult = plistBuilder.createURL(parameters: ["count": count])
        switch urlResult {
        case let .success(url):
            let (data, _) = try await URLSession.shared.data(from: url)
            let pictures = try jsonDecoder.decode([AstronomyPicOfTheDay].self, from: data)
            return pictures
        case let .failure(error): throw error
        }
    }
}

class SpacePhotoFetcher {
    private let photoSource: SpacePhotoFetcherProtocol
    
    static let standard = SpacePhotoFetcher(photoSource: AstronomyPicOfTheDayPhotoFetcher())
    
    init(photoSource: SpacePhotoFetcherProtocol) {
        self.photoSource = photoSource
    }
    
    func lastPhotos(count: Int) async throws -> [some SpacePhotoProtocol] {
        try await photoSource.lastPhotos(count: count)
    }
    
    func photoForDate(_ date: Date) async throws -> some SpacePhotoProtocol {
        try await photoSource.photoForDate(date)
    }
}

enum PListError: Error {
    case fileNotFound
    case dataNotFound
    case badTranform
}

struct PListURLBuilder {
    enum Constants {
        static let fileName = "AstronomyPicOfTheDay"
        static let fileType = "plist"
    }
    
    var astrnomyURLInfo: AstronomyURL {
        get throws {
            do {
                guard let path = Bundle.main.path(forResource: Constants.fileName, ofType: Constants.fileType) else {
                    throw PListError.fileNotFound
                }
                let data = try Data(contentsOf: URL(filePath: path))
                let astronomyURLInfo = try PropertyListDecoder().decode(AstronomyURL.self, from: data)
                return astronomyURLInfo
            } catch(let error) {
                throw error
            }
        }
    }
    
    func createURL(parameters: [String: LosslessStringConvertible]) -> Result<URL, PListError> {
        guard let astronomyInfo = try? astrnomyURLInfo else {
            return .failure(.fileNotFound)
        }
        let astroComponents = astronomyInfo.astroComponents
        
        var components = URLComponents()
        components.scheme = astroComponents.scheme
        components.path = astroComponents.path
        components.host = astroComponents.host
        
        components.queryItems = parameters.map {
            .init(name: $0.key, value: "\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        }
        components.queryItems?.append(.init(name: "api_key", value: astronomyInfo.apiKey))
        if let url = components.url {
            return .success(url)
        } else {
            return .failure(.badTranform)
        }
    }
}
