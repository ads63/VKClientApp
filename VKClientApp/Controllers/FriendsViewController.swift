//
//  FriendsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 23.08.2021.
//

import UIKit

class FriendsViewController: UITableViewController {
    @IBOutlet var tableHeader: FriendsTableHeader!

    private var friends = [User]()
    private let appSettings = AppSettings.instance
    private let realmService = SessionSettings.instance.realmService
    private var groupedFriends: [Character: [User]] {
        return Dictionary(grouping: friends, by: { $0.userName.uppercased().first! })
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
        tableView.backgroundColor = appSettings.tableColor
        tableHeader.backgroundColor = appSettings.tableColor
        tableHeader.headerLabel.text = "My friends"
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
        cell.configure(controller: self, user: user, color: appSettings.tableColor)
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
        header.configure(text: String(groupKeys[section]),
                         color: appSettings.tableColor.withAlphaComponent(0.5))
        return header
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendVC = segue.destination
            as? FriendDetailsCollectionViewController else { return }
        friendVC.userID = friendID
    }
}

extension FriendsViewController {
    func getFriends() {
        appSettings.apiService.getFriends(completion: {
            [weak self] in
            self?.friends = (self?.realmService.selectUsers())!
            self?.tableView.reloadData()
        })
    }
}
