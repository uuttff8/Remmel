//
//  OnboardingHostingController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.03.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation
import SwiftUI

final class OnboardingHostingController: UIHostingController<OnboardingView> {
    
    @AppStorage("needsAppOnboarding", store: LemmyShareData.shared.appUserDefaults)
    var needsAppOnboarding: Bool = true

    var onUserOwnInstance: (() -> Void)?
    var onLemmyMlInstance: (() -> Void)?
    
    override init(rootView: OnboardingView) {
        super.init(rootView: OnboardingView())
        self.rootView.dismiss = dismiss
        
        self.rootView.onLemmyMlInstance = {
            self.onLemmyMlInstance?()
        }
        self.rootView.onUserOwnInstance = {
            self.onUserOwnInstance?()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: OnboardingView())
        self.rootView.dismiss = dismiss
        self.rootView.onLemmyMlInstance = onLemmyMlInstance
        self.rootView.onUserOwnInstance = onUserOwnInstance
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isBeingDismissed {
            needsAppOnboarding = false
        }
    }
    
}
