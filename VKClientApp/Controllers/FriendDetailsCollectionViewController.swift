//
//  FriendDetailsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 26.08.2021.
//

import Nuke
import UIKit

class FriendDetailsCollectionViewController: UICollectionViewController {
    private let appSettins = AppSettings.instance
    private let realmService = SessionSettings.instance.realmService
    var userID: Int?
    var photos = [Photo]()
    var photoID: Int?
    let cellSpacing: CGFloat = 1
    let columns: CGFloat = 3
    var cellSize: CGFloat = 100

    var pixelSize: CGFloat {
        return cellSize * UIScreen.main.scale
    }

    var resizedImageProcessors: [ImageProcessing] {
        let imageSize = CGSize(width: pixelSize, height: pixelSize)
        return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let flowLayout = collectionView?.collectionViewLayout
//            as? UICollectionViewFlowLayout
//        {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
        collectionView.register(
            UINib(
                nibName: "FriendCollectionViewCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "friendDetailsCell"
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let flowLayout = collectionView?.collectionViewLayout
//            as? UICollectionViewFlowLayout
//        {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
        calcCellSize()
        loadUserPhoto(userID: userID!)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int
    {
        photos.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell
    {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "friendDetailsCell",
                for: indexPath
            ) as? FriendCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        guard let url = getUrl(index: indexPath.row,
                               width: cell.bounds.width,
                               height: cell.bounds.height) else { return cell }
        let options = ImageLoadingOptions(placeholder: UIImage(named: "unknown"),
                                          transition: .fadeIn(duration: 0.5),
                                          failureImage: UIImage(named: "unknown"),
                                          failureImageTransition: .fadeIn(duration: 0.5))
        let request = ImageRequest(url: url,
                                   processors: resizedImageProcessors)
        Nuke.loadImage(with: request, options: options, into: cell.photoImage)
        cell.configure(parentViewController: self)
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         return true
     }
     */

    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         return true
     }
     */

    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
         return false
     }

     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return false
     }

     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

     }
     */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photoVC = segue.destination
            as? PhotoViewController else { return }
        photoVC.photoID = photoID
        photoVC.photos = photos
    }
}

// MARK: Collection View Delegate Flow Layout Methods

extension FriendDetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        calcCellSize()
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return cellSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return cellSpacing
    }
}

extension FriendDetailsCollectionViewController {
    private func calcCellSize() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let emptySpace = layout.sectionInset.left
                + layout.sectionInset.right + (columns - 1) * cellSpacing
            cellSize = (view.frame.size.width - emptySpace) / columns
        }
    }

    private func loadUserPhoto(userID: Int) {
        appSettins.apiService.getUserPhotos(userID: userID) {
            [weak self] in
            self?.photos = (self?.realmService.selectPhotos())!
            self?.collectionView?.reloadData()
        }
    }

    func tapCell(cell: FriendCollectionViewCell) {
        openPhotoCollection(indexPath: collectionView.indexPath(for: cell)!)
    }

    private func openPhotoCollection(indexPath: IndexPath) {
        photoID = photos[indexPath.row].id
        performSegue(
            withIdentifier: "photoViewSegue",
            sender: nil
        )
    }

    private func getUrl(index: Int, width: CGFloat, height: CGFloat) -> URL? {
        let fullImageList = photos[index].images.sorted(by: { $0.width > $1.width })
        var filteredImageList = fullImageList
            .filter { CGFloat($0.width) >= width || CGFloat($0.height) >= height }
        if filteredImageList.isEmpty { filteredImageList = fullImageList }
        guard let url = URL(string: filteredImageList.first!.imageUrl!)
        else { return nil }
        return url
    }
}
