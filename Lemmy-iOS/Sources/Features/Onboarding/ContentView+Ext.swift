//
//  ContentView+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.03.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import SwiftUI

extension ContentView_Onboarding {
    
    var mainView: some View {
        VStack {
            Spacer()
            Button(action: {
                needsAppOnboarding = true
            }) {
                Text("Reset Onboarding")
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .font(Font.title2.bold().lowercaseSmallCaps())
            }
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(40)
            
            // #1
            .sheet(isPresented: $needsAppOnboarding) {
                
                // Scenario #1: User has NOT completed app onboarding
                OnboardingView()
            }
            
            // #2
            .onChange(of: needsAppOnboarding) { needsAppOnboarding in
                
                if !needsAppOnboarding {
                    
                    // Scenario #2: User has completed app onboarding during current app launch
                    appSetupState = "App setup 😀"
                }
            }
            Spacer()
            Text(appSetupState)
            Spacer()
        }
    }
}
