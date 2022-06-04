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
            }, label: {
                Text("Reset Onboarding")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .font(Font.title2.bold().lowercaseSmallCaps())
            })
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(40)
            
            .sheet(isPresented: $needsAppOnboarding) {
                OnboardingView()
            }
            
            .onChange(of: needsAppOnboarding) { needsAppOnboarding in
                if !needsAppOnboarding {
                    appSetupState = "App setup 😀"
                }
            }
            Spacer()
            Text(appSetupState)
            Spacer()
        }
    }
}
