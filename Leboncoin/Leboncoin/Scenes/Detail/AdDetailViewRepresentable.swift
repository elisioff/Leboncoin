//
//  AdDetailViewRepresentable.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 07/04/2025.
//

import SwiftUI

struct AdDetailViewRepresentable: UIViewControllerRepresentable {
    var  viewModel: (any AdDetailViewModelProtocol)?

    func makeUIViewController(context: Context) -> some UIViewController {
        if let viewModel {
            AdDetailViewController(viewModel: viewModel)
        } else {
            UIViewController()
        }
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: Context) { }
}

#Preview {
    AdDetailViewRepresentable(
        viewModel: AdDetailViewModel(
            ad: AdFullModel.sampleUrgent,
            category: "Mode",
            networkManager: NetworkManager(
                networkAPI: NetworkAPI()
            )
        )
    )
}
