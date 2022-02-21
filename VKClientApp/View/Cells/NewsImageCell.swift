//
//  NewsImageCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 17.11.2021.
//

import UIKit

class NewsImageCell: UITableViewCell, CellConfigurationProtocol {
    @IBOutlet var newsImage: UIImageView!
//    internal var aspectConstraint: NSLayoutConstraint? {
//        didSet {
//            if oldValue != nil {
//                newsImage.removeConstraint(oldValue!)
//            }
//            if aspectConstraint != nil {
//                newsImage.addConstraint(aspectConstraint!)
//            }
//        }
//    }

//    var pixelSize: CGFloat {
//        return self.bounds.width * UIScreen.main.scale
//    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        aspectConstraint = nil
    }

    func configure(news: NewsRow?) {
        guard let news = news else { return }
        let url = news.photo!
//        let aspect = CGFloat(news.width) / CGFloat(news.height)
        guard let newsImage = newsImage else { return }
//        aspectConstraint = NSLayoutConstraint(item: newsImage,
//                                              attribute: NSLayoutConstraint.Attribute.width,
//                                              relatedBy: NSLayoutConstraint.Relation.equal,
//                                              toItem: newsImage,
//                                              attribute: NSLayoutConstraint.Attribute.height,
//                                              multiplier: aspect, constant: 0.0)

        newsImage.load(url: url,
                       failureImage: ImageProvider.get(id: .camera))
        backgroundConfiguration?.backgroundColor = UIColor.systemTeal
    }
}
