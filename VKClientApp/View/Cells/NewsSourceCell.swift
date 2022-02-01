//
//  NewsSourceCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 18.11.2021.
//

import Nuke
import UIKit

class NewsSourceCell: UITableViewCell, CellConfigurationProtocol {
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var sourceDate: UILabel!
//    @IBOutlet var shadowView: ShadowView!

//    @IBInspectable var shadowColor = UIColor.black {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//
//    @IBInspectable var shadowRadius: CGFloat = 0.9 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//
//    @IBInspectable var shadowOpacity: Float = 0.3 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2,
//                                                                     left: 0,
//                                                                     bottom: 2,
//                                                                     right: 0))
    }

    func configure(news: NewsRow) {
        self.sourceName.text = news.srcName
        self.sourceDate.text = news.date
        guard let url = news.photo else {return}
        Nuke.loadImage(with: url, into: sourceImage)
        backgroundConfiguration?.backgroundColor = AppSettings.instance.tableColor
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        let cornerRadius: CGFloat = shadowView.bounds.width / 2.0
//        let cornerRadius: CGFloat = sourceImage.bounds.width / 2.5
//        shadowView.layer.masksToBounds = false
//        shadowView.layer.cornerRadius = cornerRadius
//        shadowView.layer.shadowColor = shadowColor.cgColor
//        shadowView.layer.shadowOffset = CGSize(width: 5.0, height: 0.0)
//        shadowView.layer.shadowRadius = shadowRadius
//        shadowView.layer.shadowOpacity = shadowOpacity

//        sourceImage.layer.cornerRadius = cornerRadius
//        sourceImage.layer.cornerRadius = cornerRadius / 2.5
//        sourceImage.layer.masksToBounds = true
    }
}
