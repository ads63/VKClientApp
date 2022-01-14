//
//  NewsImageCell.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 17.11.2021.
//
import Nuke
import UIKit

class NewsImageCell: UITableViewCell, CellConfigurationProtocol {

    @IBOutlet var newsImage: UIImageView!
    internal var aspectConstraint : NSLayoutConstraint? {
         didSet {
             if oldValue != nil {
                 newsImage.removeConstraint(oldValue!)
             }
             if aspectConstraint != nil {
                 newsImage.addConstraint(aspectConstraint!)
             }
         }
     }
    var pixelSize: CGFloat {
        return self.bounds.width * UIScreen.main.scale
    }

    var resizedImageProcessors: [ImageProcessing] {
        let imageSize = CGSize(width: pixelSize, height: pixelSize)
        return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(news: NewsRow) {
        let url = news.photo!
        let aspect = CGFloat(news.width) / CGFloat(news.height)

        aspectConstraint = NSLayoutConstraint(item: newsImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: newsImage, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
        
        let options = ImageLoadingOptions(placeholder: UIImage(named: "camera"),
                                          failureImage: UIImage(named: "camera")
        )
        
        let request = ImageRequest(url: url,
                                   processors: resizedImageProcessors)
        Nuke.loadImage(with: request, options: options, into: newsImage)
        backgroundConfiguration?.backgroundColor = AppSettings.instance.tableColor
    
    }
}
