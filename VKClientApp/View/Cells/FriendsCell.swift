//
//  FriendsCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 26.08.2021.
//

import UIKit

class FriendsCell: UITableViewCell {
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nickNameLabel: UILabel!
    
    func configure(user: User) {
        avatarImage.image = user.avatar
        nickNameLabel.text = user.userName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
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
}
