//
//  RestaurantViewModel.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

class RestaurantViewModel: PaginatedFeed {
    
    var currentVenueList: [Venue] {
        if isSearching {
            return searchedVenueList
        } else {
            return fetchedVenueList
        }
    }
    
    private(set) var fetchedVenueList: [Venue] = []
    private(set) var searchedVenueList: [Venue] = []
    private var venueDataManager = VenueDataManager()
    private var isSearching = false
    
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
    
    override func removeOldData() {
        super.removeOldData()
        fetchedVenueList.removeAll()
    }
    
    override func fetch(page: PaginatedFeed.Page) {
        if apiInProgress { return }
        if page == .first {
            self.removeOldData()
        }
        super.fetch(page: page)
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
        if currentPage == 1 {
            venueDataManager.deleteAll()
            venueDataManager.updateVenues(venues: fetchedVenueList)
        }
    }
    
    func populateLocalData() {
        fetchedVenueList = venueDataManager.getAll() ?? []
    }
}

//Search
extension RestaurantViewModel {
    func search(for query: String) {
        if query.isEmpty {
            searchedVenueList = []
            isSearching = false
            return
        } else {
            isSearching = true
            searchedVenueList = fetchedVenueList.filter { venue in
                venue.name.contains(query)
            }
        }
    }
    
    func canFetchNextPage() -> Bool {
        return !self.apiInProgress && !self.isSearching  && self.status != .unknown && self.status != .contentOver
    }
}

//Slider
