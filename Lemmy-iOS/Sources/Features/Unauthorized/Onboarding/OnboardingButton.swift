//
//  OnboardingButton.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.03.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import SwiftUI

struct OnboardingButton: View {
    
    @AppStorage("needsAppOnboarding", store: LemmyShareData.shared.authUserDefaults)
    var needsAppOnboarding: Bool = true
    
    var text: String
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            self.needsAppOnboarding = false
            
            action?()
        }, label: {
            Text(text)
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 350, height: 60.0)
                .background(Color.blue)
                .cornerRadius(15)
                .padding(.top)
        })
        .background(Color(UIColor.systemBackground))
    }
}

struct OnboardingButton_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingButton(text: "Haha")
    }
}
