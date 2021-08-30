//
//  UITableViewExtensions.swift
//

import UIKit

extension UITableView {

    func displayEmptyMessage(message: String, font: UIFont, color: UIColor) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = "No vurveys to view"
        messageLabel.textColor = color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = font
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }

    func removeEmptyState() {
        self.backgroundView = nil
    }

}

