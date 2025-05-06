//
//  EndPoint.swift
//  OneThing
//
//  Created by 윤동주 on 3/15/25.
//

import Foundation

struct EndPoint {
    var path: String
    var method: HTTPMethod
    var headers: [String: String]
    var queryItems: [URLQueryItem] = []
    
    var url: URL? {
        var components = URLComponents()
        
        components.scheme = "http"
        components.host = "43.201.134.184"
        components.port = 8080
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        components.percentEncodedQuery = components.percentEncodedQuery?
                    .replacingOccurrences(of: "+", with: "%2B")
        
        return components.url
    }
}
