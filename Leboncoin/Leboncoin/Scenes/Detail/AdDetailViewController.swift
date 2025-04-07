//
//  AdDetailViewController.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 07/04/2025.
//

import UIKit

final class AdDetailViewController: UIViewController {
    private let detailView: AdDetailView

    init(viewModel: any AdDetailViewModelProtocol) {
        self.detailView = AdDetailView(viewModel: viewModel)

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AdDetailViewController {
    func setupSubviews() {
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)

        detailView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
