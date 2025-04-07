//
//  HomeView.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import SwiftUI

struct HomeView<ViewModel: HomeViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = ObservedObject(initialValue: viewModel)
    }

    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .idle, .loading:
                ProgressView()

            case .loaded:
                List(viewModel.ads, id: \.id) { ad in
                    NavigationLink(value: ad) {
                        AdListView(ad: ad,
                                   category: viewModel.category(with: ad.categoryId),
                                   fetchImage: viewModel.fetchImageWith)
                    }
                }
                .listStyle(.plain)

            case .loadedNoItems:
                Text("No Data Available")
            }
        }
        .navigationDestination(for: AdFullModel.self) { ad in
            AdDetailViewRepresentable(viewModel: viewModel.detailViewModel(for: ad))
        }
        .task {
            await viewModel.initialTask()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(
                networkManager: NetworkManager(
                    networkAPI: NetworkAPI()
                )
            )
        )
    }
}
