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
    var iconName: String { photo.isLiked > 0 ? "heart.fill" : "heart" }
    var angle: Double { photo.isLiked > 0 ? 45 : -45 }
    var likeChange: Int { photo.isLiked > 0 ? 1 : -1 }

    var body: some View {
        VStack {
            GeometryReader { proxy in
                WebImage(url: URL(string: photo.largePhotoURL))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .frame(width: proxy.size.width, height: proxy.size.height,
                           alignment: .center)
            }
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
                    }
                Text("\(self.photo.likesCount)")
            }
            .frame(width: 100, height: 40, alignment: .center)
        }
    }
}
