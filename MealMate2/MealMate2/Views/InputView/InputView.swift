//
//  InputView.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/30/21.
//

import UIKit

class InputView: UIView {
 
    // MARK: - Properties
    
    private var inputField: AppTextField!
    private var inputButton: MediumButton!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        createAndAddInputButton()
        createAndAddInputField()
    }
    
    private func createAndAddInputButton() {
        inputButton = MediumButton(type: .custom)
        inputButton.backgroundColor = UIColor.clear
        inputButton.layer.borderWidth = 1.5
        inputButton.layer.borderColor = UIColor.appRed.cgColor
        inputButton.clipsToBounds = true
        inputButton.layer.cornerRadius = 8
        inputButton.setTitle("Add", for: .normal)
        inputButton.setTitleColor(UIColor.appRed, for: .normal)
        self.addSubview(inputButton)
        inputButton.translatesAutoresizingMaskIntoConstraints = false
        inputButton.addConstraint(NSLayoutConstraint(item: inputButton as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        inputButton.addConstraint(NSLayoutConstraint(item: inputButton as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90))
        self.addConstraint(NSLayoutConstraint(item: inputButton as Any, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12))
        self.addConstraint(NSLayoutConstraint(item: inputButton as Any, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -8))
        self.addConstraint(NSLayoutConstraint(item: inputButton as Any, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -12))
    }
    
    private func createAndAddInputField() {
        inputField = AppTextField(frame: .zero)
        inputField.placeholder = "Add item"
        inputField.backgroundColor = UIColor.appMedium
        inputField.styleField(textColor: UIColor.appDark, placeholderColor: UIColor.darkGray, cornerRadius: 8, font: UIFont.appMediumFontOfSize(18))
        self.addSubview(inputField)
        inputField.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: inputField as Any, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 12))
        self.addConstraint(NSLayoutConstraint(item: inputField as Any, attribute: .trailing, relatedBy: .equal, toItem: inputButton, attribute: .leading, multiplier: 1, constant: -12))
        self.addConstraint(NSLayoutConstraint(item: inputField as Any, attribute: .height, relatedBy: .equal, toItem: inputButton, attribute: .height, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: inputField as Any, attribute: .centerY, relatedBy: .equal, toItem: inputButton, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
