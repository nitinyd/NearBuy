//
//  VenueModel.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

struct VenueList: Decodable {
    let venues: [Venue]
}

struct Venue: Decodable {
    let name: String
    let id: Int
    let displayLocation: String

    enum CodingKeys: String, CodingKey {
        case name, id
        case displayLocation = "display_location"
    }
}
