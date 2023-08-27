//
//  OnboardingContinueButton.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 25/4/2023.
//

import SwiftUI

struct OnboardingContinueButton: View {
    
    @Binding var isReadyToContinue: Bool
    @State private var showHomeView = false
    @State private var animateGradient = false
    
    var body: some View {
        Button(action: {
            showHomeView = true
        }) {
            
            let buttonTitle = isReadyToContinue ? "Let's continue" : "Skip"
            let buttonImage = isReadyToContinue ? "location.fill" : "location"
            let gradientColors = isReadyToContinue ? [Color.black, Color.black] : [Color.black, Color.black]
            
            HStack {
                Image(systemName: buttonImage)
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                Text(buttonTitle)
                    .font(.bold(.subheadline)())
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 40))
                
            }
            .shadow(radius: 5)
            .padding(5)
            .background(
                LinearGradient(colors: gradientColors,
                               startPoint: animateGradient ? .topLeading : .bottomLeading,
                               endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                .ignoresSafeArea()
            )
            .cornerRadius(15)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
        .fullScreenCover(isPresented: $showHomeView, content: TabBarView.init).transition(.move(edge: .leading))

    }
}
