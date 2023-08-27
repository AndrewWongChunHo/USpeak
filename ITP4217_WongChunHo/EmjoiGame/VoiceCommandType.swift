//
//  VoiceCommandType.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 26/4/2023.
//

import SwiftUI

enum VoiceCommandType: Int, CaseIterable {
    case happy
    case unhappy
    case sad
    case angry
    case cry
    case confused
    case nervous
    case alien
    case love
    case moonFace
    case shy
    case kiss
    

    var name: String {
        switch self {
        case .happy:
            return "Happy"
        case .unhappy:
            return "Unhappy"
        case .sad:
            return "Depressed"
        case .angry:
            return "Angry"
        case .cry:
            return "Cry"
        case .confused:
            return "Confused"
        case .nervous:
            return "Nervous"
        case .alien:
            return "Alien"
        case .love:
            return "Love"
        case .moonFace:
            return "Moon Face"
        case .shy:
            return "Shy"
        case .kiss:
            return "Kiss"
        default:
            return ""
        }
    }

}
