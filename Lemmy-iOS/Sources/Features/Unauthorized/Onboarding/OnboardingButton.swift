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
            self.needsAppOnboarding = true
            
            action?()
        }, label: {
            Text(text)
                .foregroundColor(.white)
                .font(.headline)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
                .background(Color.blue)
                .cornerRadius(15)
                .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        })
        .background(Color(UIColor.systemBackground))
    }
}

struct OnboardingButton_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingButton(text: "Haha")
    }
}
