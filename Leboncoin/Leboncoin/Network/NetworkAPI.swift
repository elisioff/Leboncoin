//
//  NetworkAPI.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import Foundation

protocol NetworkAPIFacade {
    func fetch(_ request: URLRequest) async throws -> Data
}

final class NetworkAPI: NetworkAPIFacade {
    func fetch(_ request: URLRequest) async throws -> Data {
        try await URLSession.shared.data(for: request).0
    }
}
