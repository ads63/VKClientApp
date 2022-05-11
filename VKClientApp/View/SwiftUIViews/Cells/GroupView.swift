//
//  GroupView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 11.05.2022.
//

import SwiftUI

var groupName = Text("сообщество")
var groupLogo = SwiftUI.Image("globe")

// MARK: Content

struct GroupView: View {
    var body: some View {
        HStack {
            LogoBuilder {
                groupLogo
            }
            Spacer()
            NameBuilder {
                groupName
            }

        }.padding(10)
    }
}

// MARK: Previews

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
