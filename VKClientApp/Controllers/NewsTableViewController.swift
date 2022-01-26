//
//  NewsTableViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.11.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    private let appSettings = AppSettings.instance
    private var news = [NewsProtocol]()
    private var users = [User]()
    private var groups = [Group]()
    private var newsSections = [NewsSection]()
    override func viewWillAppear(_ animated: Bool) {
        getNews()
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: "NewsFeedSectionHeaderView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "newsFeedSectionHeader")
        tableView.register(
            UINib(
                nibName: "NewsSourceCell",
                bundle: nil),
            forCellReuseIdentifier: CellType.source.rawValue)
        super.viewDidLoad()
        tableView.register(
            UINib(
                nibName: "NewsTextCell",
                bundle: nil),
            forCellReuseIdentifier: CellType.text.rawValue)
        super.viewDidLoad()
        tableView.register(
            UINib(
                nibName: "NewsImageCell",
                bundle: nil),
            forCellReuseIdentifier: CellType.image.rawValue)
        tableView.register(
            UINib(
                nibName: "NewsLikesCell",
                bundle: nil),
            forCellReuseIdentifier: CellType.likes.rawValue)
        tableView.backgroundColor = appSettings.tableColor
        tableView.delegate = self
        //        self.tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return newsSections.count
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return newsSections[section].newsRows.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = getCell(indexPath: indexPath)
        cell.configure(news: newsSections[indexPath.section].newsRows[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView?
    {
        guard let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: "newsFeedSectionHeader")
        else { return UITableViewHeaderFooterView() }

        return header
    }

    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat
    {
        CGFloat(2)
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension NewsTableViewController {
    private func getCell(indexPath: IndexPath) -> CellConfigurationProtocol {
        let type = newsSections[indexPath.section].newsRows[indexPath.row].cellType!
        switch type {
        case .source:
            return tableView.dequeueReusableCell(withIdentifier: type.rawValue,
                                                 for: indexPath) as! NewsSourceCell
        case .text:
            return tableView.dequeueReusableCell(withIdentifier: type.rawValue,
                                                 for: indexPath) as! NewsTextCell
        case .image:
            return tableView.dequeueReusableCell(withIdentifier: type.rawValue,
                                                 for: indexPath) as! NewsImageCell
        case .likes:
            return tableView.dequeueReusableCell(withIdentifier: type.rawValue,
                                                 for: indexPath) as! NewsLikesCell
        }
    }

    private func getNews() {
        appSettings.apiService.getPostNews(completion: {
            [weak self] dataPost in
            self?.appSettings.apiService.getPhotoNews(completion: {
                [weak self] dataPhoto in
                self?.news.append(contentsOf: dataPost.items)
                self?.users.append(contentsOf: dataPost.profiles)
                self?.groups.append(contentsOf: dataPost.groups)
                self?.news.append(contentsOf: dataPhoto.items)
                self?.users.append(contentsOf: dataPhoto.profiles)
                self?.groups.append(contentsOf: dataPhoto.groups)

                self?.news.sort { $0.getDate() > $1.getDate() }
                self?.setRows()
                self?.tableView.reloadData()
            })
        })
    }

    private func setRows() {
        for newsItem in news {
            switch newsItem.getType() {
            case "post":
                setPostRows(item: newsItem)
            case "photo",
                 "wall_photo":
                setPhotoRows(item: newsItem)
            default:
                break
            }
        }
    }

    private func getAvatarURL(sourceID: Int) -> String? {
        sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.avatarURL :
            users.first(where: { $0.id == sourceID })?.avatarURL
    }

    private func getSourceName(sourceID: Int) -> String? {
        sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.groupName :
            users.first(where: { $0.id == sourceID })?.userName
    }

    private func setPostRows(item: NewsProtocol) {
        guard let postItem = item as? PostNews else { return }
        let section = NewsSection()
        let avatarURL = getAvatarURL(sourceID: postItem.sourceID)
        let srcName = getSourceName(sourceID: postItem.sourceID)
        section.newsRows.append(NewsRow(photo: URL(string: avatarURL!),
                                        srcName: srcName,
                                        date: postItem.formattedDate))
        section.newsRows.append(NewsRow(text: postItem.text))
        for photo in postItem.photos {
            let image = getImage(photo: photo,
                                 width: tableView.bounds.width)
            section.newsRows.append(NewsRow(photo: image.imageURL,
                                            width: image.width,
                                            height: image.height))
        }
        section.newsRows.append(NewsRow(likes: postItem.flags.likesCount,
                                        isLiked: postItem.flags.isLiked,
                                        comments: postItem.flags.commentsCount,
                                        canComment: postItem.flags.canComment,
                                        reposts: postItem.flags.repostsCount,
                                        isReposted: postItem.flags.isReposted))
        newsSections.append(section)
    }

    private func setPhotoRows(item: NewsProtocol) {
        guard let photoItem = item as? PhotoNews else { return }
        let section = NewsSection()
        let sourceID = photoItem.sourceID
        let avatarURL = sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.avatarURL :
            users.first(where: { $0.id == sourceID })?.avatarURL
        let srcName = sourceID < 0 ?
            groups.first(where: { $0.id == -sourceID })?.groupName :
            users.first(where: { $0.id == sourceID })?.userName
        section.newsRows.append(NewsRow(photo: URL(string: avatarURL!),
                                        srcName: srcName,
                                        date: photoItem.formattedDate))
        for photo in photoItem.photos {
            let image = getImage(photo: photo.photo,
                                 width: tableView.bounds.width)
            section.newsRows.append(NewsRow(photo: image.imageURL,
                                            width: image.width,
                                            height: image.height))
            if !photo.text.isEmpty {
                section.newsRows.append(NewsRow(text: photo.text))
            }
            section.newsRows.append(NewsRow(likes: photo.flags.likesCount,
                                            isLiked: photo.flags.isLiked,
                                            comments: photo.flags.commentsCount,
                                            canComment: photo.flags.canComment,
                                            reposts: photo.flags.repostsCount,
                                            isReposted: photo.flags.isReposted))
        }
        newsSections.append(section)
    }

    private func getImage(photo: Photo, width: CGFloat) -> NewsImage {
        let fullImageList = photo.images.sorted(by: { $0.width > $1.width })
        var filteredImageList = fullImageList
            .filter { CGFloat($0.width) >= width }
        if filteredImageList.isEmpty { filteredImageList = fullImageList }
        guard let image = filteredImageList.first
        else { return NewsImage(url: nil, width: 1, height: 1) }
        let url = URL(string: image.imageUrl!)
        return NewsImage(url: url, width: image.width, height: image.height)
    }
}

enum CellType: String {
    case source = "sourceCell"
    case text = "textCell"
    case image = "imageCell"
    case likes = "likesCell"
}
