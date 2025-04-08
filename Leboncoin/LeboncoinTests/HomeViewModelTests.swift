//
//  HomeViewModelTests.swift
//  HomeViewModelTests
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import Testing
import UIKit

@testable import Leboncoin

struct HomeViewModelTests {
    // MARK: - Fetch
    @Test func fetchAllAdsSuccess() async throws {
        let networkManager = NetworkManagerTest()

        networkManager.categoriesValue = CategoryModel.sampleArray
        networkManager.adsValue = AdFullModel.sampleArray

        let homeViewModel = HomeViewModel(networkManager: networkManager)
        await homeViewModel.initialTask()

        #expect(homeViewModel.ads.count == 2)
        #expect(homeViewModel.categories.count == 2)
        #expect(homeViewModel.viewState == .loaded)
    }

    @Test func fetchAllAdsSuccessNoCategories() async throws {
        let networkManager = NetworkManagerTest()

        networkManager.adsValue = AdFullModel.sampleArray

        let homeViewModel = HomeViewModel(networkManager: networkManager)
        await homeViewModel.initialTask()

        #expect(homeViewModel.ads.count == .zero)
        #expect(homeViewModel.categories.count == .zero)
        #expect(homeViewModel.viewState == .loadedNoItems)
    }

    @Test func fetchAllAdsSuccessNoAds() async throws {
        let networkManager = NetworkManagerTest()

        networkManager.categoriesValue = CategoryModel.sampleArray

        let homeViewModel = HomeViewModel(networkManager: networkManager)
        await homeViewModel.initialTask()

        #expect(homeViewModel.ads.count == .zero)
        #expect(homeViewModel.categories.count == .zero)
        #expect(homeViewModel.viewState == .loadedNoItems)
    }

    // MARK: - Categories
    @Test func fetchImageSuccess() async {
        let networkManager = NetworkManagerTest()
        networkManager.returnsImage = true

        let homeViewModel = HomeViewModel(networkManager: networkManager)

        #expect(await homeViewModel.fetchImageWith(url: "www.google.com") != nil)
    }

    @Test func fetchImageFailure() async {
        let networkManager = NetworkManagerTest()
        networkManager.returnsImage = false

        let homeViewModel = HomeViewModel(networkManager: networkManager)

        #expect(await homeViewModel.fetchImageWith(url: "www.google.com") == nil)
    }

    // MARK: - Categories
    @Test(arguments: CategoryModel.sampleArray)
    func testCanFind(category: CategoryModel) async {
        let networkManager = NetworkManagerTest()

        networkManager.categoriesValue = CategoryModel.sampleArray
        networkManager.adsValue = AdFullModel.sampleArray

        let homeViewModel = HomeViewModel(networkManager: networkManager)
        await homeViewModel.initialTask()

        #expect(homeViewModel.category(with: category.id) != nil)
    }

    // MARK: - DetailViewModel
    @Test func detailViewModelSuccess() async {
        let networkManager = NetworkManagerTest()

        networkManager.categoriesValue = CategoryModel.sampleArray
        networkManager.adsValue = AdFullModel.sampleArray

        let homeViewModel = HomeViewModel(networkManager: networkManager)
        await homeViewModel.initialTask()

        print(homeViewModel.categories.keys)
        #expect(homeViewModel.detailViewModel(for: AdFullModel.sampleUrgent) != nil)
    }

    @Test func detailViewModelFailure() async {
        let networkManager = NetworkManagerTest()

        networkManager.categoriesValue = CategoryModel.sampleArray
        networkManager.adsValue = AdFullModel.sampleArray

        let homeViewModel = HomeViewModel(networkManager: networkManager)
        await homeViewModel.initialTask()

        let nonExistingAd: AdFullModel = .init(
            id: 4,
            title: "",
            categoryId: 3,
            creationDate: "",
            description: "",
            isUrgent: true,
            imagesUrl: .init(small: nil, thumb: nil),
            price: 0,
            siret: nil
        )
        #expect(homeViewModel.detailViewModel(for: nonExistingAd) == nil)
    }
}

// MARK: - NetworkManager Mock
class NetworkManagerTest: NetworkManagerProtocol {
    var adsValue: [AdFullModel]?
    var categoriesValue: [CategoryModel]?
    var returnsImage: Bool = true

    func fetchAllAds() async throws -> [AdFullModel] {
        if let result = adsValue {
            return result
        }

        return []
    }

    func fetchAllCategories() async throws -> [CategoryModel] {
        if let result = categoriesValue {
            return result
        }

        return []
    }

    func fetchImageWith(url: String) async throws -> UIImage {
        if !returnsImage {
            throw NetworkError.noImage
        }

        if let image = UIImage(systemName: GlobalConstants.placeholderImageName)  {
            return image
        } else {
            throw NetworkError.noImage
        }
    }
}

// MARK: - Data Mock
// MARK: CategoryModel Mock
extension CategoryModel {
    static var sample1: Self {
        .init(id: 1, name: "Sample")
    }

    static var sample2: Self {
        .init(id: 2, name: "Sample 2")
    }

    static var sampleArray: [Self] {
        [
            .sample1,
            .sample2
        ]
    }
}

// MARK: AdFullModel Mock
extension AdFullModel {
    static var sampleArray: [Self] {
        [.sampleUrgent, .sampleNotUrgent]
    }
}
