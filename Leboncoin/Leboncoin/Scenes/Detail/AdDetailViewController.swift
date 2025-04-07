//
//  AdDetailViewController.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 07/04/2025.
//

import UIKit

final class AdDetailViewController: UIViewController {
    private let detailView: AdDetailView

    init(viewModel: AdDetailViewModelProtocol) {
        self.detailView = AdDetailView(viewModel: viewModel)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
