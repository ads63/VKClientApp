//
//  FriendsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 23.08.2021.
//

import UIKit

class FriendsViewController: UITableViewController {
    private let tableColor = UIColor.systemTeal
    private var friends: [User] = [User(id: 0, avatar: UIImage(named: "batman"),
                                        userName: "batman"),
                                   User(id: 1, avatar: UIImage(named: "egghead"),
                                        userName: "egghead"),
                                   User(id: 2, avatar: UIImage(named: "deadhead"),
                                        userName: "deadhead"),
                                   User(id: 3, avatar: UIImage(named: "guy"),
                                        userName: "guy"),
                                   User(id: 4, avatar: UIImage(named: "batman"),
                                        userName: "batman2"),
                                   User(id: 5, avatar: UIImage(named: "egghead"),
                                        userName: "egghead2"),
                                   User(id: 6, avatar: UIImage(named: "deadhead"),
                                        userName: "deadhead2"),
                                   User(id: 7, avatar: UIImage(named: "guy"),
                                        userName: "guy2")]
    private lazy var groupedFriends: [Character: [User]] =
        Dictionary(grouping: friends, by: { $0.userName.uppercased().first! })
    private lazy var groupKeys: [Character] = groupedFriends.keys
        .sorted(by: { $0 < $1 })
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
        tableView.backgroundColor = tableColor
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
        cell.configure(controller: self, user: user, color: tableColor)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendVC = segue.destination
            as? FriendDetailsCollectionViewController else { return }
        friendVC.userID = friendID
    }

    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView?
    {
        guard let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: "friendsSectionHeader")
            as? FriendsSectionHeader
        else { return UITableViewHeaderFooterView() }
        header.configure(text: String(groupKeys[section]),
                         color: tableColor.withAlphaComponent(0.5))
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

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
