//
//  NetworkingUtil.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation

struct NetworkingUtil {
//https://api.seatgeek.com/2/venues?per_page=10&page=1&client_id=Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5&lat=12.971599&lon=77.594566&range=12mi&q=
    static func constructAPIRequest(endpoint: String, params: [String: Any]) -> URLRequest {
        var urlString = "https://\(endpoint)?"
        
        for element in params {
            urlString.append("&\(element.key)=\(element.value)")
        }
        
        return URLRequest(url: URL(string: urlString)!)
    }
}
