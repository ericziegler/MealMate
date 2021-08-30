//
//  UITextViewExtensions.swift
//

import UIKit

// MARK: - UITextView

extension UITextView {

    #if targetEnvironment(macCatalyst)
    @objc(_focusRingType)
    var focusRingType: UInt {
        return 1 //NSFocusRingTypeNone
    }
    #endif

}
