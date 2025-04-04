//
//  AddListView.swift
//  Leboncoin
//
//  Created by Elísio Fernandes on 04/04/2025.
//

import SwiftUI

struct AdListView: View {
    @State private var image: Image?

    let ad: any AdSimpleModel
    let category: String?
    var fetchImage: (String) async -> UIImage?

    var body: some View {
        VStack {
            GeometryReader { geometry in
                Group {
                    if let image {
                        image
                            .resizable()
                    } else {
                        Image.placeholder
                    }
                }
                .scaledToFit()
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.width / 2)
                .clipped()
            }

            VStack(alignment: .leading) {
                HStack  {
                    Text(category ?? "")
                        .padding(7)
                        .foregroundStyle(.white)
                        .background(Capsule().fill(.indigo))

                    Text("Urgent")
                        .padding(7)
                        .foregroundStyle(.white)
                        .background(Capsule().fill(.red))
                }
                .bold()

                Text(ad.title)
                    .font(.title)
                    .bold()

                Text(ad.price.formatted(.currency(code: "eur")))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: GlobalConstants.cornerRadius)
                .fill(.background)
                .shadow(radius: 5)
        }
        .task {
            guard let url = ad.imagesUrl.small,
                    let uiImage = await fetchImage(url) else { return }

            await MainActor.run {
                image = Image(uiImage: uiImage)
            }
        }
    }
}

#Preview {
    AdListView(ad: AdFullModel.sampleNotUrgent,
                category: "Cars",
                fetchImage: { url in
        guard let url = URL(string: url) else { return nil }

        do {
            let data = try await URLSession.shared.data(from: url).0
            return UIImage(data: data)
        } catch {
            return nil
        }

    })
    .padding()
}
