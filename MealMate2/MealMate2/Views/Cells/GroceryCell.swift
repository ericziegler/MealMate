//
//  GroceryCell.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/31/21.
//

import UIKit

// MARK: - Protocols

protocol GroceryCellDelegate {
    func checkTappedFor(cell: GroceryCell)
}

class GroceryCell: UITableViewCell {
 
    // MARK: - Properties
    
    static let reuseId = "GroceryCellId"
    
    @IBOutlet var checkImageView: UIImageView!
    @IBOutlet var nameLabel: RegularLabel!
    @IBOutlet var gripImageView: UIImageView!
    
    var delegate: GroceryCellDelegate?
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }
    
    private func styleUI() {
        gripImageView.image = gripImageView.image?.maskedWithColor(UIColor.appLightDark)
    }
    
    // MARK: - Layout
    
    func layoutFor(grocery: Grocery) {
        if grocery.isChecked == true {
            checkImageView.image = UIImage(named: "Check")?.maskedWithColor(UIColor.appLightDark)
            nameLabel.textColor = UIColor.appMediumDark
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: grocery.name)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            nameLabel.attributedText = attributeString
        } else {
            checkImageView.image = UIImage(named: "Uncheck")?.maskedWithColor(UIColor.appLightDark)
            nameLabel.textColor = UIColor.appDark
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: grocery.name)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            nameLabel.attributedText = attributeString
        }
    }
    
    // MARK: - Actions
    
    @IBAction func checkTapped(_ sender: AnyObject) {
        delegate?.checkTappedFor(cell: self)
    }
    
}
