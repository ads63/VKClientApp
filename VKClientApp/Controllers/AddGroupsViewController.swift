//
//  AddGroupsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 30.08.2021.
//

import UIKit

class AddGroupsViewController: GroupsViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = Groups.filter2Join
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        Groups.joinGroups(indexes: selectedIndexes.map { $0.row })
        selectedIndexes.removeAll()
        return Groups.getGroups2Join().count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "groupsListCell",
            for: indexPath) as? GroupsViewCell
        else { return UITableViewCell() }
        cell.configure(controller: self,
                       cellColor: tableColor,
                       selectColor: selectColor,
                       group: Groups.getGroups2Join()[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int)
    {
        let headerView = view as! UITableViewHeaderFooterView
        setHeaderFooter(view: headerView, text: "swipe left to join the selected groups")
    }

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
    override func searchBar(_ searchBar: UISearchBar,
                            textDidChange searchText: String)
    {
        Groups.filter2Join = searchText
        tableView.reloadData()
    }
}
