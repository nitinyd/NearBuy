//
//  APIManager.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}
}

extension APIManager {
    func getRequest(_ delegate: APIModelProtocol) {
        let params = delegate.getParams()
        let endpoint = delegate.getApiEndpoint()
        let urlRequest = NetworkingUtil.constructAPIRequest(endpoint: endpoint, params: params)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            else {
                if let error = error {
                    delegate.fetchFailure(with: error, for: params)
                    return
                } else {
                    let message = ["msg": "Invalid Data"]
                    let error = NSError(domain: "Error", code: -1, userInfo: message)
                    delegate.fetchFailure(with: error, for: params)
                }
                return
            }
            
            DispatchQueue.main.async {
                delegate.parse(json: json, params: params)
                do {
                    try delegate.parse(data: data, params: params)
                } catch let parsingError {
                    delegate.fetchFailure(with: parsingError, for: params)
                }
                delegate.fetchSuccess(for: params)
            }
        }
        task.resume()
    }
}
