//
//  AlamofireProxyProtocol.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 02.04.2022.
//

import Alamofire
import os

protocol APIAdapterProxyProtocol {
    static var logger: Logger { get }
    static var apiAdapter: APIAdapter { get }
    func searchGroups(searchString: String, completion: @escaping ([Group]?) -> Void)

    func joinGroup(groupID: Int, completion: @escaping (Bool) -> Void)

    func leaveGroup(groupID: Int, completion: @escaping ([Group]?) -> Void)

    func getUserGroups(completion: @escaping ([Group]?) -> Void)

    func getFriends(completion: @escaping ([User]?) -> Void)

    func getUserPhotos(userID: Int, completion: @escaping ([Photo]?) -> Void)
    func getNewsFeed(startTime: Int,
                     startFrom: [PostType: String?],
                     completion: @escaping ([PostType: ResponseNews<News>?]) -> Void)

    func getImage(url: String, completion: @escaping (UIImage?) -> Void)

    func loadImage(placeholderImage: UIImage?, toImageView: UIImageView?,
                   url: String, onFailureImage: UIImage?)
}
