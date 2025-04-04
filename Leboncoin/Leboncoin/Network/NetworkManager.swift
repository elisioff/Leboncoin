//
//  NetworkManager.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import OSLog
import SwiftUI
import UIKit

protocol NetworkManagerProtocol {
    func fetchAllAds() async throws -> [AdFullModel]
    func fetchAllCategories() async throws -> [CategoryModel]
    func fetchImageWith(url urlString: String) async throws -> UIImage
}

final actor NetworkManager: NetworkManagerProtocol {
    private enum Constants {
        static let adsURL = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
        static let categoriesURL = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
    }

    private var images: [String: UIImage] = [:]
    private var networkAPI: NetworkAPIFacade

    init(networkAPI: NetworkAPIFacade) {
        self.networkAPI = networkAPI
    }

    func fetchAllAds() async throws -> [AdFullModel] {
        guard let url = URL(string: Constants.adsURL) else { throw NetworkError.invalidUrlString }

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let data = try await networkAPI.fetch(url)

            return try jsonDecoder.decode([AdFullModel].self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }

    func fetchAllCategories() async throws -> [CategoryModel] {
        guard let url = URL(string: Constants.categoriesURL) else { throw NetworkError.invalidUrlString }

        do {
            let data = try await networkAPI.fetch(url)

            return try JSONDecoder().decode([CategoryModel].self, from: data)
        }
    }

    func fetchImageWith(url urlString: String) async throws -> UIImage {
        if let image = images[urlString] {
            return image
        }

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidUrlString
        }

        Logger().info("🏞️ RequestURL: \(urlString)")

        do {
            let imageData = try await networkAPI.fetch(url)
            
            if let uiImage = UIImage(data: imageData) {
                images[urlString] = uiImage
                return uiImage
            } else {
                throw NetworkError.noImage
            }
        } catch {
            throw NetworkError.noImage
        }
    }
}
