//
//  CategoryModel+Testing.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 08/04/2025.
//

import Foundation

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
