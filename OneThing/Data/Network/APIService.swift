//
//  APIService.swift
//  OneThing
//
//  Created by 윤동주 on 3/15/25.
//

import Foundation

protocol APIService {
    func get<T: Decodable>(endpoint: EndPoint) async throws -> T
    func post<T: Decodable, U: Encodable>(endpoint: EndPoint, body: U) async throws -> (T, HTTPURLResponse)
    func patch<U: Encodable>(endpoint: EndPoint, body: U) async throws -> HTTPURLResponse
}
