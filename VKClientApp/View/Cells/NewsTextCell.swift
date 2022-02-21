//
//  NewsTextCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.01.2022.
//

import UIKit

class NewsTextCell: UITableViewCell, CellConfigurationProtocol {
    @IBOutlet var newsText: UILabel!

    func configure(news: NewsRow?) {
        guard let news = news else { return }
        newsText.text = news.text
        let currentSize = newsText.frame.size
        let neededSize = newsText
            .sizeThatFits(CGSize(width: currentSize.width,
                                 height: CGFloat.greatestFiniteMagnitude))
        frame.size = neededSize
        contentView.frame.size = neededSize
        newsText.frame.size = neededSize
    }
}
