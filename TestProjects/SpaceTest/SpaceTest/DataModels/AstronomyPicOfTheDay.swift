//
//  AstronomyPicOfTheDay.swift
//  SpaceTest
//
//  Created by Michael Isasi on 7/31/23.
//

import Foundation

protocol SpacePhotoProtocol: Identifiable {
    var title: String { get }
    var description: String { get }
    var date: Date { get }
    var url: URL { get }
}

extension SpacePhotoProtocol {
    var id: String {
        title
    }
    
    func save() async {
        sleep(1)
    }
}

struct AstronomyPicOfTheDay: Codable, Hashable {
    let copyright: String?
    let date: Date
    let explanation: String
    let service_version: String
    let hdurl: URL?
    let media_type: String
    let title: String
    let url: URL
}

extension AstronomyPicOfTheDay: SpacePhotoProtocol {
    var description: String {
        explanation
    }
}
