//
//  Image+Extension.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import SwiftUI

extension Image {
    static var placeholder: some View {
        Image(systemName: GlobalConstants.placeholderImageName)
            .resizable()
    }
}
