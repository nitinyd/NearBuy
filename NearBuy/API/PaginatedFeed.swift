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
            delegate?.fetchSuccess(for: params)
            currentPage = currentPage + 1
        case .contentOver:
            delegate?.fetchSuccess(for: params)
            currentPage = currentPage + 1
        case .error(let error):
            delegate?.fetchFailure(with: error, for: params)
        case .unknown:
            let message = ["msg": "No Response from Server"]
            let error = NSError(domain: "Error", code: -1, userInfo: message)
            delegate?.fetchFailure(with: error, for: params)
        }
    }
}

extension PaginatedFeed {
    enum Page {
        case first, next
    }
}
