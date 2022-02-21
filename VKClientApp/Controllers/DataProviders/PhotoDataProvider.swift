//
//  PhotoDataProvider.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.02.2022.
//

import Foundation
import UIKit

final class PhotoDataProvider {
    func getUrl(photo: Photo?, size: CGSize) -> URL? {
        guard let photo = photo else { return nil }
        let fullImageList = photo.images.sorted(by: { $0.width > $1.width })
        var filteredImageList = fullImageList.filter {
            SessionSettings.instance.enabledPhotoType.contains($0.type!) &&
                (CGFloat($0.width) >= size.width ||
                    CGFloat($0.height) >= size.height)
        }
        if filteredImageList.isEmpty { filteredImageList = fullImageList }
        guard let url = URL(string: filteredImageList.first!.imageUrl!)
        else { return nil }
        return url
    }

    func loadPhoto(imageView: UIImageView?, photo: Photo?) {
        guard let imageView = imageView else { return }
        guard let url = getUrl(photo: photo, size: imageView.bounds.size)
        else { return }
        imageView.load(url: url,
                       placeholderImage: ImageProvider.get(id: .unknown),
                       failureImage: ImageProvider.get(id: .unknown))
    }
}
