//
//  GroupsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 27.08.2021.
//

import UIKit

class GroupsViewController: UITableViewController {
    @IBOutlet var searchBar: UISearchBar!
    
    var selectedIndexes = Set<IndexPath>()
    let appSettings = AppSettings.instance
    var filterJoined = ""
    var groups = [Group]()
    var displayedGroups: [Group] {
        return groups.filter { self.filterJoined.isEmpty ||
            $0.groupName!.lowercased().contains(self.filterJoined.lowercased())}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.showsScopeBar = true
        searchBar.delegate = self
        tableView.register(
            UINib(
                nibName: "GroupsViewCell",
                bundle: nil),
            forCellReuseIdentifier: "groupsListCell")
        tableView.backgroundColor = appSettings.tableColor

//        APIService().getUserGroups(){
//            [weak self] dataArray in
//            self?.data.groups = dataArray
//            self?.tableView.reloadData()
//        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = filterJoined
        loadJoinedGroups()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat
    {
        25.0
    }

    override func tableView(_ tableView: UITableView,
                            heightForFooterInSection section: Int) -> CGFloat
    {
        25.0
    }

    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int)
    {
        let headerView = view as! UITableViewHeaderFooterView
        setHeaderFooter(view: headerView,
                        text: "swipe left to leave the selected groups")
    }

    override func tableView(_ tableView: UITableView,
                            willDisplayFooterView view: UIView,
                            forSection section: Int)
    {
        let headerView = view as! UITableViewHeaderFooterView
        setHeaderFooter(view: headerView,
                        text: "tap for group selection or deselection")
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        leaveGroups(indexes: selectedIndexes.map { $0.row })
        selectedIndexes.removeAll()
        return displayedGroups.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "groupsListCell",
            for: indexPath) as? GroupsViewCell
        else { return UITableViewCell() }

        cell.configure(controller: self,
                       cellColor: appSettings.tableColor,
                       selectColor: appSettings.selectColor,
                       group: displayedGroups[indexPath.row])
        return cell
    }

    /*
      Override to support conditional editing of the table view.
     */
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool
    {
//          Return false if you do not want the specified item to be editable.
        return true
    }

    /*
     // Override to support editing the table view.
     */
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: selectedIndexes.map { $0 }, with: .fade)
        }
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
}

extension GroupsViewController: UISearchBarDelegate {
//    internal func  searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        filterJoined = searchBar.searchTextField.text ?? ""
//        loadJoinedGroups()
//    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filterJoined = searchText
            tableView.reloadData()
    }
}

extension GroupsViewController: CroupsViewControllerProtocol {
    func tapCell(cell: GroupsViewCell) {
        if !selectedIndexes.contains(tableView.indexPath(for: cell)!) {
            selectedIndexes.insert(tableView.indexPath(for: cell)!)
        } else {
            selectedIndexes.remove(tableView.indexPath(for: cell)!)
        }
    }

    func setHeaderFooter(view: UITableViewHeaderFooterView, text: String) {
        let borderTop = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: tableView.bounds.size.width,
                                             height: 1.0))
        let borderBottom = UIView(frame: CGRect(x: 0,
                                                y: view.bounds.height,
                                                width: tableView.bounds.size.width,
                                                height: 1.0))
        borderTop.backgroundColor = UIColor.separator
        borderBottom.backgroundColor = UIColor.separator
        view.addSubview(borderTop)
        view.addSubview(borderBottom)
        view.tintColor = appSettings.tableColor
        view.textLabel?.adjustsFontSizeToFitWidth = true
        view.textLabel?.textAlignment = .center
        view.textLabel?.text = text
    }
}

extension GroupsViewController {

    func loadJoinedGroups() {
        appSettings.apiService.getUserGroups {
            [weak self] groupsArray in
            self?.groups = groupsArray
            self?.tableView.reloadData()
        }
    }

    func leaveGroup(index: Int) {
        var apiResult = true
        let id = displayedGroups[index].id
        appSettings.apiService.leaveGroup(id: id) {
            result in

            apiResult = result
        }
        if apiResult {
            for i in 0 ..< groups.count {
                if displayedGroups[index] == groups[i] {
                    groups.remove(at: i)
                    return
                }
            }
        }
    }

    func leaveGroups(indexes: [Int]) {
        for index in indexes {
            leaveGroup(index: index)
        }
    }
}

