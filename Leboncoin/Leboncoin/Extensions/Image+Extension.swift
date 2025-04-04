//
//  Image+Extension.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import SwiftUI

extension Image {
    private enum Constants {
        static let placeholderImageName: String = "cart"
    }
    
    static var placeholder: some View {
        Image(systemName: Constants.placeholderImageName)
            .resizable()
    }
}
