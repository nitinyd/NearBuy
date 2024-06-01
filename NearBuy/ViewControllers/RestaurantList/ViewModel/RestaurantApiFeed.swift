//
//  RestaurantApiFeed.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

protocol RestaurantApiFeedProtocol: PaginatedFeed {
    func getVenueList() -> [Venue]
}

class RestaurantApiFeed: PaginatedFeed, RestaurantApiFeedProtocol {
    private var fetchedVenueList: [Venue] = []
    
    override func removeOldData() {
        super.removeOldData()
        fetchedVenueList.removeAll()
    }
    
    override func getApiEndpoint() -> String {
        return "api.seatgeek.com/2/venues"
    }
    
    override func getParams() -> [String : Any] {
        let perPage = currentPage == 1 ? 10 : 10
        return ["page": "\(currentPage)",
                "per_page": perPage,
                "client_id": "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5",
                "lat":"12.971599",
                "lon": "77.594566",
                "range": "12mi"]
    }
    
    override func parse(data: Data, params: [String : Any]) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        let decodedData = try decoder.decode(VenueList.self, from: data)
        
        lastPageIndexes.removeAll()
        if decodedData.venues.isEmpty {
            status = .contentOver
            return
        }
        let oldCellCount = fetchedVenueList.count
        fetchedVenueList.append(contentsOf: decodedData.venues)
        for index in oldCellCount..<fetchedVenueList.count {
            let indexPath = IndexPath(item: index, section: 0)
            lastPageIndexes.append(indexPath)
        }
    }
    
    func getVenueList() -> [Venue] {
        return fetchedVenueList
    }
}
