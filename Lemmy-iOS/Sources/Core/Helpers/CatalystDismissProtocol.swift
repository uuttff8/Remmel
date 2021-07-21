//
//  CatalystDismissProtocol.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CatalystDismissProtocol {
    func dismissWithExitButton(presses: Set<UIPress>)
}

extension CatalystDismissProtocol where Self: UIViewController {        
    func dismissWithExitButton(presses: Set<UIPress>) {
        guard let key = presses.first?.key else { return }
        
        if key.keyCode == .keyboardEscape {
            self.dismiss(animated: true)
        }
    }
}
