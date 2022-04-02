//
//  FriendCollectionViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 17.03.2022.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoImage: UIImageView!
    var parentViewController: FriendDetailsCollectionViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(photo: PhotoViewModel?, size: CGSize) {
//        sizeThatFits(size)
//        autoresizesSubviews = true
        let tapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(tapCell(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
        if let photo = photo {
            photoImage.load(url: URL(string: photo.photoURL),
                            placeholderImage: ImageProvider.get(id: .unknown),
                            failureImage: ImageProvider.get(id: .unknown))
        }
    }

    @objc func tapCell(sender: UITapGestureRecognizer) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.005,
            initialSpringVelocity: 1.0,
            options: [
                .curveEaseOut
            ]) {
            self.photoImage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            self.photoImage.transform = .identity
            self.parentViewController?.tapCell(cell: self)
        }
    }
}
