//
//  UICollectionViewExtensions.swift
//

import UIKit

// MARK: - UICollectionViewLayoutAttributes

extension UICollectionViewLayoutAttributes {

    func leftAlignWith(insets: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = insets.left
        self.frame = frame
    }

}
