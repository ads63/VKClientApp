//
//  PhotoViewModel.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 17.03.2022.
//

import Foundation
final class PhotoViewModel: Identifiable {
    let id: Int
    let photoURL: String
    let largePhotoURL: String

    init(id: Int, photoURL: String?, largePhotoURL: String?) {
        self.id = id
        self.photoURL = photoURL ?? ""
        self.largePhotoURL = largePhotoURL ?? ""
    }
}
