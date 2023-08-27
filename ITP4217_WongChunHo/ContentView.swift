//
//  ContentView.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 31/3/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        OnboardingView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct TabBarView: View {
//    @State private var selectedTab = 0
//
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            TextRecognitionView()
//                .tabItem {
//                    Image(systemName: "camera.fill")
//                    Text("Scan")
//                }
//                .tag(0)
//
//            TextRecognitionView()
//                .tabItem {
//                    Image(systemName: "square.and.pencil")
//                    Text("Manual")
//                }
//                .tag(1)
//
//        }
//    }
//}
