//
//  ContentView+Onboarding.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.03.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import SwiftUI

struct ContentView_Onboarding: View {
    @State var appSetupState = "App NOT setup ☹️"
    
    // #1
    @AppStorage("needsAppOnboarding", store: LemmyShareData.shared.userDefaults)
    var needsAppOnboarding: Bool = true
    
    var body: some View {
        
        // #2
        mainView.onAppear {
            
            if !needsAppOnboarding {
                // Scenario #2: User has completed app onboarding
                appSetupState = "App setup 😀"
            }
        }
    }
}

struct ContentView_Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_Onboarding()
    }
}
