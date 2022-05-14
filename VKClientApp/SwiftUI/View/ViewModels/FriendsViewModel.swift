//
//  FriendsViewModel.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SwiftUI

class FriendsViewModel: ObservableObject {
    @Published var users: [UserViewModel] = []

    public func fetch() {
        AppSettings.instance.apiAdapter.getFriends { [weak self] users in
            guard let self = self else { return }
            self.users = UserViewModelFactory().constructViewModels(users: users)
        }
    }
}
