//
//  FriendsCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 26.08.2021.
//

import UIKit

class FriendsCell: UITableViewCell {
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

    func configure(user: User) {
        avatarImage.image = user.avatar
        friendNameLabel.text = user.userName
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let cornerRadius: CGFloat = shadowView.bounds.width / 2.0
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = cornerRadius
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowOpacity = shadowOpacity

        avatarImage.layer.cornerRadius = cornerRadius
        avatarImage.layer.masksToBounds = true
    }
}
