//
//  PhotoViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 15.10.2021.
//

import Foundation
import Nuke
import RealmSwift
import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    let sessionSettings = SessionSettings.instance
    var index = 0
    var photoID: Int?
    var photos: Results<Photo>?
    var pixelSize: CGSize {
        return CGSize(width: imageView.bounds.width * UIScreen.main.scale,
                      height: imageView.bounds.height * UIScreen.main.scale)
    }

    var resizedImageProcessors: [ImageProcessing] {
        return [ImageProcessors.Resize(size: pixelSize, contentMode: .aspectFit)]
    }

    private let appSettings = AppSettings.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appSettings.tableColor
        let swipeRightGestureRecognizer =
            UISwipeGestureRecognizer(target: self,
                                     action: #selector(swipeRight(sender:)))
        swipeRightGestureRecognizer.direction = .right
        let swipeLeftGestureRecognizer =
            UISwipeGestureRecognizer(target: self,
                                     action: #selector(swipeLeft(sender:)))
        swipeLeftGestureRecognizer.direction = .left
        view.addGestureRecognizer(swipeRightGestureRecognizer)
        view.addGestureRecognizer(swipeLeftGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        index = photos!.firstIndex { $0.id == photoID }!
        loadPhoto()
    }
}

extension PhotoViewController {
    private func getUrl() -> URL? {
        let fullImageList = photos![index].images.sorted(by: { $0.width > $1.width })
        var filteredImageList = fullImageList.filter {
            sessionSettings.enabledPhotoType.contains($0.type!) &&
                (CGFloat($0.width) >= imageView.bounds.width ||
                    CGFloat($0.height) >= imageView.bounds.height)
        }
        if filteredImageList.isEmpty { filteredImageList = fullImageList }
        guard let url = URL(string: filteredImageList.first!.imageUrl!)
        else { return nil }
        return url
    }

    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        if !photos!.isEmpty, index > photos!.startIndex {
            var toImage: UIImage?
            index -= 1
            guard let url = getUrl() else { return }
            ImagePipeline.shared.loadImage(with: url) {
                [weak self] response in
                guard let self = self else { return }
                switch response {
                case .failure:
                    toImage = UIImage(named: "unknown")
                case let .success(imageResponse):
                    toImage = imageResponse.image
                }
                self.animateSwipe(direction: .right,
                                  fromImage: self.imageView.image!,
                                  toImage: toImage!)
            }
        }
    }

    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        if !photos!.isEmpty, index < photos!.endIndex - 1 {
            var toImage: UIImage?
            index += 1
            guard let url = getUrl() else { return }
            ImagePipeline.shared.loadImage(with: url) {
                [weak self] response in
                guard let self = self else { return }
                switch response {
                case .failure:
                    toImage = UIImage(named: "unknown")
                case let .success(imageResponse):
                    toImage = imageResponse.image
                }
                self.animateSwipe(direction: .left,
                                  fromImage: self.imageView.image!,
                                  toImage: toImage!)
            }
        }
    }

    func animateSwipe(direction: Direction, fromImage: UIImage, toImage: UIImage) {
        let directionFactor: CGFloat = direction == .left ? -1.0 : 1.0
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveLinear]) {
            self.imageView.center.x += directionFactor * self.imageView.bounds.width
        }
        completion: { _ in
            self.imageView.image = toImage
            self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.imageView.center.x -= directionFactor * self.imageView.bounds.width
            self.imageView.alpha = 0.1
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: [.curveLinear],
                animations: {
                    self.imageView.alpha = 1.0
                    self.imageView.transform = .identity
                }
            )
        }
    }

    private func loadPhoto() {
        guard let url = getUrl() else { return }
        let options = ImageLoadingOptions(placeholder: UIImage(named: "unknown"),
                                          transition: .fadeIn(duration: 0.5),
                                          failureImage: UIImage(named: "unknown"),
                                          failureImageTransition: .fadeIn(duration: 0.5))
        let request = ImageRequest(url: url,
                                   processors: resizedImageProcessors)
        Nuke.loadImage(with: request, options: options, into: imageView)
    }
}
