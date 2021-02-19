//
//  LMMMessagesToast.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation
import SwiftMessages

enum LMMMessagesToast {
    static func bottomConfig() -> SwiftMessages.Config {
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.presentationContext = .automatic
        config.duration = .automatic
        config.dimMode = .none
        config.interactiveHide = true
        config.shouldAutorotate = true
        return config
    }
    
    static func successBottomToast(title: String, body: String) ->  (SwiftMessages.Config, MessageView) {
        let config = LMMMessagesToast.bottomConfig()
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: title, body: body)
        view.configureTheme(.success)
        view.accessibilityPrefix = "success"
        
        view.button?.isHidden = true
        
        return (config, view)
    }
    
    static func errorBottomToast(title: String, body: String) -> (SwiftMessages.Config, MessageView) {
        let config = LMMMessagesToast.bottomConfig()
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: title, body: body)
        view.configureTheme(.error)
        view.accessibilityPrefix = "error"
        
        view.button?.isHidden = true
        
        return (config, view)
    }
    
    static func showSuccessCreateComment() {
        let config = successBottomToast(title: "Success", body: "You've created a new comment!")
        SwiftMessages.show(config: config.0, view: config.1)
    }
    
    static func showSuccessEditPost() {
        let config = successBottomToast(title: "Success", body: "You've edited your post!")
        SwiftMessages.show(config: config.0, view: config.1)
    }
}
