//
//  GroupsViewCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 27.08.2021.
//

import UIKit
import Nuke

class GroupsViewCell: UITableViewCell {
    var parentTableViewController: CroupsViewControllerProtocol?
    var cellColor: UIColor?
    var selectedColor: UIColor?
    var background_alpha: CGFloat = 1.0
    @IBOutlet var groupImage: UIImageView!
    @IBOutlet var groupLabel: UILabel!

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
    func configure(controller: CroupsViewControllerProtocol?,
                   cellColor: UIColor, selectColor: UIColor,
                   group: Group)
    {
        parentTableViewController = controller
        groupLabel.text = group.groupName
        let tapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(tapCell(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
        self.cellColor = cellColor
        selectedColor = selectColor
        backgroundConfiguration?.backgroundColor = cellColor
        guard let url = URL(string: group.avatarURL!) else {return}
        Nuke.loadImage(with: url, into: groupImage)
//        let imageSize = CGSize(width: groupImage.bounds.size.width * 0.6,
//                               height: groupImage.bounds.size.height * 0.6)
//        groupImage.image?.scalePreservingAspectRatio(targetSize: imageSize)

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
