//
//  EntityViewModel.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 17.03.2022.
//

import Foundation

typealias UserViewModel = EntityViewModel
typealias GroupViewModel = EntityViewModel

final class EntityViewModel: Identifiable {
    let id: Int
    let name: String
    let avatarURL: String

    init(id: Int, name: String?, avatarURL: String?) {
        self.id = id
        self.name = name ?? ""
        self.avatarURL = avatarURL ?? ""
    }
}
