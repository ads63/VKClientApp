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

    func configure(cellColor: UIColor, selectColor: UIColor,
                   group: Group)
    {
        groupLabel.text = group.groupName
        let tapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(tapCell(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
        self.cellColor = cellColor
        selectedColor = selectColor
        backgroundConfiguration?.backgroundColor = cellColor
        guard let url = URL(string: group.avatarURL!) else { return }
        groupImage.load(url: url)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    @objc func tapCell(sender: UITapGestureRecognizer) {
        backgroundConfiguration?.backgroundColor =
            backgroundConfiguration?.backgroundColor == cellColor ?
            selectedColor : cellColor
        parentTableViewController?.tapCell(cell: self)
    }
}
