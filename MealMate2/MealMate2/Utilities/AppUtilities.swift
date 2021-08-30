//
//  AppUtilities.swift
//

import UIKit

// MARK: - App Versions

var appVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

var appBuild: String? {
    return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
}

// MARK: Global UI Properties

func applyApplicationAppearanceProperties() {
    UINavigationBar.appearance().tintColor = UIColor.appText
    UINavigationBar.appearance().barTintColor = UIColor.appNavBar
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appText]
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.appMediumFontOfSize(11)], for: .normal)
    var toastStyle = ToastStyle()
    toastStyle.backgroundColor = UIColor.appSecondaryText
    toastStyle.messageColor = UIColor.appBackground
    toastStyle.messageFont = UIFont.appBoldFontOfSize(17)
    ToastManager.shared.style = toastStyle
}

func navTitleTextAttributes() -> [NSAttributedString.Key : Any] {
    return [NSAttributedString.Key.font : UIFont.appMediumFontOfSize(17), .foregroundColor : UIColor.appText]
}
