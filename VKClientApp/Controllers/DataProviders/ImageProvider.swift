//
//  Placeholders.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.02.2022.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(imageIdentifier: ImageIdentifier) {
        self.init(named: imageIdentifier.rawValue)
    }
}

enum ImageIdentifier: String {
    case unknown
    case camera
    case news = "globe"
}

enum ImageProvider {
    private static let images =
        [ImageIdentifier.unknown: UIImage(imageIdentifier: .unknown),
         ImageIdentifier.camera: UIImage(imageIdentifier: .camera),
         ImageIdentifier.news: UIImage(imageIdentifier: .news)]

    static func get(id: ImageIdentifier) -> UIImage? {
        return images[id] ?? nil
    }
}
