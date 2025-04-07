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
        static let urgentViewInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        static let imageHeight: CGFloat = 300
    }

    private let scrollView:  UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        return scrollView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: GlobalConstants.placeholderImageName)
        return imageView
    }()
    lazy private var isUrgentLabel: UIView = {
        let uiView = UIView()
        let isUrgentLabel = UILabel()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        isUrgentLabel.translatesAutoresizingMaskIntoConstraints = false

        uiView.addSubview(isUrgentLabel)
        uiView.backgroundColor = .red
        uiView.layer.cornerRadius = GlobalConstants.cornerRadius

        NSLayoutConstraint.activate([
            isUrgentLabel.topAnchor.constraint(equalTo: uiView.topAnchor,
                                               constant: Constants.urgentViewInsets.top),
            isUrgentLabel.leadingAnchor.constraint(equalTo: uiView.leadingAnchor,
                                                   constant: Constants.urgentViewInsets.left),
            isUrgentLabel.trailingAnchor.constraint(equalTo: uiView.trailingAnchor,
                                                    constant: -Constants.urgentViewInsets.right),
            isUrgentLabel.bottomAnchor.constraint(equalTo: uiView.bottomAnchor,
                                                  constant: -Constants.urgentViewInsets.bottom)
        ])

        isUrgentLabel.textColor = .white
        isUrgentLabel.font = .boldSystemFont(ofSize: 16)
        isUrgentLabel.text = "Urgent"
        isUrgentLabel.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        return uiView
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
        self.bindModels()
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

        addSubview(scrollView)

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(container)
        container.addSubview(imageView)
        container.addSubview(stackView)
        container.addSubview(isUrgentLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),

            isUrgentLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,
                                                   constant: Constants.stackViewInsets.left),
            isUrgentLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                  constant: -Constants.stackViewInsets.bottom),
            isUrgentLabel.topAnchor.constraint(greaterThanOrEqualTo: imageView.safeAreaLayoutGuide.topAnchor,
                                                    constant: Constants.stackViewInsets.right),
            isUrgentLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.trailingAnchor,
                                                    constant: -Constants.stackViewInsets.right),

            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: container.safeAreaLayoutGuide.bottomAnchor),
        ])

        self.isUrgentLabel.isHidden = !viewModel.ad.isUrgent

        self.addDetailViews()
    }

    func addDetailViews() {
        viewModel.adDetails().forEach { attributedString in
            let label = UILabel()
            label.attributedText = NSAttributedString(attributedString)
            label.numberOfLines = 0
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
