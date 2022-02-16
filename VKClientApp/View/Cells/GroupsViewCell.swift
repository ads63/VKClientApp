//
//  GroupsViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 27.08.2021.
//

import UIKit

class GroupsViewCell: UITableViewCell {
    var parentTableViewController: CroupsViewControllerProtocol?
    var cellColor: UIColor?
    var selectedColor: UIColor?
    var background_alpha: CGFloat = 1.0
    @IBOutlet var groupImage: UIImageView!
    @IBOutlet var groupLabel: UILabel!

    func configure(group: Group) {
        groupLabel.text = group.groupName
        let tapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(tapCell(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
        cellColor = UIColor.systemTeal
        selectedColor = UIColor.systemGray
        backgroundConfiguration?.backgroundColor = cellColor
        groupLabel.backgroundColor = cellColor
        guard let url = URL(string: group.avatarURL!) else { return }
        groupImage.load(url: url)
    }

    @objc func tapCell(sender: UITapGestureRecognizer) {
        if parentTableViewController?.isSelectionEnabled ?? false {
            backgroundConfiguration?.backgroundColor =
                backgroundConfiguration?.backgroundColor == cellColor ?
                selectedColor : cellColor
            groupLabel.backgroundColor = backgroundConfiguration?.backgroundColor
        }
        parentTableViewController?.tapCell(cell: self)
    }
}
