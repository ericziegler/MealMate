//
//  UISegmentedControlExtensions.swift
//

import UIKit

extension UISegmentedControl {

    // Tint color doesn't have any effect on iOS 13.
    func ensureiOS12Style() {
        if #available(iOS 13, *) {
            let tintColorImage = tintColor.image()
            // Must set the background image for normal to something (even clear) else the rest won't work
            let controlBackgroundColor: UIColor = backgroundColor ?? .clear
            setBackgroundImage(controlBackgroundColor.image(), for: .normal, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            let highlightedBackgroundColor: UIColor = tintColor.withAlphaComponent(0.2)
            setBackgroundImage(highlightedBackgroundColor.image(), for: .highlighted, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
            setTitleTextAttributes([.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
            setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .selected)
            setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor
        }
    }

}
