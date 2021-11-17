//
//  OnboardingView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.03.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    var dismiss: (() -> Void)?
    
    var onUserOwnInstance: (() -> Void)?
    var onLemmyMlInstance: (() -> Void)?
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Welcome to Remmel!")
                .fontWeight(.heavy)
                .font(.system(size: 50))
                .frame(width: 300, alignment: .center)
                .multilineTextAlignment(.center)
            
            //            Image("Icon-transparent")
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .frame(width: 80, height: 80, alignment: .center)
             
            VStack(alignment: .leading) {
                NewDetail(image: "person.2.fill",
                          imageColor: .pink,
                          title: "Multi account & instance",
                          description: "You can add multiple instances and accounts to it.")
                NewDetail(image: "doc.text.magnifyingglass",
                          imageColor: .orange,
                          title: "Most features",
                          description: "Discovering content from lemmy's federation now easier.")
                NewDetail(image: "network",
                          imageColor: .blue,
                          title: "Latest API",
                          description: "Remmel will support only latest version of lemmy.")
            }
            
            Spacer()
            
            OnboardingButton(text: "Continue with my instance") {
                self.dismiss?()
                self.onUserOwnInstance?()
            }
            
            OnboardingButton(text: "Continue with lemmy.ml") {
                self.dismiss?()
                self.onLemmyMlInstance?()
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct NewDetail: View {
    var image: String
    var imageColor: Color
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: image)
                    .font(.system(size: 50))
                    .frame(width: 50)
                    .foregroundColor(imageColor)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text(title).bold()
                    
                    Text(description)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }.frame(width: 340, height: 100)
        }
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
