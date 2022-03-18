//
//  NewsViewModel.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 17.03.2022.
//

import UIKit

final class NewsViewModel
{
    var cellType: CellType?
    var photo: URL?
    var width = 1
    var height = 1
    var aspectRatio: CGFloat?
    var text: String?
    var srcName: String?
    var date: String?
    var likes = 0
    var isLiked = 0
    var comments = 0
    var canComment = 0
    var reposts = 0
    var isReposted = 0

    init(photo: URL?,
         width: Int,
         height: Int)
    {
        self.cellType = CellType.image
        self.photo = photo
        self.width = width
        self.height = height
        if width > 0 { self.aspectRatio = CGFloat(height) / CGFloat(width) }
    }

    init(likes: Int,
         isLiked: Int,
         comments: Int,
         canComment: Int,
         reposts: Int,
         isReposted: Int)
    {
        self.cellType = CellType.likes
        self.likes = likes
        self.isLiked = isLiked
        self.comments = comments
        self.canComment = canComment
        self.reposts = reposts
        self.isReposted = isReposted
    }

    init(text: String)
    {
        self.cellType = CellType.text
        self.text = text
    }

    init(photo: URL?,
         srcName: String?,
         date: String?)
    {
        self.cellType = CellType.source
        self.photo = photo
        self.srcName = srcName
        self.date = date
    }
}
