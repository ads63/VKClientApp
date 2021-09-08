//
//  FriendCollectionViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 27.08.2021.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoImage: UIImageView!

    func configure(userImage: UIImage) {
        photoImage.image = userImage
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
