//
//  OnboardingCardsData.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 25/4/2023.
//

import SwiftUI

class OnboardingCardsData: ObservableObject {
    
    let cards: [OnboardingCard]
    
    var primary: OnboardingCard {
        cards.first!
    }
    
    init() {
        cards = Bundle.main.decode([OnboardingCard].self, from: "cards.json")
    }
}
