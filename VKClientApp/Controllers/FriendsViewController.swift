//
//  FriendsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 23.08.2021.
//

import RealmSwift
import UIKit
class FriendsViewController: UITableViewController {
    @IBOutlet var tableHeader: FriendsTableHeader!


    private var token: NotificationToken?
    private let userViewModelFactory = UserViewModelFactory()
    private let appSettings = AppSettings.instance
    private var friends = [UserViewModel]()
    private var groupedFriends: [Character: [UserViewModel]] {
        return Dictionary(grouping: friends,
                          by: { $0.name.uppercased().first! })
    }

    private var groupKeys: [Character] {
        return groupedFriends.keys.sorted(by: { $0 < $1 })
    }

    private var friendID: Int?

    func openPhotoCollection(indexPath: IndexPath) {
        guard
            let id = groupedFriends[groupKeys[indexPath.section]]?[indexPath.row].id
        else { return }
        friendID = id
        performSegue(
            withIdentifier: "photoSegue",
            sender: nil)
    }

    func tapCell(cell: FriendsCell) {
        openPhotoCollection(indexPath: tableView.indexPath(for: cell)!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: "FriendsSectionHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "friendsSectionHeader")

        tableView.register(
            UINib(
                nibName: "FriendsCell",
                bundle: nil),
            forCellReuseIdentifier: "friendsListCell")
        tableHeader.backgroundColor = UIColor.appBackground
        tableHeader.headerLabel.text = "My friends"
        tableHeader.headerLabel.backgroundColor = UIColor.appBackground
        tableView.backgroundColor = UIColor.appBackground
        tableView.estimatedRowHeight = CGFloat(44.0)
        tableView.rowHeight = CGFloat(44.0)
        tableView.estimatedSectionHeaderHeight = CGFloat(20.0)
        tableView.sectionHeaderHeight = CGFloat(20.0)
        tableView.sectionFooterHeight = CGFloat(1.0)
        tableView.estimatedSectionFooterHeight = CGFloat(1.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        getFriends()
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return groupKeys.count
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        guard let count = groupedFriends[groupKeys[section]]?.count
        else { return 0 }
        return count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "friendsListCell",
            for: indexPath) as? FriendsCell,
            let user = groupedFriends[groupKeys[indexPath.section]]?[indexPath.row]
        else { return UITableViewCell() }
        cell.parentTableViewController = self
        cell.configure(user: user)
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)
    {
        defer { tableView.deselectRow(
            at: indexPath,
            animated: true)
        }
        openPhotoCollection(indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView?
    {
        guard let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: "friendsSectionHeader")
            as? FriendsSectionHeader
        else { return UITableViewHeaderFooterView() }
        header.configure(text: String(groupKeys[section]))
        return header
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendVC = segue.destination
            as? FriendDetailsCollectionViewController else { return }
        friendVC.userID = friendID
    }
}

extension FriendsViewController {
    func getFriends() {
        appSettings.apiAdapter.getFriends(completion: {
            [weak self] users in
            self?.friends = self?.userViewModelFactory.constructViewModels(users: users) ?? [UserViewModel]()
            self?.tableView.reloadData()
        })
    }
}
