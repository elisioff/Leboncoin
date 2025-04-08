//
//  NetworkError.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import Foundation

enum NetworkError: Error {
    case noAds
    case noCategories
    case noImage
    case invalidUrlString
    case invalidData
}
