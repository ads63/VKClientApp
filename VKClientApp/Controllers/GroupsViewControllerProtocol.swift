//
//  GroupViewControllerProtocol.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 29.09.2021.
//

import Foundation
import UIKit

protocol CroupsViewControllerProtocol {
    func tapCell(cell: GroupsViewCell)
    func setHeaderFooter(view: UITableViewHeaderFooterView, text: String)
}
