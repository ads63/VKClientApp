//
//  FriendsSectionHeader.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 07.09.2021.
//

import UIKit
class FriendsSectionHeader: UITableViewHeaderFooterView {
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(text: String) {
        self.textLabel?.text = text
        self.textLabel?.backgroundColor = self.contentView.backgroundColor
    }
}
