//
//  FriendDetailsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 26.08.2021.
//

import UIKit

class FriendDetailsCollectionViewController: UICollectionViewController {
    var userID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            UINib(
                nibName: "FriendCollectionViewCell",
                bundle: nil),
            forCellWithReuseIdentifier: "friendDetailsCell")
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "friendDetailsCell",
                for: indexPath) as? FriendCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        cell.configure(userImage: getPhoto(userID: userID))

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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150.0, height: 150.0)
    }
}

extension FriendDetailsCollectionViewController {
    // simulate get photo by userID from backend
    func getPhoto(userID: Int?) -> UIImage {
        let pictures = [-1: UIImage(named: "unknown"),
                        0: UIImage(named: "batman"),
                        1: UIImage(named: "egghead"),
                        2: UIImage(named: "deadhead"),
                        3: UIImage(named: "guy")]
        guard let image = pictures[userID ?? -1] else {
            return pictures[-1]!!
        }
        return image!
    }
}
