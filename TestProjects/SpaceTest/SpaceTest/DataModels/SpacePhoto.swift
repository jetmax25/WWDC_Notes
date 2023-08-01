//
//  SpacePhoto.swift
//  SpaceTest
//
//  Created by Michael Isasi on 7/31/23.
//

import Foundation
//
////Data Model
//

struct SpacePhoto: SpacePhotoProtocol {
    let title: String
    let description: String
    let date: Date
    let url: URL
}

extension SpacePhoto: Codable { }
