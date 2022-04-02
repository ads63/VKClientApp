//
//  FriendDetailsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 26.08.2021.
//

import RealmSwift
import UIKit

class FriendDetailsCollectionViewController: UICollectionViewController {
    var userID: Int?
    var photos: [PhotoViewModel]?
    var photoID: Int?
    private let photoViewModelFactory = PhotoViewModelFactory()
    private let appSettins = AppSettings.instance
    private let cellSpacing: CGFloat = 1
    private let columns: CGFloat = 3
    private var cellSize: CGFloat?
    private var viewSize: CGSize {
        return CGSize(width: cellSize ?? CGFloat(0.0) * UIScreen.main.scale,
                      height: cellSize ?? CGFloat(0.0) * UIScreen.main.scale)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        cellSize = calcCellSize()
        loadUserPhoto(userID: userID!)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int
    {
        guard let count = photos?.count else { return 0 }
        return count
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
        cell.parentViewController = self
        cell.configure(photo: photos?[indexPath.row], size: viewSize)
        return cell
    }

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
        return viewSize
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
    private func calcCellSize() -> CGFloat? {
        if let _ = cellSize { return cellSize }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let emptySpace = layout.sectionInset.left
                + layout.sectionInset.right + (columns - 1) * cellSpacing
            cellSize = ceil((view.frame.size.width - emptySpace) / columns)
        }
        return cellSize
    }

    private func loadUserPhoto(userID: Int) {
        let size = viewSize
        let largeSize = viewSize
        appSettins.apiAdapter.getUserPhotos(userID: userID, completion: {
            [weak self] photos in
            self?.photos = self?.photoViewModelFactory
                .constructViewModels(photos: photos,
                                     viewSize: size,
                                     largeViewSize: largeSize)
            self?.collectionView.reloadData()
        })
    }

    func tapCell(cell: FriendCollectionViewCell) {
        openPhotoCollection(indexPath: collectionView.indexPath(for: cell)!)
    }

    private func openPhotoCollection(indexPath: IndexPath) {
        photoID = photos![indexPath.row].id
        performSegue(
            withIdentifier: "photoViewSegue",
            sender: nil
        )
    }
}
