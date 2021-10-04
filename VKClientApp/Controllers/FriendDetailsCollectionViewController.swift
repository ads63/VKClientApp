//
//  FriendDetailsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 26.08.2021.
//

import UIKit

class FriendDetailsCollectionViewController: UICollectionViewController {
    var userID: Int?
    var imageSize: [CGSize] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionView?.collectionViewLayout
            as? UICollectionViewFlowLayout
        {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        collectionView.register(
            UINib(
                nibName: "FriendCollectionViewCell",
                bundle: nil),
            forCellWithReuseIdentifier: "friendDetailsCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageSize.removeAll()
        for image in Users.getPhoto(userID: userID) {
            imageSize.append(collectionView.sizeThatFits(image.photoImage!.size))
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int
    {
        Users.getPhoto(userID: userID).count
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

        cell.configure(userImages: Users.getPhoto(userID: userID), index: indexPath.row)

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
//        collectionView.sizeThatFits(<#T##size: CGSize##CGSize#>)
        collectionView.bounds.size
//        CGSize(width: 170.0, height: 170.0)
    }
}
