//
//  GroupsViewController.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 27.08.2021.
//

import RealmSwift
import UIKit

class GroupsViewController: UITableViewController {
    @IBOutlet var searchBar: UISearchBar!

    private var token: NotificationToken?
    internal var selectedIndexes = Set<IndexPath>()
    private let groupViewModelFactory = GroupViewModelFactory()
    private let appSettings = AppSettings.instance
    private let sessionSettings = SessionSettings.instance
    private var groups = [GroupViewModel]()
    private var displayedGroups: [GroupViewModel] {
        return groups.filter { sessionSettings.filterJoined.isEmpty ||
            $0.name.lowercased()
            .contains(sessionSettings.filterJoined.lowercased())
        }
    }

    let isSelectionEnabled = true

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.backgroundColor = UIColor.appBackground
        tableView.register(
            UINib(
                nibName: "GroupsViewCell",
                bundle: nil),
            forCellReuseIdentifier: "groupsListCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = sessionSettings.filterJoined
        loadJoinedGroups() // from REST API
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionSettings.filterJoined = searchBar.text ?? ""
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
            leaveGroups(indexes: selectedIndexes.map { $0.row })
            selectedIndexes.removeAll()
        }
    }
}

extension GroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sessionSettings.filterJoined = searchText
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
    }
}

extension GroupsViewController {
    func loadJoinedGroups() {
        appSettings.apiAdapter.getUserGroups(completion: {
            [weak self] groups in
            self?.groups = self?.groupViewModelFactory
                .constructViewModels(groups: groups) ?? [GroupViewModel]()
            self?.tableView.reloadData()
        })
    }

    func leaveGroups(indexes: [Int]) {
        let groups2Leave = displayedGroups
            .enumerated()
            .filter { indexes.contains($0.offset) }
            .map { $0.element }
        for group in groups2Leave {
            appSettings
                .apiAdapter
                .leaveGroup(groupID: group.id, completion: {
                    [weak self] groups in
                    self?.groups = self?.groupViewModelFactory
                        .constructViewModels(groups: groups) ?? [GroupViewModel]()
                    self?.tableView.reloadData()
                })
        }
    }
}
