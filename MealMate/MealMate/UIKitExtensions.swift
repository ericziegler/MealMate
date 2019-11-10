//
//  UIKitExtensions.swift
//

import UIKit

// MARK: Global Properties

func applyApplicationAppearanceProperties() {
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.applicationFontOfSize(17)], for: .normal)
    UINavigationBar.appearance().tintColor = UIColor.appDark
    UINavigationBar.appearance().barTintColor = UIColor.appLightGray
}

func navTitleTextAttributes() -> [NSAttributedString.Key : Any] {
    return [NSAttributedString.Key.font : UIFont.applicationBoldFontOfSize(27.0), .foregroundColor : UIColor.appDark]
}

// MARK: - UIImage

extension UIImage {

    func maskedImageWithColor(_ color: UIColor) -> UIImage? {
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

}

// MARK: - UILabel

class ApplicationStyleLabel : UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.preInit();
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.preInit()
    }

    func preInit() {
        if let text = self.text, text.hasPrefix("^") {
            self.text = nil
        }
        self.commonInit()
    }

    func commonInit() {
        if type(of: self) === ApplicationStyleLabel.self {
            fatalError("ApplicationStyleLabel not meant to be used directly. Use its subclasses.")
        }
    }
}

class RegularLabel: ApplicationStyleLabel {
    override func commonInit() {
        self.font = UIFont.applicationFontOfSize(self.font.pointSize)
    }
}

class BoldLabel: ApplicationStyleLabel {
    override func commonInit() {
        self.font = UIFont.applicationBoldFontOfSize(self.font.pointSize)
    }
}

// MARK: - UIButton

class ApplicationStyleButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        if type(of: self) === ApplicationStyleButton.self {
            fatalError("ApplicationStyleButton not meant to be used directly. Use its subclasses.")
        }
    }
}

class RegularButton: ApplicationStyleButton {
    override func commonInit() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont.applicationFontOfSize(font.pointSize)
        }
    }
}

class BoldButton: ApplicationStyleButton {
    override func commonInit() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = UIFont.applicationBoldFontOfSize(font.pointSize)
        }
    }
}

// MARK: - UIFont

extension UIFont {

    class func applicationFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DevanagariSangamMN", size: size)!
    }

    class func applicationBoldFontOfSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DevanagariSangamMN-Bold", size: size)!
    }

    class func debugListFonts() {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
    }

}

// MARK: - UIColor

extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 08) / 255.0
        let b = CGFloat((hex & 0x0000FF) >> 00) / 255.0
        self.init(red:r, green:g, blue:b, alpha:alpha)
    }

    convenience init(intRed red: Int, green: Int, blue: Int, alpha: Int = 255) {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        let a = CGFloat(alpha) / 255.0
        self.init(red:r, green:g, blue:b, alpha:a)
    }

    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }

    class var appMain: UIColor {
        return UIColor(hex: 0xb71c1c)
    }

    class var appMainLight: UIColor {
        return UIColor(hex: 0xef9a9a)
    }

    class var appDark: UIColor {
        return UIColor(hex: 0x424242)
    }

    class var appLightGray: UIColor {
        return UIColor(hex: 0xeeeeee)
    }

    class var appGray: UIColor {
        return UIColor(hex: 0x9e9e9e)
    }

    class var appDarkGray: UIColor {
        return UIColor(hex: 0x757575)
    }

}

// MARK: - UITextField

extension UITextField {
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }

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

class StyledTextField : UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        self.borderStyle = .none
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
        self.styleBorderWithColor()
    }

    func styleBorderWithColor(color: UIColor = UIColor(hex: 0xbbbbbb), cornerRadius: CGFloat = 10, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

class StyledTextView : UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        self.styleBorderWithColor()
    }

    func styleBorderWithColor(color: UIColor = UIColor(hex: 0xbbbbbb), cornerRadius: CGFloat = 10, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

// MARK: - UISegmentedControl

extension UISegmentedControl {
    /// Tint color doesn't have any effect on iOS 13.
    func ensureiOS12Style() {
        if #available(iOS 13, *) {
            let tintColorImage = tintColor.image()
            // Must set the background image for normal to something (even clear) else the rest won't work
            let controlBackgroundColor: UIColor = backgroundColor ?? .clear
            setBackgroundImage(controlBackgroundColor.image(), for: .normal, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            let highlightedBackgroundColor: UIColor = tintColor.withAlphaComponent(0.2)
            setBackgroundImage(highlightedBackgroundColor.image(), for: .highlighted, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
            setTitleTextAttributes([.foregroundColor: UIColor.appDarkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
            setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .selected)
            setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor
        }
    }
}

// MARK: - UIView

extension UIView {

    func fillInParentView(parentView: UIView) {
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0)
        parentView.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }

    static func createTableHeaderWith(title: String, tableView: UITableView, bgColor: UIColor? = UIColor(hex: 0xdddddd), titleColor: UIColor? = UIColor.black, font: UIFont? = UIFont.boldSystemFont(ofSize: 20)) -> UIView {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
        bg.backgroundColor = bgColor
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = title
        titleLabel.textColor = titleColor
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = font
        bg.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: bg, attribute: .leading, multiplier: 1, constant: 10)
        let trailingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: bg, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: bg, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: bg, attribute: .bottom, multiplier: 1, constant: 0)
        bg.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        return bg
    }

    func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil) {
            return image!
        }
        return UIImage()
    }

    static func screenshotTable(tableView: UITableView) -> UIImage {
        var image = UIImage();
        UIGraphicsBeginImageContextWithOptions(tableView.contentSize, false, UIScreen.main.scale)

        // save initial values
        let savedContentOffset = tableView.contentOffset;
        let savedFrame = tableView.frame;
        let savedBackgroundColor = tableView.backgroundColor

        // reset offset to top left point
        tableView.contentOffset = CGPoint(x: 0, y: 0);
        // set frame to content size
        tableView.frame = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: tableView.contentSize.height);
        // remove background
        tableView.backgroundColor = UIColor.clear

        // make temp view with scroll view content size
        // a workaround for issue when image on ipad was drawn incorrectly
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: tableView.contentSize.height));

        // save superview
        let tempSuperView = tableView.superview
        // remove scrollView from old superview
        tableView.removeFromSuperview()
        // and add to tempView
        tempView.addSubview(tableView)

        // render view
        // drawViewHierarchyInRect not working correctly
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        // and get image
        image = UIGraphicsGetImageFromCurrentImageContext()!;

        // and return everything back
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(tableView)

        // restore saved settings
        tableView.contentOffset = savedContentOffset;
        tableView.frame = savedFrame;
        tableView.backgroundColor = savedBackgroundColor

        UIGraphicsEndImageContext();

        return image
    }

}

class GradientView: UIView {

    func updateGradientWith(firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

        layer.insertSublayer(gradientLayer, at: 0)
    }

}
