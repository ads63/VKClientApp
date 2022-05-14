//
//  LogoBuilder.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 11.05.2022.
//

import SDWebImageSwiftUI
import SwiftUI

struct LogoBuilder: View {
    var content: WebImage

    init(@ViewBuilder content: () -> WebImage) {
        self.content = content()
    }

    var body: some View {
        content
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .cornerRadius(20)
            .modifier(ShadowModifier(shadowColor: .black, shadowRadius: 6, x: 3, y: 3))
    }
}
