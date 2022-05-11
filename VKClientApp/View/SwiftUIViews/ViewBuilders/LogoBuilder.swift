//
//  LogoBuilder.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 11.05.2022.
//

import SwiftUI

struct LogoBuilder: View {
    var content: SwiftUI.Image

    init(@ViewBuilder content: () -> SwiftUI.Image) {
        self.content = content()
    }

    var body: some View {
        content
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
            .cornerRadius(30)
            .modifier(ShadowModifier(shadowColor: .black, shadowRadius: 6, x: 3, y: 3))
    }
}
