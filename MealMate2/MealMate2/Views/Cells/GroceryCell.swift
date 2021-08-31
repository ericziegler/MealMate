//
//  GroceryCell.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/31/21.
//

import UIKit

class GroceryCell: UITableViewCell {
 
    // MARK: - Properties
    
    static let reuseId = "GroceryCellId"
    
    @IBOutlet var checkImageView: UIImageView!
    @IBOutlet var nameLabel: RegularLabel!
    @IBOutlet var gripImageView: UIImageView!
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }
    
    private func styleUI() {
        gripImageView.image = gripImageView.image?.maskedWithColor(UIColor.appMediumDark)
    }
    
    // MARK: - Layout
    
    func layoutFor(grocery: Grocery) {
        if grocery.isChecked == true {
            checkImageView.image = UIImage(named: "Check")?.maskedWithColor(UIColor.appMediumDark)
            nameLabel.textColor = UIColor.appMediumDark
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: grocery.name)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            nameLabel.attributedText = attributeString
        } else {
            checkImageView.image = UIImage(named: "Uncheck")?.maskedWithColor(UIColor.appMediumDark)
            nameLabel.textColor = UIColor.appDark
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: grocery.name)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            nameLabel.attributedText = attributeString
        }
    }
    
}
