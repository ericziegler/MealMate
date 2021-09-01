//
//  UIViewExtensions.swift
//

import UIKit

extension UIView {

    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    func fillInParentView(parentView: UIView) {
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0)
        parentView.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }

    var snapshot: UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, UIScreen.main.scale)

        guard let currentContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIImage()
        }

        self.layer.render(in: currentContext)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        } else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
    }

    func flash(numberOfFlashes: Float, duration: TimeInterval = 0.5) {
       let flash = CABasicAnimation(keyPath: "opacity")
       flash.duration = duration
       flash.fromValue = 1
       flash.toValue = 0.1
       flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
       flash.autoreverses = true
       flash.repeatCount = numberOfFlashes
       layer.add(flash, forKey: nil)
   }

    static func snapshotAsView(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let snapshot : UIView = UIImageView(image: image)
        return snapshot
    }

    func rotate360Degrees(duration: CFTimeInterval = 0.4, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = duration

        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }

    static func createTableHeaderWith(title: String, tableView: UITableView, bgColor: UIColor? = UIColor.lightGray, titleColor: UIColor? = UIColor.black, font: UIFont? = UIFont.boldSystemFont(ofSize: 20)) -> UIView {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
        bg.backgroundColor = bgColor
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = title
        titleLabel.textColor = titleColor
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = font
        bg.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: bg, attribute: .leading, multiplier: 1, constant: 12)
        let trailingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: bg, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: bg, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: bg, attribute: .bottom, multiplier: 1, constant: 0)
        bg.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        return bg
    }

}
