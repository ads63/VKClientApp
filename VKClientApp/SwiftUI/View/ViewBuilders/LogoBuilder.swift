//
//  LogoBuilder.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 11.05.2022.
//

import SDWebImageSwiftUI
import SwiftUI

struct LogoBuilder: View {
    @State private var isScaled = false
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
            .scaleEffect(isScaled ? 0.9 : 1.0)
            .onTapGesture {
                withAnimation(.spring(response: 0.5,
                                      dampingFraction: 0.1,
                                      blendDuration: 0.1)) {
                    self.isScaled.toggle()
                }
                self.isScaled.toggle()
            }
    }
}
