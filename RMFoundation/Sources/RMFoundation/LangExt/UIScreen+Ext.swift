import UIKit

public extension UIScreen {
    static var isDarkMode: Bool {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark
    }
}
