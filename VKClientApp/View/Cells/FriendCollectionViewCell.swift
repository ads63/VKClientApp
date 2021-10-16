//
//  FriendCollectionViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 27.08.2021.
//

import Nuke
import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoImage: UIImageView!
    var parentViewController: FriendDetailsCollectionViewController?

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(parentViewController: FriendDetailsCollectionViewController) {
        self.parentViewController = parentViewController
        let tapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(tapCell(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
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
