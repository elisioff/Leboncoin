//
//  NetworkAPI.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import Foundation

protocol NetworkAPIFacade {
    func fetch(_ url: URL) async throws -> Data
}

final class NetworkAPI: NetworkAPIFacade {
    func fetch(_ url: URL) async throws -> Data {
        try await URLSession.shared.data(from: url).0
    }
}
