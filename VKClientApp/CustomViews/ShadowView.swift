//
//  ShadowView.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 01.09.2021.
//

import UIKit

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            self.setupShadowPath()
        }
    }

    private func setupShadowPath() {
        let presetCornerRadius: CGFloat = self.bounds.height / 2.0
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: presetCornerRadius).cgPath
    }
}
