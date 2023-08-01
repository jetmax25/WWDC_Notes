//
//  AstronomyURL.swift
//  SpaceTest
//
//  Created by Michael Isasi on 7/31/23.
//

import Foundation

struct AstronomyURL: Codable {
    let urlRoot: String
    let apiKey: String
    let astroComponents: AstroComponents
}

struct AstroComponents: Codable {
    let scheme: String
    let path: String
    let host: String
}
