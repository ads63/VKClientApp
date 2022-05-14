//
//  PhotosViewModel.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SwiftUI

class PhotosViewModel: ObservableObject {
    let friend: UserViewModel

    @Published var photos: [PhotoViewModel] = []

    init(friend: UserViewModel) {
        self.friend = friend
    }

    public func fetch() {
        AppSettings.instance.apiAdapter.getUserPhotos(userID: friend.id) {
            [weak self] photos in
            guard let self = self else { return }

            self.photos = PhotoViewModelFactory().constructViewModels(
                photos: photos,
                viewSize: CGSize(width: 64, height: 64),
                largeViewSize: CGSize(width: UIScreen.main.bounds.width/2,
                                      height: UIScreen.main.bounds.width/2))
        }
    }
}
