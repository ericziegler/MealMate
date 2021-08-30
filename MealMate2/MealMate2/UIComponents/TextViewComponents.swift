//
//  TextViewComponents.swift
//

import UIKit

// MARK: - StyledTextView

class StyledTextView : UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
        styleBorderWithColor()
    }

    func styleBorderWithColor(color: UIColor = UIColor(hex: 0xdddddd), cornerRadius: CGFloat = 10, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

// MARK: - EditableLabel

protocol EditableLabelDelegate {
    func editableLabelDidEndEditing(label: EditableLabel)
}

class EditableLabel : UITextView, UITextViewDelegate {

    private var borderColor = UIColor(hex: 0xcccccc)
    private var heightConstraint: NSLayoutConstraint!
    var editableDelegate: EditableLabelDelegate?

    override var text: String! {
        didSet {
            updateHeight()
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 34)
        heightConstraint.priority = .defaultHigh
        self.addConstraint(heightConstraint)

        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor

        self.isScrollEnabled = false
        self.delegate = self
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            _ = self.resignFirstResponder()
            return false
        } else {
            return true
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        updateHeight()
    }

    private func updateHeight() {
        let sizeToFitIn = CGSize(width: self.bounds.size.width, height: CGFloat(MAXFLOAT))
        let newSize = self.sizeThatFits(sizeToFitIn)
        self.heightConstraint.constant = newSize.height
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        self.layer.borderColor = borderColor.cgColor

        return true
    }

    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        self.layer.borderColor = UIColor.clear.cgColor

        editableDelegate?.editableLabelDidEndEditing(label: self)
        return true
    }

}

class LightEditableLabel: EditableLabel {
    override func commonInit() {
        super.commonInit()
        if let font = self.font {
            self.font = UIFont.appLightFontOfSize(font.pointSize)
        }
    }
}

class RegularEditableLabel: EditableLabel {
    override func commonInit() {
        super.commonInit()
        if let font = self.font {
            self.font = UIFont.appFontOfSize(font.pointSize)
        }
    }
}

class MediumEditableLabel: EditableLabel {
    override func commonInit() {
        super.commonInit()
        if let font = self.font {
            self.font = UIFont.appMediumFontOfSize(font.pointSize)
        }
    }
}

class BoldEditableLabel: EditableLabel {
    override func commonInit() {
        super.commonInit()
        if let font = self.font {
            self.font = UIFont.appBoldFontOfSize(font.pointSize)
        }
    }
}

