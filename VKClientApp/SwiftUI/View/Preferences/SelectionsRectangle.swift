//
//  SelectionsRectangle.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 06.06.2022.
//

import SwiftUI

struct SelectionRectangle: View {
    let anchor: Anchor<CGRect>?

    var body: some View {
        GeometryReader { proxy in
            if let rect = self.anchor.map({ proxy[$0] }) {
                Rectangle()
                    .fill(Color.clear)
                    .border(Color.gray, width: 1)
                    .offset(x: rect.minX, y: rect.minY)
                    .frame(width: rect.width, height: rect.height)
            }
        }
    }
}
