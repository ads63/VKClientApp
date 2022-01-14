//
//  NewsTextCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.01.2022.
//

import UIKit

class NewsTextCell: UITableViewCell, CellConfigurationProtocol {

    @IBOutlet weak var newsText: UILabel!
    func configure(news: NewsRow) {
        newsText.text = news.text
        let currentSize = newsText.frame.size
        let neededSize = newsText.sizeThatFits(CGSize(width: currentSize.width, height: CGFloat.greatestFiniteMagnitude))
        newsText.frame.size = neededSize
        self.contentView.frame.size = neededSize
        

//        newsText.updateConstraintsIfNeeded()
//        backgroundConfiguration?.backgroundColor = AppSettings.instance.selectColor
//        sizeThatFits(ss)
        self.frame.size = neededSize
//        setNeedsUpdateConstraints()
//        updateConstraintsIfNeeded()
        backgroundConfiguration?.backgroundColor = AppSettings.instance.tableColor

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
