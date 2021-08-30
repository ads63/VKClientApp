//
//  FriendsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 23.08.2021.
//

import Foundation
import UIKit

class FriendsViewController: UITableViewController {
    private var friends = [0: User(avatar: UIImage(named: "batman"),
                                   userName: "batman"),
                           1: User(avatar: UIImage(named: "egghead"),
                                   userName: "egghead"),
                           2: User(avatar: UIImage(named: "deadhead"),
                                   userName: "deadhead"),
                           3: User(avatar: UIImage(named: "guy"),
                                   userName: "guy"),
                           4: User(avatar: UIImage(named: "batman"),
                                   userName: "batman2"),
                           5: User(avatar: UIImage(named: "egghead"),
                                   userName: "egghead2"),
                           6: User(avatar: UIImage(named: "deadhead"),
                                   userName: "deadhead2"),
                           7: User(avatar: UIImage(named: "guy"),
                                   userName: "guy2")]
    private var friendID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            UINib(
                nibName: "FriendsCell",
                bundle: nil),
            forCellReuseIdentifier: "friendsListCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        friends.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "friendsListCell",
            for: indexPath) as? FriendsCell
        else { return UITableViewCell() }

        cell.configure(user: friends[indexPath.row]!)

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)
    {
        defer { tableView.deselectRow(
            at: indexPath,
            animated: true)
        }
        friendID = indexPath.row
        performSegue(
            withIdentifier: "photoSegue",
            sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let friendVC = segue.destination
            as? FriendDetailsCollectionViewController else { return }
        friendVC.userID = friendID
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
