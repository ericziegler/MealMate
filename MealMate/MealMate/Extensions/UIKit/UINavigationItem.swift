//
//  UINavigationItem.swift
//  MealMate
//
//  Created by Eric Ziegler on 8/21/22.
//  Copyright © 2022 Eric Ziegler. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func setTitle(title:String, subtitle:String) {
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.appBoldFontOfSize(19)
        titleLabel.textColor = UIColor.appLight
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.appMediumFontOfSize(14)
        subtitleLabel.textColor = UIColor.appLight
        subtitleLabel.textAlignment = .center
        subtitleLabel.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(titleLabel.frame.size.width, subtitleLabel.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
        self.titleView = stackView
    }
}
