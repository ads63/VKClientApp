//
//  NewsLikesCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 17.11.2021.
//

import UIKit

class NewsLikesCell: UITableViewCell, CellConfigurationProtocol {
    @IBOutlet var commentsImage: UIImageView!
    @IBOutlet var repostsImage: UIImageView!
    @IBOutlet var likesImage: UIImageView!
    @IBOutlet var commentsCount: UILabel!
    @IBOutlet var repostsCount: UILabel!
    @IBOutlet var likesCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(news: NewsRow?, isExpanded: Bool = false) {
        guard let news = news else { return }
        commentsCount.text = String(news.comments)
        likesCount.text = String(news.likes)
        repostsCount.text = String(news.reposts)
        likesImage.image = news.likes <= 0
            ? UIImage(systemName: "hand.thumbsup")
            : UIImage(systemName: "hand.thumbsup.fill")
        repostsImage.image = news.reposts <= 0
            ? UIImage(systemName: "arrowshape.turn.up.right")
            : UIImage(systemName: "arrowshape.turn.up.right.fill")
        commentsImage.image = news.canComment == 0
            ? UIImage(systemName: "pencil.slash")
            : UIImage(systemName: "pencil")
        backgroundConfiguration?.backgroundColor = UIColor.systemTeal
    }
}
