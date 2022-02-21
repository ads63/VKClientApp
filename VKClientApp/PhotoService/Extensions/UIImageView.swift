//
//  UIImageView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 09.02.2022.
//

import UIKit
extension UIImageView {
    func load(url: URL?,
              placeholderImage: UIImage? = nil,
              failureImage: UIImage? = nil)
    {
        guard let url = url else { return }
        let photoService = AppSettings.instance.photoService
        photoService.loadImage(placeholderImage: placeholderImage,
                               toImageView: self,
                               url: url.absoluteString,
                               onFailureImage: failureImage)
    }
}
