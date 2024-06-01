//
//  VenueDataManager.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

struct VenueDataManager {
    let repository = VenueDataRepository()
    
    func updateVenues(venues: [Venue]) {
        venues.forEach { venue in
            self.create(data: venue)
        }
    }
    
    func create(data: Venue) {
        repository.create(data: data)
    }
    
    func getAll() -> [Venue]? {
        return repository.getAll()
    }
    
    func deleteAll() {
        return repository.deleteAll()
    }
}
