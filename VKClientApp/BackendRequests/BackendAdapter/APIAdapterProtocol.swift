//
//  APIAdapterProtocol.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 10.03.2022.
//

import UIKit
protocol APIAdapterProtocol {
    func getNewsFeed(startTime: Int,
                     startFrom: [PostType: String?],
                     completion: @escaping ([PostType: ResponseNews<News>?]) -> Void)
    func getUserPhotos(userID: Int,
                       completion: @escaping ([Photo]?) -> Void)
    func getFriends(completion: @escaping ([User]?) -> Void)
    func getUserGroups(completion: @escaping ([Group]?) -> Void)
    func leaveGroup(groupID: Int,
                    completion: @escaping ([Group]?) -> Void)
    func searchGroups(searchString: String,
                      completion: @escaping ([Group]?) -> Void)
    func joinGroup(groupID: Int,
                   completion: @escaping (Bool) -> Void)
    func getImage(url: String, completion: @escaping (UIImage?) -> Void)
    func loadImage(placeholderImage: UIImage?,
                   toImageView: UIImageView?,
                   url: String,
                   onFailureImage: UIImage?)
}
