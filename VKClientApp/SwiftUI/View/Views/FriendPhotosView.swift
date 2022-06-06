//
//  FriendPhotosView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SDWebImageSwiftUI
import SwiftUI

struct FriendPhotosView: View {
    @ObservedObject var viewModel: PhotosViewModel

    let columns = [
        GridItem(.flexible(minimum: 0, maximum: .infinity)),
        GridItem(.flexible(minimum: 0, maximum: .infinity))
    ]

    @State private var photoRowHeight: CGFloat? = nil
    @State private var selection: Int? = nil

    init(viewModel: PhotosViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            LogoBuilder {
                WebImage(url: URL(string: viewModel.friend.avatarURL))
            }
            GeometryReader { _ in
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 2) {
                        if let photos = viewModel.photos {
                            ForEach(photos) { photo in
                                PhotoViewCell(photo: photo,
                                              index: photos.firstIndex(of: photo),
                                              selection: $selection)
                                    .frame(height: photoRowHeight)
                            }
                        }
                    }
                }
            }
            .onAppear { viewModel.fetch() }
            .navigationBarTitle(Text(viewModel.friend.name), displayMode: .inline)
            .onPreferenceChange(PhotoHeightPreferenceKey.self) { height in
                photoRowHeight = height
            }
            .overlayPreferenceValue(SelectionsPreferenceKey.self) {
                SelectionRectangle(anchor: $0)
            }
        }
    }
}
