//
//  IntExtensions.swift
//

import Foundation

extension Int {

    var minutesSecondsString: String {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        return NSString(format: "%0.1d:%0.2d", minutes, seconds) as String
    }

}

