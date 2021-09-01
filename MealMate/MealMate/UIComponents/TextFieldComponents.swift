//
//  TextFieldComponents.swift
//

import UIKit

// MARK: - Inspectables

extension UITextField {

    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }

}

// MARK: - AppTextField

class AppTextField : UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    func commonInit() {
        self.backgroundColor = UIColor.white
        self.borderStyle = .none
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
        styleField()
    }

    func styleField(textColor: UIColor = UIColor.black, placeholderColor: UIColor = UIColor.gray, cornerRadius: CGFloat = 6, font: UIFont = UIFont.appFontOfSize(14)) {
        self.font = font
        self.placeholderColor = placeholderColor
        self.textColor = textColor
        self.layer.cornerRadius = cornerRadius
    }
}
