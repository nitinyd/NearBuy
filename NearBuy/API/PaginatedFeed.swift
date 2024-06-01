//
//  PaginatedFeed.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

protocol PaginatedFeedProtocol: APIResultProtocol {
    func removeOldData()
}

class PaginatedFeed: APIModel, PaginatedFeedProtocol {
    var lastPageIndexes: [IndexPath] = []
    var currentPage = 1
    var startPage = 1
    
    func fetch(page: Page) {
        switch page {
        case .first:
            self.removeOldData()
            status = .contentOver
            currentPage = startPage
        case .next:
            break
        }
        makeGetRequest()
    }
    
    func removeOldData() {
        lastPageIndexes.removeAll()
    }
    
    override func fetchSuccess(for params: [String : Any]) {
        apiInProgress = false
        
        switch status {
        case .success:
            currentPage = currentPage + 1
            delegate?.fetchSuccess(for: params)
        case .contentOver:
            currentPage = currentPage + 1
            delegate?.fetchSuccess(for: params)
        case .error(let error):
            delegate?.fetchFailure(with: error, for: params)
        }
    }
}

extension PaginatedFeed {
    enum Page {
        case first, next
    }
}
