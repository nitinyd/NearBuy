//
//  APIModel.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

class APIModel: APIModelProtocol {
    weak var delegate: APIResultProtocol?
    var apiInProgress: Bool = false
    var status: ResponseStatus = .unknown
    private(set) var originalJSON: [String: Any]?
    private(set) var originalData: Data?
    
    func getApiEndpoint() -> String { return "" }
    
    @objc func makeGetRequest() {
        apiInProgress = true
        APIManager.shared.getRequest(self)
    }
    
    func getParams() -> [String : Any] { return [:] }
    
    func parse(json: [String: Any], params: [String : Any]) {
        status = .success
        originalJSON = json
    }
    
    func parse(data: Data, params: [String : Any]) throws {
        originalData = data
    }
    
    func fetchSuccess(for params: [String : Any]) {
        apiInProgress = false
        
        switch status {
        case .success:
            delegate?.fetchSuccess(for: params)
        case .contentOver:
            delegate?.fetchSuccess(for: params)
        case .error(let error):
            delegate?.fetchFailure(with: error, for: params)
        case .unknown:
            let message = ["msg": "No Response from Server"]
            let error = NSError(domain: "Error", code: -1, userInfo: message)
            delegate?.fetchFailure(with: error, for: params)
        }
    }
    
    func fetchFailure(with error: any Error, for params: [String : Any]) {
        apiInProgress = false
        delegate?.fetchFailure(with: error, for: params)
    }
}

extension APIModel {
    enum ResponseStatus: Equatable {
        //Use this for error handling from API Side
        case success, error(with: NSError), contentOver, unknown
    }
}
