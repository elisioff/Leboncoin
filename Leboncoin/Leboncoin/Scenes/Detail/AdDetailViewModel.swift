//
//  AdDetailViewModel.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 07/04/2025.
//

import Combine
import UIKit

protocol AdDetailViewModelProtocol: ObservableObject {
    var observableImage: Published<UIImage?>.Publisher { get }

    func adDetails() -> [AttributedString]
}

final class AdDetailViewModel: AdDetailViewModelProtocol {
    var observableImage: Published<UIImage?>.Publisher { $image }
    @Published var image: UIImage?
    private var ad: AdFullModel
    private var category: String
    private let networkManager: NetworkManagerProtocol

    init(ad: AdFullModel,
         category: String,
         networkManager: NetworkManagerProtocol) {
        self.ad = ad
        self.category = category
        self.networkManager = networkManager
    }
}

// MARK: Public
extension AdDetailViewModel {
    func adDetails() -> [AttributedString] {
        var result: [AttributedString?] = []

        if ad.isUrgent {
            var isUrgent = AttributedString("Urgent")
            isUrgent.font = .bold(.body)()
            isUrgent.foregroundColor = .red
            result.append(isUrgent)
        }

        var title = AttributedString("\(ad.title)")
        title.font = .headline
        result.append(title)

        result.append(AttributedString(ad.description))
        result.append(try? AttributedString(markdown: "**\(category)**"))

        // ID & Data
        result.append(AttributedString("Id: \(ad.id)"))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: ad.creationDate) {
            result.append(try? AttributedString(markdown: "**Created:** \(date)"))
        }

        return result.compactMap(\.self)
    }
}

// MARK: Private
extension AdDetailViewModel {
    func fetchImage() {
        guard let url = ad.imagesUrl.small else { return }

        Task.detached {
            self.image = try? await self.networkManager.fetchImageWith(url: url)
        }
    }
}
