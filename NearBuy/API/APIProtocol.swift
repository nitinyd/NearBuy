//
//  APIProtocol.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

protocol APIResultProtocol: AnyObject {
    func fetchSuccess(for params: [String: Any])
    func fetchFailure(with error: Error, for params: [String: Any])
}

protocol APIModelProtocol: APIResultProtocol {
    func getApiEndpoint() -> String
    func getParams() -> [String: Any]
    func parse(json: [Any], params: [String: Any])
    func parse(data: Data, params: [String: Any]) throws
}
