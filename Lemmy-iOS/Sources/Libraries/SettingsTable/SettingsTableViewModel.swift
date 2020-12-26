import UIKit

struct SettingsTableViewModel {
    let sections: [SettingsTableSectionViewModel]
}

struct SettingsTableSectionViewModel {
    struct Header {
        let title: String
    }

    struct Cell: UniqueIdentifiable {
        struct Appearance {
            var backgroundColor: UIColor?
            var selectedBackgroundColor: UIColor?
        }

        let uniqueIdentifier: UniqueIdentifierType
        let type: SettingsTableSectionCellType
        let appearance: Appearance

        init(
            uniqueIdentifier: UniqueIdentifierType,
            type: SettingsTableSectionCellType,
            appearance: Appearance = .init()
        ) {
            self.uniqueIdentifier = uniqueIdentifier
            self.type = type
            self.appearance = appearance
        }
    }

    struct Footer {
        let description: String
    }

    let header: Header?
    let cells: [Cell]
    let footer: Footer?
}

enum SettingsTableSectionCellType {
    case input(options: InputCellOptions)
    case largeInput(options: LargeInputCellOptions)
    case rightDetail(options: RightDetailCellOptions)
    case inputWithImage(options: InputWithImageOptions)
}

struct InputCellOptions {
    let shouldAlwaysShowPlaceholder: Bool
    let placeholderText: String?
    let valueText: String?
    let inputGroup: UniqueIdentifierType?
    let isEnabled: Bool
    let capitalization: UITextAutocapitalizationType

    init(
        valueText: String? = nil,
        placeholderText: String? = nil,
        shouldAlwaysShowPlaceholder: Bool = false,
        inputGroup: UniqueIdentifierType? = nil,
        isEnabled: Bool = true,
        capitalization: UITextAutocapitalizationType = .sentences
    ) {
        self.valueText = valueText
        self.placeholderText = placeholderText
        self.shouldAlwaysShowPlaceholder = shouldAlwaysShowPlaceholder
        self.inputGroup = inputGroup
        self.isEnabled = isEnabled
        self.capitalization = capitalization
    }
}

struct LargeInputCellOptions {
    let placeholderText: String?
    let valueText: String?
    let maxLength: Int?
    let noNewline: Bool

    init(
        valueText: String? = nil,
        placeholderText: String? = nil,
        maxLength: Int? = nil,
        noNewline: Bool = false
    ) {
        self.valueText = valueText
        self.placeholderText = placeholderText
        self.maxLength = maxLength
        self.noNewline = noNewline
    }
}

struct RightDetailCellOptions {
    let title: Title
    let detailType: DetailType
    let accessoryType: UITableViewCell.AccessoryType

    init(
        title: Title,
        detailType: DetailType = .label(text: nil),
        accessoryType: UITableViewCell.AccessoryType = .none
    ) {
        self.title = title
        self.detailType = detailType
        self.accessoryType = accessoryType
    }

    struct Title {
        let text: String
        let appearance: Appearance

        init(
            text: String,
            appearance: Appearance = .init(textColor: .label, textAlignment: .natural)
        ) {
            self.text = text
            self.appearance = appearance
        }

        struct Appearance {
            let textColor: UIColor
            let textAlignment: NSTextAlignment
        }
    }

    struct Switch {
        let isOn: Bool
        let appearance: Appearance

        init(
            isOn: Bool,
            appearance: Appearance = .init(onTintColor: .systemGreen)
        ) {
            self.isOn = isOn
            self.appearance = appearance
        }

        struct Appearance {
            var onTintColor: UIColor
        }
    }

    enum DetailType {
        case label(text: String?)
        case `switch`(Switch)
    }
}

struct InputWithImageOptions {
    let placeholderText: String?
    let valueText: String?
    let imageIcon: UIImage
    
    init(
        placeholderText: String? = nil,
        valueText: String? = nil,
        imageIcon: UIImage
    ) {
        self.placeholderText = placeholderText
        self.valueText = valueText
        self.imageIcon = imageIcon
    }
}
