//
//  NewsImage.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.01.2022.
//

import Foundation
final class NewsImage {
    let imageURL: URL?
    let width: Int
    let height: Int

    init(url: URL?, width: Int, height: Int) {
        self.imageURL = url
        self.width = width
        self.height = height
    }
}
