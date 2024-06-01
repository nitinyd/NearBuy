//
//  RestaurantViewModel.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

protocol RestaurantViewModelProtcol: AnyObject {
    func fetchSuccess(for params: [String: Any])
    func fetchFailure(with error: Error, for params: [String: Any])
}

class RestaurantViewModel: APIResultProtocol {
    var currentVenueList: [Venue] {
        if isSearching {
            return searchedVenueList
        } else {
            return fetchedVenueList
        }
    }
    weak var delegate: RestaurantViewModelProtcol?
    private(set) var fetchedVenueList: [Venue] = []
    private(set) var searchedVenueList: [Venue] = []
    private var isSearching = false
    
    private var apiFeed: RestaurantApiFeedProtocol!
    private var venueDataManager: VenueDataManager!
    
    init(apiFeed: RestaurantApiFeedProtocol, dataManager: VenueDataManager) {
        self.apiFeed = apiFeed
        self.venueDataManager = dataManager
        self.apiFeed.delegate = self
    }
    
    func fetch(page: PaginatedFeed.Page) {
        if apiFeed.apiInProgress { return }
        if page == .first {
            fetchedVenueList.removeAll()
        }
        apiFeed.fetch(page: page)
    }
    
    func getLastPageIndexes() -> [IndexPath] {
        return apiFeed.lastPageIndexes
    }
    
    func isFirstPage() -> Bool {
        return apiFeed.currentPage == 1
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
        return !self.apiFeed.apiInProgress && !self.isSearching  && self.apiFeed.status != .unknown && self.apiFeed.status != .contentOver
    }
}

//API
extension RestaurantViewModel {
    func fetchSuccess(for params: [String : Any]) {
        if apiFeed.currentPage == 1 {
            venueDataManager.deleteAll()
        }
        venueDataManager.updateVenues(venues: apiFeed.getVenueList())
        fetchedVenueList = apiFeed.getVenueList()
        delegate?.fetchSuccess(for: params)
    }
    
    func fetchFailure(with error: any Error, for params: [String : Any]) {
        delegate?.fetchFailure(with: error, for: params)
    }
}
