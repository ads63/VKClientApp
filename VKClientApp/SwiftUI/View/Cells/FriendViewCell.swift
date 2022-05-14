//
//  FriendViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 11.05.2022.
//
import SDWebImageSwiftUI
import SwiftUI

var friend = UserViewModel(id: 0, name: "my test friend", avatarURL: "unknown")

// MARK: Content

struct FriendViewCell: View {
    var friend: UserViewModel
    var body: some View {
        HStack {
            LogoBuilder {
                WebImage(url: URL(string: friend.avatarURL))
            }
            Spacer()
            NameBuilder {
                Text(friend.name)
            }
        }.padding(10)
    }
}

// MARK: Previews

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendViewCell(friend: friend)
    }
}
