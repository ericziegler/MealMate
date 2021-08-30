//
//  ButtonComponents.swift
//

import UIKit
import AudioToolbox

// MARK: - AppStyle Buttons

class AppStyleButton : UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        if type(of: self) === AppStyleButton.self {
            fatalError("AppStyleButton not meant to be used directly. Use its subclasses.")
        }
    }

}

@IBDesignable
class LightButton: AppStyleButton {
    override func commonInit() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont.appLightFontOfSize(font.pointSize)
        }
    }
}

@IBDesignable
class RegularButton: AppStyleButton {
    override func commonInit() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont.appFontOfSize(font.pointSize)
        }
    }
}

@IBDesignable
class MediumButton: AppStyleButton {
    override func commonInit() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont.appMediumFontOfSize(font.pointSize)
        }
    }
}

@IBDesignable
class BoldButton: AppStyleButton {
    override func commonInit() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont.appBoldFontOfSize(font.pointSize)
        }
    }
}

// MARK: - ActionButton

@IBDesignable
class ActionButton: MediumButton {

    override func commonInit() {
        super.commonInit()
        self.backgroundColor = UIColor.appMain
        self.layer.cornerRadius = 6
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .disabled)
        self.titleLabel?.font = UIFont.appMediumFontOfSize(14)
        updateStyle()
    }

    @IBInspectable override var isEnabled: Bool {
        didSet {
            updateStyle()
        }
    }

    func updateStyle() {
        if isEnabled == true {
            self.alpha = 1
        } else {
            self.alpha = 0.5
        }
    }

}

// MARK: - CircleButton

class CircleButton: RegularButton {
    override func commonInit() {
        super.commonInit()
        self.clipsToBounds = true
        self.backgroundColor = UIColor.gray
        self.layer.cornerRadius = self.bounds.size.height / 2
    }
}

// MARK: - LikeButton

class PopButton: RegularButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        AudioServicesPlaySystemSound(1519)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
        }, completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.transform = .identity
        }, completion: nil)
    }

}

// MARK: - RemoteButton

enum RemoteImageCacheType {
    case none
    case memory
    case disk
}

private let imageMemoryCache = NSCache<NSString, UIImage>()
private let imageDiskCacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!

class RemoteButton: RegularButton {

    override func commonInit() {
        super.commonInit()
        self.backgroundColor = UIColor.clear
        self.adjustsImageWhenHighlighted = false
        self.isUserInteractionEnabled = false
    }

    var imageURL: String = ""

    func load(url: String?, altImage: String? = nil, isCircle: Bool = true, allowsInteraction: Bool = false, cacheType: RemoteImageCacheType = .memory) {
        // reset background color
        self.backgroundColor = UIColor.appSecondaryText

        // clip the image into a circle, if necessary
        self.layoutIfNeeded()
        if isCircle == true {
            self.clipsToBounds = true
            self.layer.cornerRadius = self.bounds.size.height / 2
            self.imageView?.contentMode = .scaleAspectFill
        } else {
            self.clipsToBounds = false
            self.layer.cornerRadius = 0
        }

        // determine whether the user can tap the image
        self.isUserInteractionEnabled = allowsInteraction

        // attempt to load the image if there is one
        if let url = url, url.count > 0 {
            // we have a url, load the image
            imageURL = url
            if let cachedImage = loadImageFromCache(imageURL: imageURL, cacheType: cacheType) {
                // load from cache
                self.backgroundColor = UIColor.clear
                self.setImage(cachedImage, for: .normal)
            } else {
                // load remotely
                DispatchQueue.global().async { [weak self] in
                    if let imageURL = URL(string: url), let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            if self?.imageURL == url {
                                self?.backgroundColor = UIColor.clear
                                self?.setImage(image, for: .normal)
                                self?.saveImageToCache(imageURL: url, image: image, cacheType: cacheType)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.loadAlternate(altImage: altImage)
                        }
                    }
                }
            }
        } else {
            loadAlternate(altImage: altImage)
        }
    }

    private func cleanURLForCaching(url: String) -> String {
        return url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ":", with: "")
    }

    private func loadImageFromCache(imageURL: String, cacheType: RemoteImageCacheType) -> UIImage? {
        let url = cleanURLForCaching(url: imageURL)
        switch cacheType {
        case .memory:
            return imageMemoryCache.object(forKey: url as NSString)
        case .disk:
            let fileURL = imageDiskCacheDirectory.appendingPathComponent(url)
            if let imageData = try? Data(contentsOf: fileURL) {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        default:
            return nil
        }
    }

    private func saveImageToCache(imageURL: String, image: UIImage, cacheType: RemoteImageCacheType) {
        let url = cleanURLForCaching(url: imageURL)
        switch cacheType {
        case .memory:
            imageMemoryCache.setObject(image, forKey: url as NSString)
        case .disk:
            let fileURL = imageDiskCacheDirectory.appendingPathComponent(url)
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                try? FileManager.default.removeItem(at: fileURL)
                try? imageData.write(to: fileURL, options: .atomic)
            }
        default:
            break
        }
    }

    private func loadAlternate(altImage: String?) {
        if let altImage = altImage {
            let image = UIImage(named: altImage)
            self.setImage(image, for: .normal)
        }
    }

}
