//
//  PhotosViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SDWebImageSwiftUI
import SwiftUI

struct PhotoViewCell: View {
    @State private var isRotated = false

    var photo: PhotoViewModel
    let index: Int?
    @Binding var selection: Int?

    var iconName: String { photo.isLiked > 0 ? "heart.fill" : "heart" }
    var angle: Double { photo.isLiked > 0 ? 45 : -45 }
    var likeChange: Int { photo.isLiked > 0 ? 1 : -1 }

    var body: some View {
        GeometryReader { proxy in
            VStack {
                WebImage(url: URL(string: photo.largePhotoURL))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                HStack {
                    SwiftUI.Image(systemName: iconName)
                        .rotationEffect(isRotated ? Angle.degrees(angle) : .zero)
                        .onTapGesture {
                            self.photo.isLiked = 1 - self.photo.isLiked
                            self.photo.likesCount += likeChange
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.isRotated.toggle()
                            }
                            self.isRotated.toggle()
                            self.selection = index
                        }
                    Text("\(self.photo.likesCount)")
                }
            }
            .preference(key: PhotoHeightPreferenceKey.self, value: proxy.size.width)
            .anchorPreference(key: SelectionsPreferenceKey.self, value: .bounds) {
                index == self.selection ? $0 : nil
            }
        }
    }
}
