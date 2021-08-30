//
//  LabelComponents.swift
//

import UIKit

// MARK: - AppStyleLabels

class AppStyleLabel : UILabel {

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
        if type(of: self) === AppStyleLabel.self {
            fatalError("AppStyleLabel not meant to be used directly. Use its subclasses.")
        }
    }
}

@IBDesignable
class LightLabel: AppStyleLabel {
    override func commonInit() {
        self.font = UIFont.appLightFontOfSize(self.font.pointSize)
    }
}

@IBDesignable
class RegularLabel: AppStyleLabel {
    override func commonInit() {
        self.font = UIFont.appFontOfSize(self.font.pointSize)
    }
}

@IBDesignable
class MediumLabel: AppStyleLabel {
    override func commonInit() {
        self.font = UIFont.appMediumFontOfSize(self.font.pointSize)
    }
}

@IBDesignable
class BoldLabel: AppStyleLabel {
    override func commonInit() {
        self.font = UIFont.appBoldFontOfSize(self.font.pointSize)
    }
}

// MARK: - TopAlignedLabel

class TopAlignedLabel: RegularLabel {

    override func drawText(in rect: CGRect) {
        if let stringText = text, let font = font {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSAttributedString.Key.font: font],
                                                                    context: nil).size
            super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }

}
