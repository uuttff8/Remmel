//
//  OnboardingButton.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.03.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import SwiftUI

struct OnboardingButton: View {
    
    @AppStorage("needsAppOnboarding", store: LemmyShareData.shared.userDefaults)
    var needsAppOnboarding: Bool = true
    
    var body: some View {
        GeometryReader { proxy in
            LazyHStack {
                Button(action: {
                    needsAppOnboarding = false
                }) {
                    Text("Finish Setup")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .font(Font.title2.bold().lowercaseSmallCaps())
                }
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(40)
                .frame(minWidth: 0, maxWidth: proxy.size.width-40)
            }
            .frame(width: proxy.size.width, height: proxy.size.height/1.5)
        }
    }
}

struct OnboardingButton_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingButton()
    }
}
