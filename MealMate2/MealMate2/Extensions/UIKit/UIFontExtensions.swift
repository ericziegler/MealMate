//
//  UIFontExtensions.swift
//

import UIKit

extension UIFont {

    class func debugListFonts() {
        var families = [String]()
        for family: String in UIFont.familyNames {
            families.append(family)
        }
        families.sort { $0 < $1 }

        for curFamily in families {
            print(curFamily)
            var names = [String]()
            for curName: String in UIFont.fontNames(forFamilyName: curFamily) {
                names.append(curName)
            }
            names.sort { $0 < $1 }
            for curName in names {
                print("== \(curName)")
            }
        }
    }

}
