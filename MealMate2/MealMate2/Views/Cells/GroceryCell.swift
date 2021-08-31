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
    
}
