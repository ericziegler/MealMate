//
//  FontComponents.swift
//

import UIKit

extension UIFont {

    class func appLightFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Thin", size: size)!
    }

    class func appFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Light", size: size)!
    }

    class func appMediumFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Regular", size: size)!
    }

    class func appBoldFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Bold", size: size)!
    }

}
