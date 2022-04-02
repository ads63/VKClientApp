//
//  APIAdapterProxy.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 02.04.2022.
//

import Alamofire
import os

class APIAdapterProxy: APIAdapterProxyProtocol {
    static let logger = Logger(subsystem: "com.alexey.shinkarev.VKClientApp",
                               category: "VK REST API")
    static let apiAdapter = APIAdapter()
    
    func searchGroups(searchString: String,
                      completion: @escaping ([Group]?) -> Void)
    {
        APIAdapterProxy.logger.info("Search groups by \(searchString)")
        APIAdapterProxy.apiAdapter.searchGroups(searchString: searchString,
                                                completion: completion)
    }
    
    func joinGroup(groupID: Int, completion: @escaping (Bool) -> Void) {
        APIAdapterProxy.logger.info("Join group with ID \(groupID)")
        APIAdapterProxy.apiAdapter.joinGroup(groupID: groupID,
                                             completion: completion)
    }
    
    func leaveGroup(groupID: Int, completion: @escaping ([Group]?) -> Void) {
        APIAdapterProxy.logger.info("Leave group with ID \(groupID)")
        APIAdapterProxy.apiAdapter.leaveGroup(groupID: groupID,
                                              completion: completion)
    }
    
    func getUserGroups(completion: @escaping ([Group]?) -> Void) {
        APIAdapterProxy.logger.info("Get current user groups")
        APIAdapterProxy.apiAdapter.getUserGroups(completion: completion)
    }
    
    func getFriends(completion: @escaping ([User]?) -> Void) {
        APIAdapterProxy.logger.info("Get current user friends")
        APIAdapterProxy.apiAdapter.getFriends(completion: completion)
    }
    
    func getUserPhotos(userID: Int, completion: @escaping ([Photo]?) -> Void) {
        APIAdapterProxy.logger.info("Get user photo by userID \(userID)")
        APIAdapterProxy.apiAdapter.getUserPhotos(userID: userID,
                                                 completion: completion)
    }
    
    func getNewsFeed(startTime: Int, startFrom: [PostType: String?],
                     completion: @escaping ([PostType: ResponseNews<News>?]) -> Void)
    {
        APIAdapterProxy.logger.info("Get current user news by parameters start_time \(startTime), start_from {\(startFrom.map { $0.key.rawValue + " = " + ($0.value ?? "nil") }.joined(separator: ", "))}")
        APIAdapterProxy.apiAdapter.getNewsFeed(startTime: startTime,
                                               startFrom: startFrom,
                                               completion: completion)
    }
    
    func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        APIAdapterProxy.logger.info("Get image by url \(url)")
        APIAdapterProxy.apiAdapter.getImage(url: url, completion: completion)
    }
    
    func loadImage(placeholderImage: UIImage?, toImageView: UIImageView?,
                   url: String, onFailureImage: UIImage?)
    {
        APIAdapterProxy.logger.info("Load image from url \(url)")
        APIAdapterProxy.apiAdapter.loadImage(placeholderImage: placeholderImage,
                                             toImageView: toImageView, url: url,
                                             onFailureImage: onFailureImage)
    }
}
