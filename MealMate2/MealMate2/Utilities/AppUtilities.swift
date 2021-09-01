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
    UINavigationBar.appearance().tintColor = UIColor.appLight
    UINavigationBar.appearance().barTintColor = UIColor.appBlue
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appDark]
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.appMediumFontOfSize(11)], for: .normal)
    UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appDark], for: .normal)
    UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
}

func navTitleTextAttributes() -> [NSAttributedString.Key : Any] {
    return [NSAttributedString.Key.font : UIFont.appBoldFontOfSize(22), .foregroundColor : UIColor.appLight]
}
