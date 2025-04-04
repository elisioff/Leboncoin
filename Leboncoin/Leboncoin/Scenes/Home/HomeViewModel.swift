//
//  HomeViewModel.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import UIKit

// MARK: Protocol
protocol HomeViewModelProtocol: ObservableObject {
    var viewState: ViewState { get }
    var ads: [any AdSimpleModel] { get }

    func initialTask() async
    func fetchImageWith(url: String) async -> UIImage?
    func category(with id: Int) -> String?
}

// MARK: ViewModel
final class HomeViewModel: HomeViewModelProtocol {
    @Published private(set) var viewState: ViewState = .idle
    @Published private(set) var ads: [any AdSimpleModel] = []
    
    private var networkManager: NetworkManagerProtocol
    private var categories: [Int: String] = [:]

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

// MARK: Public
extension HomeViewModel {
    func initialTask() async {
        guard self.viewState == .idle else { return }

        await fetchAllAds()
    }

    func fetchImageWith(url: String) async -> UIImage? {
        do {
            return try await networkManager.fetchImageWith(url: url)
        } catch {
            return nil
        }
    }

    func category(with id: Int) -> String? {
        self.categories[id]
    }
}

// MARK: Private
private extension HomeViewModel {
    func fetchAllAds() async {
        await MainActor.run {
            viewState = .loading
        }

        do {
            async let categoriesResult = try networkManager.fetchAllCategories()
            async let adsResult = try networkManager.fetchAllAds()

            let result = try await (categoriesResult, adsResult)

            guard result.0.count > .zero,
                  result.1.count > .zero else { throw NetworkError.invalidData }

            self.updateCategories(result.0)

            await MainActor.run {
                self.ads = result.1
                self.viewState = .loaded
            }
        } catch {
            await MainActor.run {
                self.viewState = .loadedNoItems
            }
        }
    }

    func updateCategories(_ categories: [CategoryModel]) {
        self.categories = categories.reduce(into: [:]) { result, item in
            result.updateValue(item.name, forKey: item.id)
        }
    }
}
