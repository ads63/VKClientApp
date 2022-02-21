//
//  AppSettings.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 29.09.2021.
//

import Foundation
import UIKit
class AppSettings {
    static let instance = AppSettings()
    let apiService = APIService()
    let queuedService = QueuedOperations()
    let photoService = PhotoService()
}
