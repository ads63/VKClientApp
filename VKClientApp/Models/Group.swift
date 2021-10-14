//
//  Group.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 25.08.2021.
//

import UIKit

struct Group: Equatable {
    let id: Int
    let image: UIImage?
    let groupName: String
    var isMember: Bool
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
