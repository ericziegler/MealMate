//
//  UIImageExtensions.swift
//

import UIKit

extension UIImage {

    func maskedWithColor(_ color: UIColor) -> UIImage? {
        var result: UIImage?

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        if let context: CGContext = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)

            // flip coordinate system or else CGContextClipToMask will appear upside down
            context.translateBy(x: 0, y: rect.size.height);
            context.scaleBy(x: 1.0, y: -1.0);

            // mask and fill
            context.setFillColor(color.cgColor)
            context.clip(to: rect, mask: cgImage);
            context.fill(rect)

        }

        result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    func saveToDocumentDirectory() -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"

        let filename = dateFormatter.string(from: Date()).appending(".jpg")
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try self.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
            return filename

        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filename
        }
    }

    static func loadImage(at path: String) -> UIImage? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        let imagePath = documentPath.appending("/\(path)")
        guard fileExists(at: imagePath) else {
            return nil
        }
        guard let image = UIImage(contentsOfFile: imagePath) else {
            return nil
        }
        return image
    }

}
