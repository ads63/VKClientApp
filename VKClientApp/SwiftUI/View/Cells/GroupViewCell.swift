//
//  GroupViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 11.05.2022.
//

import SwiftUI
import SDWebImageSwiftUI

var group = GroupViewModel(id: 0, name: "сообщество", avatarURL: "globe")

// MARK: Content

struct GroupViewCell: View {
    var group: GroupViewModel
    var body: some View {
        HStack {
            LogoBuilder {
                WebImage(url: URL(string: group.avatarURL))
            }
            Spacer()
            NameBuilder {
                Text(group.name)
            }

        }.padding(10)
    }
}

// MARK: Previews

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupViewCell(group: group)
    }
}
