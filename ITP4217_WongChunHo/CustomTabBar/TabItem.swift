//
//  TabItem.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 25/4/2023.
//

import Foundation
import UIKit

enum TabItem: String, CaseIterable {
    case scan
    case voice
    case sound
    case ar
    
    var description: String {
        switch self {
        case .scan:
            return "Speech"
        case .voice:
            return "Emoji Game"
        case .sound:
            return "Voice"
        case .ar:
            return "AR"
        }
    }
    
    var icon: String {
           switch self {
           case .scan:
               return "scanner.fill"
               
           case .voice:
               return "music.mic"
               
           case .sound:
               return "play.fill"
               
           case .ar:
               return "rotate.3d"
           }
       }
   }

extension UIApplication {
    static var safeAreaInsets: UIEdgeInsets  {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
}



