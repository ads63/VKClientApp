//
//  FriendsCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 26.08.2021.
//

import UIKit

class FriendsCell: UITableViewCell {
    var parentTableViewController: FriendsViewController?

    @IBOutlet var shadowView: ShadowView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var friendNameLabel: UILabel!

    @IBInspectable var shadowColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0.9 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2,
                                                                     left: 0,
                                                                     bottom: 2,
                                                                     right: 0))
    }

    func configure(controller: FriendsViewController, user: User, color: UIColor) {
        parentTableViewController = controller
        avatarImage.image = user.avatar
        friendNameLabel.text = user.userName
        backgroundConfiguration?.backgroundColor = color
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(tapCell(sender:)))
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addGestureRecognizer(tapGestureRecognizer)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let cornerRadius: CGFloat = shadowView.bounds.width / 2.0
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = cornerRadius
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 5.0, height: 0.0)
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowOpacity = shadowOpacity

        avatarImage.layer.cornerRadius = cornerRadius
        avatarImage.layer.masksToBounds = true
    }

    @objc func tapCell(sender: UITapGestureRecognizer) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.005,
            initialSpringVelocity: 1.0,
            options: [
                .curveEaseOut
            ]) {
            self.shadowView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            self.shadowView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.parentTableViewController?.tapCell(cell: self)
        }
    }
}
