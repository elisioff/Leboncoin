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
            Group {
                if let image {
                    image
                        .resizable()
                } else {
                    Image.placeholder
                }
            }
            .scaledToFit()
            .frame(idealWidth: 200, idealHeight: 200)

            VStack(alignment: .leading) {
                HStack  {
                    if let category {
                        Text(category)
                            .padding(7)
                            .foregroundStyle(.white)
                            .background(RoundedRectangle(cornerRadius: GlobalConstants.cornerRadius).fill(.indigo))
                    }

                    if ad.isUrgent {
                        Text("Urgent")
                            .padding(7)
                            .foregroundStyle(.white)
                            .background(RoundedRectangle(cornerRadius: GlobalConstants.cornerRadius).fill(.red))
                    }
                }
                .font(.caption)
                .bold()

                Text(ad.title)
                    .lineLimit(2)
                    .font(.headline)
                    .bold()

                Text(ad.price.formatted(.currency(code: "eur")))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
               category: "Books",
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
