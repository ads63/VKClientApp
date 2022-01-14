//
//  AddGroupsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 30.08.2021.
//

import RealmSwift
import UIKit

class AddGroupsViewController: UITableViewController {
    @IBOutlet var searchBar: UISearchBar!

    private var token: NotificationToken?
    private let appSettings = AppSettings.instance
    private let sessionSettings = SessionSettings.instance
    private let realmService = SessionSettings.instance.realmService
    var selectedIndexes = Set<IndexPath>()
    var groups: Results<Group>?
    var displayedGroups: [Group] {
        return [Group](groups!).filter { (sessionSettings.filter2Join.isEmpty ||
                $0.groupName!.lowercased()
                .contains(sessionSettings.filter2Join.lowercased())) &&
            $0.isJoinCandidate
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(
            UINib(
                nibName: "GroupsViewCell",
                bundle: nil),
            forCellReuseIdentifier: "groupsListCell")
        tableView.backgroundColor = appSettings.tableColor
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        groups = realmService.selectNotMineGroups()
        observeGroups()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = sessionSettings.filter2Join
        loadGroups2Join(filter: sessionSettings.filter2Join) // from REST API
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionSettings.filter2Join = searchBar.text ?? ""
    }

    // MARK: - Table view data source

    // ----------------------------

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat
    {
        25.0
    }

    /*
      Override to support conditional editing of the table view.
     */
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool
    {
        //          Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return displayedGroups.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "groupsListCell",
            for: indexPath) as? GroupsViewCell
        else { return UITableViewCell() }
        cell.parentTableViewController = self
        cell.configure(cellColor: appSettings.tableColor,
                       selectColor: appSettings.selectColor,
                       group: displayedGroups[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int)
    {
        let headerView = view as! UITableViewHeaderFooterView
        setHeaderFooter(view: headerView,
                        text: "tap a new group to join")
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

extension AddGroupsViewController: UISearchBarDelegate {
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        sessionSettings.filter2Join = searchBar.text ?? ""
        loadGroups2Join(filter: sessionSettings.filter2Join)
    }

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String)
    {
        sessionSettings.filter2Join = searchText
        tableView.reloadData()
    }
}

extension AddGroupsViewController: CroupsViewControllerProtocol {
    func tapCell(cell: GroupsViewCell) {
        let indexPath = tableView.indexPath(for: cell)!
        joinGroup(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
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

extension AddGroupsViewController {
    func loadGroups2Join(filter: String = "") {
        appSettings.apiService.searchGroups(searchString: filter)
    }

    func joinGroup(index: Int) {
        let currentGroups = displayedGroups
        appSettings.apiService.joinGroup(id: currentGroups[index].id)
        realmService.deleteGroup(groupID: currentGroups[index].id)
    }

    func observeGroups() {
        token = realmService.selectNotMineGroups()!
            .observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update:
                    tableView.reloadData()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
    }
}
