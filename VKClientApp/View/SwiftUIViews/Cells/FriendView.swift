//
//  FriendView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 11.05.2022.
//

import SwiftUI

var friendName = Text("my test friend")
var friendLogo = SwiftUI.Image("unknown")

// MARK: Content

struct FriendView: View {
    var body: some View {
        HStack {
            LogoBuilder {
                friendLogo
            }
            Spacer()
            NameBuilder {
                friendName
            }
        }.padding(10)
    }
}

// MARK: Previews

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}
