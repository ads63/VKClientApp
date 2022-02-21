//
//  PhotoService.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 09.02.2022.
//

import Alamofire
import UIKit

class PhotoService {
    private let cacheLifeTime: TimeInterval = 12*60*60
    private let garbageCollectorInterval: TimeInterval = 1*60*60

    private var images = [String: UIImage]()
    private static var lastGarbageCollectorSession = Date()
    private static var isGarbageCollectorStarted = false

    private static let pathName: String = {
        let pathName = "images"

        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                             in: .userDomainMask)
            .first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName,
                                                         isDirectory: true)

        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default
                .createDirectory(at: url,
                                 withIntermediateDirectories: true,
                                 attributes: nil)
        }

        return pathName
    }()

    private func getCachePath() -> URL? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                             in: .userDomainMask)
            .first else { return nil }
        return cachesDirectory.appendingPathComponent(PhotoService.pathName)
    }

    private func getFilePath(url: String) -> URL? {
        guard let path = getCachePath() else { return nil }
        let hashName = String(url.split(separator: "/").last ?? "default")
        let url = path.appendingPathComponent(hashName)
        return url
    }

    private func saveImageToCache(url: String,
                                  image: UIImage,
                                  collector: Bool = true)
    {
        guard let fileName = getFilePath(url: url),
              let data = image.pngData() else { return }
        FileManager.default.createFile(atPath: fileName.path,
                                       contents: data,
                                       attributes: nil)
        if collector { garbageCollect() }
    }

    private func garbageCollect() {
        let intervalSinceLastGarbageCollect = -PhotoService
            .lastGarbageCollectorSession
            .timeIntervalSinceNow
        if PhotoService.isGarbageCollectorStarted ||
            intervalSinceLastGarbageCollect < garbageCollectorInterval { return }
        PhotoService.isGarbageCollectorStarted = true
        DispatchQueue.global(qos: .background).async {
            let date = Date()
            let manager = FileManager.default
            guard let cachePath = self.getCachePath(),
                  let fileNames = try? manager
                  .contentsOfDirectory(atPath: cachePath.path)
            else { return }
            for fileName in fileNames {
                if let filePath = self.getFilePath(url: fileName),
                   let info = try? manager
                   .attributesOfItem(atPath: filePath.path),
                   let modificationDate =
                   info[FileAttributeKey.modificationDate] as? Date
                {
                    let lifeTime = date.timeIntervalSince(modificationDate)
                    if lifeTime > self.cacheLifeTime {
                        try? manager.removeItem(at: filePath)
                    }
                }
            }
            PhotoService.lastGarbageCollectorSession = Date()
            PhotoService.isGarbageCollectorStarted = false
        }
    }

    private func getImageFromCache(url: String) -> UIImage? {
        guard let fileName = getFilePath(url: url),
              let info = try? FileManager.default
              .attributesOfItem(atPath: fileName.path),
              let modificationDate =
              info[FileAttributeKey.modificationDate] as? Date
        else { return nil }
        let lifeTime = Date().timeIntervalSince(modificationDate)
        guard lifeTime <= cacheLifeTime,
              let image = UIImage(contentsOfFile: fileName.path)
        else { return nil }
        DispatchQueue.main.async { self.images[url] = image }
        return image
    }

    private func setImage(toImageView: UIImageView, images: [UIImage?]?) {
        if let images = images {
            for image in images {
                if let image = image {
                    DispatchQueue.main.async { toImageView.image = image }
                    return
                }
            }
        }
    }

    private func loadPhoto(toImageView: UIImageView? = nil,
                           url: String,
                           images: [UIImage?])
    {
        if let cachedImage = images[1] {
            DispatchQueue.main.async { toImageView?.image = cachedImage }
            return
        }
        // set placeholder while real image load in progress
        DispatchQueue.main.async { toImageView?.image = images[0] }

        AF.request(url).responseData(queue:
            DispatchQueue.global(qos: .userInitiated)) {
                [weak self] response in
                guard
                    let data = response.data,
                    let image = UIImage(data: data)
                else {
                    if let onFailure = images[2] { toImageView?.image = onFailure }
                    return
                }
                DispatchQueue.main.async {
                    self?.images[url] = image
                    toImageView?.image = image
                }
                self?.saveImageToCache(url: url, image: image)
        }
    }

    func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let image = images[url] ?? getImageFromCache(url: url) {
            DispatchQueue.main.async { completion(image) }
        } else {
            AF.request(url).responseData(queue:
                DispatchQueue.global(qos: .userInitiated)) {
                    [weak self] response in
                    guard
                        let data = response.data,
                        let image = UIImage(data: data)
                    else {
                        DispatchQueue.main.async { completion(nil) }
                        return
                    }
                    DispatchQueue.main.async {
                        self?.images[url] = image
                        completion(image)
                    }
                    self?.saveImageToCache(url: url, image: image)
            }
        }
    }

    func loadImage(placeholderImage: UIImage? = nil,
                   toImageView: UIImageView?,
                   url: String,
                   onFailureImage: UIImage? = nil)
    {
        let images: [UIImage?] = [placeholderImage,
                                  self.images[url] ?? getImageFromCache(url: url),
                                  onFailureImage]
        loadPhoto(toImageView: toImageView, url: url, images: images)
    }
}
