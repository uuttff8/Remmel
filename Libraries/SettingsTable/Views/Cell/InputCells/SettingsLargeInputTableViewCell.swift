import UIKit
import RMFoundation

protocol SettingsLargeInputCellDelegate: AnyObject {
    func settingsCell(
        elementView: UITextView,
        didReportTextChange text: String,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    )
}

final class SettingsLargeInputTableViewCell<T: UITextView>: SettingsTableViewCell<T>, UITextViewDelegate {
    weak var delegate: SettingsLargeInputCellDelegate?
    var uniqueIdentifier: UniqueIdentifierType?

    /// Called when cell height should be update
    var onHeightUpdate: (() -> Void)?
    var noNewline: Bool = false

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.selectionStyle = .none
        self.elementView.delegate = self
    }

    // MARK: UITextViewDelegate

    func textViewDidChange(_ textView: UITextView) {
        self.onHeightUpdate?()
        self.delegate?.settingsCell(
            elementView: self.elementView,
            didReportTextChange: textView.text,
            identifiedBy: self.uniqueIdentifier
        )
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if noNewline {
            guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
                textView.resignFirstResponder()
                return false
            }
        }
        
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.onHeightUpdate?()
        self.delegate?.settingsCell(
            elementView: self.elementView,
            didReportTextChange: textView.text,
            identifiedBy: self.uniqueIdentifier
        )
    }
}
