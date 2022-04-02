//
//  UserViewModelFactory.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 17.03.2022.
//

import Foundation

final class UserViewModelFactory {
    func constructViewModels(users: [User]?) -> [UserViewModel] {
        guard let users = users else { return [UserViewModel]() }
        return users.map { self.viewModel(user: $0) }
    }

    private func viewModel(user: User) -> UserViewModel {
        return UserViewModel(id: user.id,
                             name: ((user.firstName ?? "")
                                 + " "
                                 + (user.lastName ?? ""))
                                 .trimmingCharacters(in: .whitespaces),
                             avatarURL: user.avatarURL)
    }
}
