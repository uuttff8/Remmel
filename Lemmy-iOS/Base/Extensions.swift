//
//  Extensions.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}

extension UIButton {
    func setInsets(
        forContentPadding contentPadding: UIEdgeInsets,
        imageTitlePadding: CGFloat
    ) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left,
            bottom: contentPadding.bottom,
            right: contentPadding.right + imageTitlePadding
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
        )
    }
}


extension UILabel {
    
    func set(text:String, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {
        
        let leftAttachment = NSTextAttachment()
        leftAttachment.image = leftIcon
        leftAttachment.bounds = CGRect(x: 0, y: -2.5, width: 20, height: 20)
        if let leftIcon = leftIcon {
            leftAttachment.bounds = CGRect(x: 0, y: -2.5, width: leftIcon.size.width, height: leftIcon.size.height)
        }
        let leftAttachmentStr = NSAttributedString(attachment: leftAttachment)
        
        let myString = NSMutableAttributedString(string: "")
        
        let rightAttachment = NSTextAttachment()
        rightAttachment.image = rightIcon
        rightAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        let rightAttachmentStr = NSAttributedString(attachment: rightAttachment)
        
        
        if semanticContentAttribute == .forceRightToLeft {
            if rightIcon != nil {
                myString.append(rightAttachmentStr)
                myString.append(NSAttributedString(string: " "))
            }
            myString.append(NSAttributedString(string: text))
            if leftIcon != nil {
                myString.append(NSAttributedString(string: " "))
                myString.append(leftAttachmentStr)
            }
        } else {
            if leftIcon != nil {
                myString.append(leftAttachmentStr)
                myString.append(NSAttributedString(string: " "))
            }
            myString.append(NSAttributedString(string: text))
            if rightIcon != nil {
                myString.append(NSAttributedString(string: " "))
                myString.append(rightAttachmentStr)
            }
        }
        attributedText = myString
    }
}

extension UIColor {
    convenience init(rgb: UInt, alphaVal: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alphaVal
        )
    }
}

extension Date {
    static func toLemmyDate(str: String?) -> Date {
        guard let str = str else { return Date() }
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFractionalSeconds, .withTime, .withColonSeparatorInTime]
        dateFormatter.timeZone = TimeZone.current
        // Safety: if error here then backend returned not valid sent date in string
        return dateFormatter.date(from: str)!
    }
    
    func toRelativeDate() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

extension UserDefaults {
    func resetDefaults() {
        let dictionary = self.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            self.removeObject(forKey: key)
        }
    }
}

extension UIView {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        self.view.hideKeyboardWhenTappedAround()
    }
}

extension UIAlertController {
    static func createOkAlert(message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        controller.addAction(okAction)
        guard let vc = UIApplication.getTopMostViewController() else { return }
        vc.present(controller, animated: true, completion: nil)
    }
}


extension UIApplication {
    
    class func getTopMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}

extension String {
    func base64ToImage() -> UIImage? {
        let newImageData = Data(base64Encoded: self)
        if let newImageData = newImageData {
            return UIImage(data: newImageData)
        }
        
        return nil
    }
}

extension UIScreen {
    static var isDarkMode: Bool {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark
    }
}

extension UIView {
    private static var tapKey = "tapKey"
    
    func addTap(numberOfTapsRequired: Int = 1, numberOfTouchesRequired: Int = 1, cancelTouchesInView: Bool = true, action: @escaping () -> Void) {
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &UIView.tapKey, TapAction(action: action), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView))
        tapRecognizer.numberOfTapsRequired = numberOfTapsRequired
        tapRecognizer.numberOfTouchesRequired = numberOfTouchesRequired
        tapRecognizer.cancelsTouchesInView = cancelTouchesInView
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tapView() {
        if let tap = objc_getAssociatedObject(self, &UIView.tapKey) as? TapAction {
            tap.action()
        }
    }
    
    private class TapAction {
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
    }
    
    func addLongpress(minimumPressDuration: Double, cancelTouchesInView: Bool = true, action: @escaping () -> Void) {
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &UIView.tapKey, TapAction(action: action), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        let tapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapView))
        tapRecognizer.minimumPressDuration = minimumPressDuration
        tapRecognizer.cancelsTouchesInView = cancelTouchesInView
        addGestureRecognizer(tapRecognizer)
    }
}

extension UIButton {
    @available(iOS 14.0, *)
    convenience init(title: String = "",
                     image: UIImage? = nil,
                     handler: @escaping () -> Void) {
        self.init(primaryAction: UIAction(
            title: title,
            image: image,
            handler: { _ in
                handler()
            }
        ))
    }
}

public extension UIEvent {
    
    func firstTouchToControlEvent() -> UIControl.Event? {
        guard let touch = self.allTouches?.first else {
            print("firstTouchToControlEvent() Error: couldn't get the first touch. \(self)")
            return nil
        }
        return touch.toControlEvent()
    }
    
}

public extension UITouch {
    
    func toControlEvent() -> UIControl.Event? {
        guard let view = self.view else {
            print("UITouch.toControlEvent() Error: couldn't get the containing view. \(self)")
            return nil
        }
        let isInside = view.bounds.contains(self.location(in: view))
        let wasInside = view.bounds.contains(self.previousLocation(in: view))
        switch self.phase {
        case .began:
            if isInside {
                if self.tapCount > 1 {
                    return .touchDownRepeat
                }
                return .touchDown
            }
            print("UITouch.toControlEvent() Error: unexpected touch began outs1ide of view. \(self)")
            return nil
        case .moved:
            if isInside && wasInside {
                return .touchDragInside
            } else if isInside && !wasInside {
                return .touchDragEnter
            } else if !isInside && wasInside {
                return .touchDragExit
            } else if !isInside && !wasInside {
                return .touchDragOutside
            } else {
                print("UITouch.toControlEvent() Error: couldn't determine touch moved boundary. \(self)")
                return nil
            }
        case .ended:
            if isInside {
                return .touchUpInside
            } else {
                return.touchUpOutside
            }
        case .cancelled:
            return .touchCancel
        default:
            print("UITouch.toControlEvent() Warning: couldn't handle touch event. \(self)")
            return nil
        }
    }
    
}

extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
//            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: 100, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

// MARK: - Reusable Protocol -
protocol ReusableCellIdentifiable {
    static var cellIdentifier: String { get }
}

extension ReusableCellIdentifiable where Self: UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension ReusableCellIdentifiable where Self: UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableCellIdentifiable {}
extension UICollectionViewCell: ReusableCellIdentifiable {}

extension UITableView {
    
    func registerNib<T: UITableViewCell>(withClass cellClass: T.Type) {
        register(
            Config.Nib.loadNib(name: T.cellIdentifier),
            forCellReuseIdentifier: T.cellIdentifier
        )
    }
    
    func registerClass<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.cellIdentifier)
    }
    
    func cell<T: ReusableCellIdentifiable>(forRowAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as! T
    }
    
    func cell<T: ReusableCellIdentifiable>(forClass cellClass: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.cellIdentifier) as! T
    }
    
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height / 2 ))
        messageLabel.text = message
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension UIBarButtonItem {
    convenience init(
        title: String? = nil,
        image: UIImage? = nil,
        primaryAction: UIAction? = nil,
        menu: UIMenu? = nil,
        style: UIBarButtonItem.Style? = nil
    ) {
        self.init(title: title, image: image, primaryAction: primaryAction, menu: menu)
        if let style = style {
            self.style = style
        }
    }
}

extension Notification.Name {
    static let didLogin = Notification.Name("LemmyiOS.didLogin")
}

