//
//  APIClient.swift
//  OneThing
//
//  Created by 윤동주 on 3/15/25.
//

import Foundation

class APIClient {
    
    static let shared  = APIClient()
    
    private init() {}
    
    func getRequest<T: Decodable>(endpoint: EndPoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidHttpStatusCode(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodeError
            }
        } catch {
            throw NetworkError.urlRequestFailed(description: error.localizedDescription)
        }
    }
    
    func postRequest<T: Decodable, U: Encodable>(endpoint: EndPoint, body: U) async throws -> (T, HTTPURLResponse) {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        urlRequest.httpBody = try JSONEncoder().encode(body)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return (decodedData, httpResponse)
        } catch {
            throw NetworkError.decodeError
        }
    }
    
    func postRequest<U: Encodable>(endpoint: EndPoint, body: U) async throws -> HTTPURLResponse {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        urlRequest.httpBody = try JSONEncoder().encode(body)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        return httpResponse
    }
    
    func patchRequest<U: Encodable>(endpoint: EndPoint, body: U) async throws -> HTTPURLResponse {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        urlRequest.httpBody = try JSONEncoder().encode(body)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        return httpResponse
    }
    
    func patchRequest(endpoint: EndPoint) async throws -> HTTPURLResponse {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        return httpResponse
    }
    
    func deleteRequest(endpoint: EndPoint) async throws -> HTTPURLResponse {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        return httpResponse
    }
}
