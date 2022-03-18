//
//  NewsSourceCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 18.11.2021.
//

import UIKit

class NewsSourceCell: UITableViewCell, CellConfigurationProtocol {
    @IBOutlet var sourceName: UILabel!
    @IBOutlet var sourceImage: UIImageView!
    @IBOutlet var sourceDate: UILabel!

    func configure(news: NewsViewModel?, isExpanded: Bool = false) {
        guard let news = news else { return }
        self.sourceName.text = news.srcName
        self.sourceDate.text = news.date
        guard let url = news.photo else { return }
        self.sourceImage.load(url: url)
        self.sourceName.backgroundColor = UIColor.appBackground
        self.sourceDate.backgroundColor = UIColor.appBackground
        self.sourceImage.backgroundColor = UIColor.appBackground
        self.contentView.backgroundColor = UIColor.appBackground
    }
}
