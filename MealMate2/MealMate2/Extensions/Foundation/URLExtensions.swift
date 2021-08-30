//
//  URLExtensions.swift
//

import Foundation

extension URL {

    var validImageMimeType: String? {
        var result: String?

        if self.pathExtension.lowercased() == "jpg" || self.pathExtension.lowercased() == "jpeg" {
            result = "image/jpeg"
        }
        else if self.pathExtension.lowercased() == "png" {
            result = "image/png"
        }

        return result
    }

    var params: [String: String]? {
        if let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) {
            if let queryItems = urlComponents.queryItems {
                var params = [String: String]()
                queryItems.forEach{
                    params[$0.name] = $0.value
                }
                return params
            }
        }
        return nil
    }

}
