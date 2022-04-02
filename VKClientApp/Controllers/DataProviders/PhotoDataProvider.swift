//
//  PhotoDataProvider.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.02.2022.
//

import Foundation
import UIKit

final class PhotoDataProvider {
    func loadPhoto(imageView: UIImageView?, photo: PhotoViewModel?) {
        guard let imageView = imageView,
              let url = URL(string: photo?.largePhotoURL ?? "")
        else { return }
        imageView.load(url: url,
                       placeholderImage: ImageProvider.get(id: .unknown),
                       failureImage: ImageProvider.get(id: .unknown))
    }
}
