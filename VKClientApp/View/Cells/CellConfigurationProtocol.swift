//
//  CellConfigurationProtocol.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 18.11.2021.
//

import Foundation
import UIKit
protocol CellConfigurationProtocol: UITableViewCell {
    func configure(news: NewsRow?, isExpanded: Bool)
}
