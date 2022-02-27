//
//  NewsTextCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 14.01.2022.
//

import UIKit

class NewsTextCell: UITableViewCell, CellConfigurationProtocol {
    var text = ""
    @IBOutlet var newsText: UILabel!

    func configure(news: NewsRow?, isExpanded: Bool = false) {
        guard let news = news else { return }
        text = news.text ?? ""
        if text.count > 200 && isExpanded == false {
            setText(text: String(text.prefix(200)) + "...")
        } else { setText(text: text) }
    }

    private func setText(text: String?) {
        guard let text = text else { return }
        newsText.text = text
        let currentSize = newsText.frame.size
        let neededSize = newsText
            .sizeThatFits(CGSize(width: currentSize.width,
                                 height: CGFloat.greatestFiniteMagnitude))

        newsText.frame.size = neededSize
        frame.size = neededSize
        contentView.frame.size = neededSize
    }
}
