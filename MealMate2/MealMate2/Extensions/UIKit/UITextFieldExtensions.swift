//
//  UITextFieldExtensions.swift
//

import UIKit

extension UITextField {

    func addButtonOnKeyboardWithText(buttonText: String, onRightSide: Bool = true) -> UIBarButtonItem
    {
        let buttonToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        buttonToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let buttonItem: UIBarButtonItem = UIBarButtonItem(title: buttonText, style: UIBarButtonItem.Style.done, target: self, action: nil)

        var items = [UIBarButtonItem]()
        if onRightSide == true {
            items.append(flexSpace)
            items.append(buttonItem)
        } else {
            items.append(buttonItem)
            items.append(flexSpace)
        }

        buttonToolbar.items = items
        buttonToolbar.sizeToFit()

        self.inputAccessoryView = buttonToolbar

        return buttonItem
    }

}
