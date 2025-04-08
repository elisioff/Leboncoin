//
//  AdFullModel+Testing.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import Foundation

extension AdFullModel {
    static var sampleNotUrgent: Self {
        .init(
            id: 1701990485,
            title: "Livre - Artemis Fowl, Book 1",
            categoryId: 1,
            creationDate: "2019-11-05T20:00:43+0000",
            description: "Vends livre Artemis Fowl: Artemis Fowl, Book 1 de Eoin Colfer. - Tres bon etat - Edition reliee - ASIN: B01DKX3H7G",
            isUrgent: false,
            imagesUrl: .init(small: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/ff5a73fc4c3ff69aa3aa3513b0446f3bcf48b64a.jpg", thumb: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/ff5a73fc4c3ff69aa3aa3513b0446f3bcf48b64a.jpg"),
            price: 7.0,
            siret: nil
        )
    }

    static var sampleUrgent: Self {
        .init(
            id: 1,
            title: "Renault Twingo",
            categoryId: 2,
            creationDate: "2019-11-05T19:00:43+0000",
            description: "A brand new car",
            isUrgent: true,
            imagesUrl: .init(small: nil, thumb: nil),
            price: 100.0,
            siret: nil
        )
    }
}
