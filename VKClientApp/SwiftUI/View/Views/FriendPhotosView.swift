//
//  FriendPhotosView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import ASCollectionView
import SDWebImageSwiftUI
import SwiftUI

struct FriendPhotosView: View {
    @ObservedObject var viewModel: PhotosViewModel

    init(viewModel: PhotosViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            VStack {
                LogoBuilder {
                    WebImage(url: URL(string: viewModel.friend.avatarURL))
                }
            }
            ASCollectionView(data: viewModel.photos) {
                photo, _ in
                PhotoViewCell(photo: photo)
            }
            .layout {
                .grid(layoutMode: .fixedNumberOfColumns(3),
                      itemSpacing: 0,
                      lineSpacing: 0)
            }
            .onAppear { viewModel.fetch() }
            .navigationBarTitle(Text(viewModel.friend.name), displayMode: .inline)
        }
    }
}
