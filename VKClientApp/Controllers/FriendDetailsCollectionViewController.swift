//
//  FriendDetailsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 26.08.2021.
//

import RealmSwift
import UIKit

class FriendDetailsCollectionViewController: UICollectionViewController {
    private let appSettins = AppSettings.instance
    private let realmService = SessionSettings.instance.realmService
    private var token: NotificationToken?
    var userID: Int?
    var photos: Results<Photo>?
    var photoID: Int?
    let cellSpacing: CGFloat = 1
    let columns: CGFloat = 3
    var cellSize: CGFloat?

    var pixelSize: CGFloat {
        return cellSize ?? 0 * UIScreen.main.scale
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
        photos = realmService.selectPhotos()
        observePhotos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = calcCellSize()
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

        guard let url = getUrl(index: indexPath.row,
                               width: cell.bounds.width,
                               height: cell.bounds.height) else { return cell }
        cell.photoImage.load(url: url,
                             placeholderImage: ImageProvider.get(id: .unknown),
                             failureImage: ImageProvider.get(id: .unknown))
        cell.parentViewController = self
        cell.configure()
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
        guard let size = calcCellSize() else { return CGSize(width: 0.0, height: 0.0) }
        return CGSize(width: size, height: size)
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
        appSettins.apiService.getUserPhotos(userID: userID)
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

    private func getUrl(index: Int, width: CGFloat, height: CGFloat) -> URL? {
        let fullImageList = photos![index].images.sorted(by: { $0.width > $1.width })
        var filteredImageList = fullImageList
            .filter { CGFloat($0.width) >= width || CGFloat($0.height) >= height }
        if filteredImageList.isEmpty { filteredImageList = fullImageList }
        guard let url = URL(string: filteredImageList.first!.imageUrl!)
        else { return nil }
        return url
    }

    func observePhotos() {
        token = realmService.selectPhotos()!.observe {
            [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update:
                collectionView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}
