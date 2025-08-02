//
//  OTNetworkService.swift
//  OneThing
//
//  Created by 윤동주 on 3/15/25.
//

import Foundation

class OTNetworkService: APIService {
    func get<T>(endpoint: EndPoint) async throws -> T where T : Decodable {
        try await APIClient.shared.getRequest(endpoint: endpoint)
    }
    
    func get<T, U>(endpoint: EndPoint, body: U) async throws -> T where T: Decodable, U: Encodable {
        try await APIClient.shared.getRequest(endpoint: endpoint, body: body)
    }
    
    func post<T, U>(endpoint: EndPoint, body: U) async throws -> (T, HTTPURLResponse) where T : Decodable, U : Encodable {
        try await APIClient.shared.postRequest(endpoint: endpoint, body: body)
    }
    
    func post<U>(endpoint: EndPoint, body: U) async throws -> HTTPURLResponse where U : Encodable {
        try await APIClient.shared.postRequest(endpoint: endpoint, body: body)
    }
    
    func patch<U>(endpoint: EndPoint, body: U) async throws -> HTTPURLResponse where U : Encodable {
        let response = try await APIClient.shared.patchRequest(endpoint: endpoint, body: body) as HTTPURLResponse
        return response
    }
    
    func patch(endpoint: EndPoint) async throws -> HTTPURLResponse {
        let response = try await APIClient.shared.patchRequest(endpoint: endpoint) as HTTPURLResponse
        return response
    }
    
    func delete(endpoint: EndPoint) async throws -> HTTPURLResponse {
        let response = try await APIClient.shared.deleteRequest(endpoint: endpoint) as HTTPURLResponse
        return response
    }
}

struct EmptyResponse: Decodable {}
