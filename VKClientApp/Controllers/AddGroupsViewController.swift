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
    private let groupViewModelFactory = GroupViewModelFactory()
    private let appSettings = AppSettings.instance
    private let sessionSettings = SessionSettings.instance
    let isSelectionEnabled = false
    var groups = [GroupViewModel]()
    var displayedGroups: [GroupViewModel] {
        return groups.filter { sessionSettings.filter2Join.isEmpty ||
            $0.name.lowercased()
            .contains(sessionSettings.filter2Join.lowercased())
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
        tableView.backgroundColor = UIColor.appBackground
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
        cell.configure(group: displayedGroups[indexPath.row])
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
        borderTop.backgroundColor = UIColor.appBorder
        borderTop.isOpaque = true
        borderBottom.backgroundColor = UIColor.appBorder
        borderBottom.isOpaque = true
        view.addSubview(borderTop)
        view.addSubview(borderBottom)
        view.contentView.backgroundColor = UIColor.appBackground
        view.contentView.isOpaque = true
        view.textLabel?.adjustsFontSizeToFitWidth = true
        view.textLabel?.textAlignment = .center
        view.textLabel?.text = text
        view.textLabel?.textColor = UIColor.appHeader
        view.textLabel?.backgroundColor = UIColor.appBackground
        view.textLabel?.isOpaque = true
    }
}

extension AddGroupsViewController {
    func loadGroups2Join(filter: String = "") {
        appSettings
            .apiAdapter
            .searchGroups(searchString: filter,
                          completion: {
                              [weak self] groups in
                              self?.groups = self?.groupViewModelFactory
                                  .constructViewModels(groups: groups?
                                      .filter { $0.isJoinCandidate })
                                  ?? [GroupViewModel]()
                              self?.tableView.reloadData()
                          })
    }

    func joinGroup(index: Int) {
        let currentGroups = displayedGroups
        guard let atPosition = groups
            .firstIndex(where: { $0.id == currentGroups[index].id }) else { return }
        appSettings.apiAdapter.joinGroup(groupID: currentGroups[index].id,
                                         completion: {
                                             [weak self] isJoined in
                                             if isJoined {
                                                 self?.groups.remove(at: atPosition)
                                                 self?.tableView.reloadData()
                                             }
                                         })
    }
}
