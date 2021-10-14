//
//  FriendDetailsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 26.08.2021.
//

import UIKit

class FriendDetailsCollectionViewController: UICollectionViewController {
    private let appSettins = AppSettings.instance
    var userID: Int?
    var photos = [Photo]()
    var cellSize: CGSize?
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
                bundle: nil),
            forCellWithReuseIdentifier: "friendDetailsCell")
        cellSize = calcCellSize(viewSize: collectionView.bounds.size)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let flowLayout = collectionView?.collectionViewLayout
//            as? UICollectionViewFlowLayout
//        {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
        appSettins.apiService.getUserPhotos(userID: userID!) {
            [weak self] photoArray in
            self?.photos = photoArray
            self?.collectionView?.reloadData()
        }
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
                for: indexPath) as? FriendCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        cell.configure(userImages: photos, index: indexPath.row, cellSize: cellSize!)

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
}

extension FriendDetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return cellSize!
    }
}

extension FriendDetailsCollectionViewController {
    private func calcCellSize(viewSize: CGSize) -> CGSize {
        let imageSize = min(min(100.0, viewSize.width), min(100.0, viewSize.height))

        return CGSize(width: imageSize, height: imageSize)
    }
}
