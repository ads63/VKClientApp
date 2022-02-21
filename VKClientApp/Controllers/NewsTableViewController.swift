//
//  NewsTableViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.11.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    private var dataProvider: NewsDataProvider?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider = NewsDataProvider(controller: self)
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
        tableView.delegate = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        dataProvider?.getNews()
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataProvider?.getSectionsCount() ?? 0
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return dataProvider?.getRowsCount(section: section) ?? 0
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = getCell(indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(news: dataProvider?.getRow(section: indexPath.section,
                                                  row: indexPath.row))
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
}

extension NewsTableViewController {
    private func getCell(indexPath: IndexPath) -> CellConfigurationProtocol? {
        if let type = dataProvider?
            .getRow(section: indexPath.section, row: indexPath.row)?.cellType
        {
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
        return nil
    }
}

enum CellType: String {
    case source = "sourceCell"
    case text = "textCell"
    case image = "imageCell"
    case likes = "likesCell"
}
