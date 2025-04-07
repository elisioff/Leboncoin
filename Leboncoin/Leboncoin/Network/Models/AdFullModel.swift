//
//  AdFullModel.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import Foundation

protocol AdSimpleModel: Identifiable, Hashable {
    var id: Int { get }
    var imagesUrl: ImageModel { get }
    var categoryId: Int { get }
    var title: String { get }
    var price: Double { get }
    var isUrgent: Bool { get }
}

struct AdFullModel: Decodable, AdSimpleModel {
    let id: Int
    let title: String
    let categoryId: Int
    let creationDate: String
    let description: String
    let isUrgent: Bool
    let imagesUrl: ImageModel
    let price: Double
    let siret: String?
}

struct ImageModel: Decodable, Hashable {
    let small: String?
    let thumb: String?
}
