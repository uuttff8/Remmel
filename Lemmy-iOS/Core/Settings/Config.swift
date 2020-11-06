//
//  Config.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

struct Config {

}

extension Config {
    struct Color {
        static var separator: UIColor {
            if UIScreen.isDarkMode {
                return UIColor.separator
            } else {
                return UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
            }
        }

        static var highlightCell: UIColor {
            if UIScreen.isDarkMode {
                return UIColor.systemGray6
            } else {
                return UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
            }
        }
    }

}

extension Config {
    struct Image {
        static var arrowUp: UIImage {
            if UIScreen.isDarkMode {
                return UIImage(systemName: "arrow.up")!
                    .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "arrow.up")!
                    .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            }
        }

        static var arrowDown: UIImage {
            if UIScreen.isDarkMode {
                return UIImage(systemName: "arrow.down")!
                    .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "arrow.down")!
                    .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            }
        }

        static var comments: UIImage {
            if UIScreen.isDarkMode {
                return UIImage(named: "comments")!
                    .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(named: "comments")!
                    .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            }
        }

        static var ellipsis: UIImage {
            if UIScreen.isDarkMode {
                return UIImage(systemName: "ellipsis")!
                    .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "ellipsis")!
                    .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            }
        }

        static var arrowshapeTurnUp: UIImage {
            UIImage(systemName: "arrowshape.turn.up.left.fill")!
                .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        }

        static var link: UIImage {
            UIImage(systemName: "link")!
                .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        }

        static var boltFill: UIImage {
            UIImage(systemName: "bolt.fill")!
                .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        }

        static var docPlainText: UIImage {
            UIImage(systemName: "doc.plaintext")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        }

        static var textQuote: UIImage {
            UIImage(systemName: "text.quote")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        }
        
        static var sortType: UIImage {
            UIImage(systemName: "tray.and.arrow.down.fill")!
                .withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        }
        
        static var postListing: UIImage {
            UIImage(systemName: "checkmark.seal.fill")!
                .withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        }
    }
}

extension Config {
    struct Nib {
        static func loadNib(name: String?) -> UINib? {
            guard let name = name else {
                return nil
            }

            let bundle = Bundle.main
            let nib = UINib(nibName: name, bundle: bundle)

            return nib
        }
    }
}
