//
//  NetworkManager.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import OSLog
import UIKit

protocol NetworkManagerProtocol {
    func fetchAdds() async throws -> [AdFullModel]
    func fetchImageWith(url urlString: String) async throws -> UIImage
}

final class NetworkManager: NetworkManagerProtocol {
    private enum Constants {
        static let adsURL = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
        static let categoriesURL = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
    }

    private var images: [String: UIImage] = [:]

    func fetchAdds() async throws -> [AdFullModel] {
        guard let url = URL(string: Constants.adsURL) else { throw NetworkError.invalidUrlString }

        do {
            let data = try await URLSession.shared.data(from: url).0
            return try JSONDecoder().decode([AdFullModel].self, from: data)
        } catch {
            throw NetworkError.invalidData
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
            let imageData = try await URLSession.shared.data(from: url).0
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
