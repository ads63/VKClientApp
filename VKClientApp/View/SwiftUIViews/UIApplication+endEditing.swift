//
//  UIApplication+endEditing.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 04.05.2022.
//

import UIKit
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from:
            nil, for: nil)
    }
}
