//
//  OnboardingView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.03.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    var body: some View {
        
        // #1
        VStack {
            Spacer(minLength: 150)
            Image(systemName: "wand.and.stars")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80, alignment: .center)
            Text("Welcome To My App")
                .font(Font.title2.bold().lowercaseSmallCaps())
                .multilineTextAlignment(.center)
            Spacer(minLength: 60)
            Text("Something something this app 🤪")
            Spacer(minLength: 30)
            Text("And another something!")
            Spacer(minLength: 90)
            Text("And finally 🥳...some...thing")
            
            // #2
            OnboardingButton()
        }
        .background(Color.gray)
        .foregroundColor(.white)
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView()
            OnboardingView()
        }
    }
}
