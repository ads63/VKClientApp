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
    var isLiked: Int
    var likesCount: Int

    init(id: Int,
         photoURL: String?,
         largePhotoURL: String?,
         isLiked: Int?,
         likesCount: Int?)
    {
        self.id = id
        self.photoURL = photoURL ?? ""
        self.largePhotoURL = largePhotoURL ?? ""
        self.isLiked = isLiked ?? 0
        self.likesCount = likesCount ?? 0
    }
}
