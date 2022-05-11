//
//  NameBuilder.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 11.05.2022.
//

import SwiftUI

struct NameBuilder: View {
    var content: Text

    init(@ViewBuilder content: () -> Text) {
        self.content = content()
    }

    var body: some View {
        content
            .font(.system(size: 16))
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 250, height: 60, alignment: .leading)
    }
}
