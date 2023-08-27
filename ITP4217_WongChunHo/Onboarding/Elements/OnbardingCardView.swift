//
//  OnbardingCardView.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 25/4/2023.
//

import SwiftUI

struct OnbardingCardView: View {
    
    var card: OnboardingCard
    @State var transparency = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text(card.title.capitalized)
                .colorInvert()
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .scaleEffect(transparency ? 0.8 : 1)
                .animation(Animation.spring().repeatForever(autoreverses: true))
                .onAppear(){
                    transparency.toggle()
                }
            VStack(alignment: .leading, spacing: 25) {
                Text(card.subTitle)
                    .foregroundColor(.black)
                    .font(.bold(.title2)())
                    .lineLimit(3)
                    .frame(width: 200)
                    .fixedSize()
                    .padding()
                Image(card.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 200, alignment: .center)
            }
            .shadow(radius: 1)
            .padding(20)
            .background(Color.white)
            .cornerRadius(25)
        }
    }
}
