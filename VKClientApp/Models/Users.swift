//
//  Users.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 15.09.2021.
//

import UIKit
struct Users {
    static var userDetails = [
        UserDetails(userID: 0, userPhotos: [
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "batman")),
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "bat_red")),
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "bat_red180")),
        ]),
        UserDetails(userID: 1, userPhotos: [
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "egghead")),
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "egghead_colored")),
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "egghead_star")),
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "egghead90")),
        ]),
        UserDetails(userID: 2, userPhotos: [
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "deadhead")),
        ]),
        UserDetails(userID: 3, userPhotos: [
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "guy")),
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "guy2")),
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "guy3")),
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "guy4")),
            UserPhoto(isLiked: Bool.random(), likeCount: Int.random(in: 0...100),
                      photoImage: UIImage(named: "guy5")),
        ]),
        UserDetails(userID: 4, userPhotos: []),
    ]
    static func getPhoto(userID: Int?) -> [UserPhoto] {
        let photos = getDetails(userID: userID).userPhotos
        return !photos.isEmpty ?
            photos :
            [UserPhoto(isLiked: false,
                       likeCount: 0,
                       photoImage: UIImage(named: "unknown"))]
    }

    static func getDetails(userID: Int? = -1) -> UserDetails {
        let details = userDetails.filter { $0.userID == userID }
        return !details.isEmpty ?
            details[0] :
            UserDetails(userID: -1,
                        userPhotos: [UserPhoto(isLiked: false,
                                               likeCount: 0,
                                               photoImage: UIImage(named: "unknown"))])
    }
}
