//
//  VenueDataRepository.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation
import CoreData

protocol VenueDataRepositoryProtocol: BaseRepository {
    
}

struct VenueDataRepository: VenueDataRepositoryProtocol {
    typealias T = Venue
    
    func create(data: Venue) {
        let venueCD = VenueCD(context: VenuePersistentStorage.shared.context)
        venueCD.id = Int64(data.id)
        venueCD.name = data.name
        venueCD.displayLocation = data.displayLocation
        VenuePersistentStorage.shared.saveContext()
    }
    
    func getAll() -> [Venue]? {
        do {
            let allCDVenues = try VenuePersistentStorage.shared.context.fetch(VenueCD.fetchRequest())
            var allVenues: [Venue] = []
            allCDVenues.forEach { venueCD in
                allVenues.append(venueCD.convertToVenue())
            }
            return allVenues
        } catch {
            print(error)
        }
        return nil
    }
    
    func deleteAll() {
        VenuePersistentStorage.performOnBackground({
            context in
            let venuesDeleteRequest = VenueCD.deleteAll()
            _ = try? context.execute(venuesDeleteRequest)
        })
    }
}
