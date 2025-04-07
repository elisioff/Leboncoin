//
//  AdDetailView.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 07/04/2025.
//

import Combine
import UIKit

final class AdDetailView: UIView {
    enum Constants {
        static let verticalSpacing: CGFloat = 10
        static let stackViewInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let imageHeight: CGFloat = 300
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy private var isUrgentLabel: UILabel = {
        let isUrgentLabel = UILabel()
        isUrgentLabel.translatesAutoresizingMaskIntoConstraints = false
        isUrgentLabel.backgroundColor = .red
        isUrgentLabel.textColor = .white
        return isUrgentLabel
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.verticalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constants.stackViewInsets
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBackground

        return stackView
    }()
    private let viewModel: any AdDetailViewModelProtocol

    private var cancellable: AnyCancellable?

    init(viewModel: any AdDetailViewModelProtocol) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        self.setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
extension AdDetailView {
    func setupSubviews() {
        self.backgroundColor = .systemBackground

        addSubview(imageView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),

            isUrgentLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,
                                                   constant: Constants.stackViewInsets.left),
            isUrgentLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                  constant: -Constants.stackViewInsets.bottom),
            isUrgentLabel.topAnchor.constraint(lessThanOrEqualTo: imageView.safeAreaLayoutGuide.topAnchor,
                                                    constant: Constants.stackViewInsets.right),
            isUrgentLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.trailingAnchor,
                                                    constant: -Constants.stackViewInsets.right),

            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor)
        ])

        self.addDetailViews()
    }

    func addDetailViews() {
        viewModel.adDetails().forEach { attributedString in
            let label = UILabel()
            label.attributedText = NSAttributedString(attributedString)

            stackView.addArrangedSubview(label)
        }
    }

    func bindModels() {
        self.cancellable = viewModel.observableImage
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                self?.imageView.image = image
            }
    }
}
