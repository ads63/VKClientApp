//
//  SelectionsPreferenceKey.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 06.06.2022.
//

import SwiftUI

struct SelectionsPreferenceKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil

    static func reduce(value: inout Anchor<CGRect>?,
                       nextValue: () -> Anchor<CGRect>?)
    {
        value = value ?? nextValue()
    }
}
