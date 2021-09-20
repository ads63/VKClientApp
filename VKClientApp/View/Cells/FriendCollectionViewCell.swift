//
//  FriendCollectionViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 27.08.2021.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    var imageIndex = 0
    var userPhotos: [UserPhoto] = []

    @IBOutlet var photoImage: UIImageView!

    func configure(userImages: [UserPhoto]) {
        let swipeRightGestureRecognizer =
            UISwipeGestureRecognizer(target: self,
                                     action: #selector(swipeRight(sender:)))
        swipeRightGestureRecognizer.direction = .right
        let swipeLeftGestureRecognizer =
            UISwipeGestureRecognizer(target: self,
                                     action: #selector(swipeLeft(sender:)))
        swipeRightGestureRecognizer.direction = .right
        swipeLeftGestureRecognizer.direction = .left
        addGestureRecognizer(swipeRightGestureRecognizer)
        addGestureRecognizer(swipeLeftGestureRecognizer)
        userPhotos = userImages
        photoImage.image = userPhotos[imageIndex].photoImage?
            .scalePreservingAspectRatio(targetSize: photoImage.bounds.size)
    }

    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        if !userPhotos.isEmpty, imageIndex > userPhotos.startIndex {
            let fromImage = userPhotos[imageIndex].photoImage?
                .scalePreservingAspectRatio(targetSize: photoImage.bounds.size)
            imageIndex -= 1
            let toImage = userPhotos[imageIndex].photoImage?
                .scalePreservingAspectRatio(targetSize: photoImage.bounds.size)
            animateSwipe(direction: .right, fromImage: fromImage!, toImage: toImage!)
        }
    }

    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        if !userPhotos.isEmpty, imageIndex < userPhotos.endIndex - 1 {
            let fromImage = userPhotos[imageIndex].photoImage?
                .scalePreservingAspectRatio(targetSize: photoImage.bounds.size)
            imageIndex += 1
            let toImage = userPhotos[imageIndex].photoImage?
                .scalePreservingAspectRatio(targetSize: photoImage.bounds.size)

            animateSwipe(direction: .left, fromImage: fromImage!, toImage: toImage!)
        }
    }

    func animateSwipe(direction: Direction, fromImage: UIImage, toImage: UIImage) {
        let directionFactor: CGFloat = direction == .left ? -1.0 : 1.0
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveLinear]) {
            self.photoImage.center.x += directionFactor * self.photoImage.bounds.width
        }
        completion: { _ in
            self.photoImage.image = toImage
            self.photoImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.photoImage.center.x -= directionFactor * self.photoImage.bounds.width
            self.photoImage.alpha = 0.1
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: [.curveLinear],
                animations: {
                    self.photoImage.alpha = 1.0
                    self.photoImage.transform = .identity
                }
            )
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }

        return scaledImage
    }
}
