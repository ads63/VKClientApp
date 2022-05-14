//
//  PhotosViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 12.05.2022.
//

import SDWebImageSwiftUI
import SwiftUI

struct PhotoViewCell: View {
    var photo: PhotoViewModel

    var body: some View {
        GeometryReader { proxy in
            WebImage(url: URL(string: photo.largePhotoURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .frame(width: proxy.size.width, height: proxy.size.height,
                       alignment: .center)
        }
    }
}
