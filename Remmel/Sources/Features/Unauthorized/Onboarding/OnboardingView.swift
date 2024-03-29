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
                .font(.system(size: 50))
                .fontWeight(.heavy)
                .minimumScaleFactor(0.5)
                .scaledToFit()
                .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            
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
            .padding(.init(top: 0, leading: 0, bottom: 16, trailing: 0))
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
                    .font(.system(size: 35))
                    .frame(width: 50)
                    .foregroundColor(imageColor)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text(title).bold()
                    Text(description)
                        .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 16))
                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView()
        }
    }
}
