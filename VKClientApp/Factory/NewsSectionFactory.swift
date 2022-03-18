//
//  NewsSectionFactory.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 17.03.2022.
//

import UIKit

final class NewsSectionFactory {
    private var news = [NewsProtocol]()
    private var users = [UserViewModel]()
    private var groups = [GroupViewModel]()
    private var rowWidth: CGFloat = 0

    func constructViewModels(width: CGFloat,
                             news: [NewsProtocol]?,
                             users: [User]?,
                             groups: [Group]?) -> [NewsSection]
    {
        rowWidth = width
        self.users = UserViewModelFactory().constructViewModels(users: users)
        self.groups = GroupViewModelFactory().constructViewModels(groups: groups)
        guard let news = news else { return [NewsSection]() }
        return news.compactMap { self.viewModel(newsItem: $0) }
    }

    private func viewModel(newsItem: NewsProtocol) -> NewsSection? {
        switch newsItem.getType() {
        case "post":
            return setPostRows(item: newsItem)
        case "photo",
             "wall_photo":
            return setPhotoRows(item: newsItem)
        default:
            return nil
        }
    }

    private func getAvatarURL(sourceID: Int) -> String? {
        sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.avatarURL :
            users.first(where: { $0.id == sourceID })?.avatarURL
    }

    private func getSourceName(sourceID: Int) -> String? {
        sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.name :
            users.first(where: { $0.id == sourceID })?.name
    }

    private func setPostRows(item: NewsProtocol) -> NewsSection? {
        guard let postItem = item as? PostNews else { return nil }
        let section = NewsSection()
        let avatarURL = getAvatarURL(sourceID: postItem.sourceID)
        let srcName = getSourceName(sourceID: postItem.sourceID)
        section.newsRows.append(NewsViewModel(photo: URL(string: avatarURL!),
                                              srcName: srcName,
                                              date: postItem.formattedDate))
        section.newsRows.append(NewsViewModel(text: postItem.text))
        for photo in postItem.photos {
            let image = getImage(photo: photo,
                                 width: rowWidth)
            section.newsRows.append(NewsViewModel(photo: image.imageURL,
                                                  width: image.width,
                                                  height: image.height))
        }
        section.newsRows.append(NewsViewModel(likes: postItem.flags.likesCount,
                                              isLiked: postItem.flags.isLiked,
                                              comments: postItem.flags.commentsCount,
                                              canComment: postItem.flags.canComment,
                                              reposts: postItem.flags.repostsCount,
                                              isReposted: postItem.flags.isReposted))
        return section
    }

    private func setPhotoRows(item: NewsProtocol) -> NewsSection? {
        guard let photoItem = item as? PhotoNews else { return nil }
        let section = NewsSection()
        let sourceID = photoItem.sourceID
        let avatarURL = sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.avatarURL :
            users.first(where: { $0.id == sourceID })?.avatarURL
        let srcName = sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.name :
            users.first(where: { $0.id == sourceID })?.name
        section.newsRows.append(NewsViewModel(photo: URL(string: avatarURL!),
                                              srcName: srcName,
                                              date: photoItem.formattedDate))
        for photo in photoItem.photos {
            let image = getImage(photo: photo.photo,
                                 width: rowWidth)
            section.newsRows.append(NewsViewModel(photo: image.imageURL,
                                                  width: image.width,
                                                  height: image.height))
            if !photo.text.isEmpty {
                section.newsRows.append(NewsViewModel(text: photo.text))
            }
            section.newsRows.append(NewsViewModel(likes: photo.flags.likesCount,
                                                  isLiked: photo.flags.isLiked,
                                                  comments: photo.flags.commentsCount,
                                                  canComment: photo.flags.canComment,
                                                  reposts: photo.flags.repostsCount,
                                                  isReposted: photo.flags.isReposted))
        }
        return section
    }

    private func getImage(photo: Photo, width: CGFloat) -> NewsImage {
        let fullImageList = photo.images.sorted(by: { $0.width > $1.width })
        var filteredImageList = fullImageList
            .filter { CGFloat($0.width) >= width }
        if filteredImageList.isEmpty { filteredImageList = fullImageList }
        guard let image = filteredImageList.first
        else { return NewsImage(url: nil, width: 1, height: 1) }
        let url = URL(string: image.imageUrl!)
        return NewsImage(url: url, width: image.width, height: image.height)
    }
}
