//
//  OnboardingCard.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 25/4/2023.
//

import SwiftUI

struct OnboardingCard: Codable, Identifiable, Equatable {

    var id: UUID
    var title: String
    var subTitle: String
    var image: String
}
