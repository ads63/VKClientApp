//
//  PhotoHeightPreferenceKey.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 06.06.2022.
//

import SwiftUI

struct PhotoHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
