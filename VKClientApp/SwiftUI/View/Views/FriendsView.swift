//
//  FriendsView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SwiftUI

// MARK: Content

struct FriendsView: View {
    @ObservedObject var viewModel: FriendsViewModel

    init(viewModel: FriendsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.users.sorted(by: { $0.name < $1.name })) { friend in
            NavigationLink(destination: FriendPhotosView(viewModel: PhotosViewModel(friend: friend))) {
                FriendViewCell(friend: friend)
            }
        }
        .onAppear { viewModel.fetch() }
    }
}
