//
//  FriendCollectionViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 27.08.2021.
//

import Nuke
import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    var imageIndex = 0
    var userPhotos: [Photo] = []

    @IBOutlet var photoImage: UIImageView!

    func configure(userImages: [Photo], index: Int, cellSize: CGSize) {
//        let swipeRightGestureRecognizer =
//            UISwipeGestureRecognizer(target: self,
//                                     action: #selector(swipeRight(sender:)))
//        swipeRightGestureRecognizer.direction = .right
//        let swipeLeftGestureRecognizer =
//            UISwipeGestureRecognizer(target: self,
//                                     action: #selector(swipeLeft(sender:)))
//        swipeLeftGestureRecognizer.direction = .left
//        addGestureRecognizer(swipeRightGestureRecognizer)
//        addGestureRecognizer(swipeLeftGestureRecognizer)
        userPhotos = userImages

        // select min image that is large enough for cell size 100
        guard let userPhoto = userPhotos[index].images.filter({ CGFloat($0.width) >= (UIScreen.main.scale * cellSize.width) || CGFloat($0.height) >=
            (UIScreen.main.scale * cellSize.height) }).sorted(by: { $0.width < $1.width }).first else { return }
        guard let url = URL(string: userPhoto.imageUrl!) else { return }

        let options = ImageLoadingOptions(placeholder: UIImage(named: "unknown"), transition: .fadeIn(duration: 0.5), failureImage: UIImage(named: "unknown"), failureImageTransition: .fadeIn(duration: 0.5))
//        var resizedImageProcessors: [ImageProcessing] {
//            return [ImageProcessors.Resize(size: cellSize, contentMode: .aspectFit)]
//        }
//        let request = ImageRequest(url: url, processors: resizedImageProcessors)
//        Nuke.loadImage(with: request, options: options, into: photoImage)
        Nuke.loadImage(with: url, options: options, into: photoImage)
        photoImage.image = photoImage.image?.scalePreservingAspectRatio(targetSize: photoImage.bounds.size)
    }

//    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
//        if !userPhotos.isEmpty, imageIndex > userPhotos.startIndex {
//            var toImage: UIImage?
//            imageIndex -= 1
//            guard let url = URL(string: (userPhotos[imageIndex].images.first?.imageUrl)!) else {return}
//            ImagePipeline.shared.loadImage(with: url) {
//                [weak self] response in
//                guard let self = self else { return}
//                switch response {
//                case .failure:
//                    toImage = UIImage(named: "unknown")
//                case let .success(imageResponse):
//                    toImage = imageResponse.image
//                }
//            }
//            animateSwipe(direction: .right, fromImage: photoImage.image!, toImage: toImage!)
//        }
//    }
//
//    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
//        if !userPhotos.isEmpty, imageIndex < userPhotos.endIndex - 1 {
//            var toImage: UIImage?
//            imageIndex += 1
//            guard let url = URL(string: (userPhotos[imageIndex].images.first?.imageUrl)!) else {return}
//            ImagePipeline.shared.loadImage(with: url) {
//                [weak self] response in
//                guard let self = self else { return}
//                switch response {
//                case .failure:
//                    toImage = UIImage(named: "unknown")
//                case let .success(imageResponse):
//                    toImage = imageResponse.image
//                }
//            }
//            animateSwipe(direction: .left, fromImage: photoImage.image!, toImage: toImage!)
//        }
//    }

//    func animateSwipe(direction: Direction, fromImage: UIImage, toImage: UIImage) {
//        let directionFactor: CGFloat = direction == .left ? -1.0 : 1.0
//        UIView.animate(withDuration: 0.5,
//                       delay: 0.0,
//                       options: [.curveLinear]) {
//            self.photoImage.center.x += directionFactor * self.photoImage.bounds.width
//        }
//        completion: { _ in
//            self.photoImage.image = toImage
//            self.photoImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//            self.photoImage.center.x -= directionFactor * self.photoImage.bounds.width
//            self.photoImage.alpha = 0.1
//            UIView.animate(
//                withDuration: 0.5,
//                delay: 0,
//                options: [.curveLinear],
//                animations: {
//                    self.photoImage.alpha = 1.0
//                    self.photoImage.transform = .identity
//                }
//            )
//        }
//    }

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

        // new image size with the same aspect ratio
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
