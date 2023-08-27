//
//  TabBarView.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 25/4/2023.
//
import SwiftUI

struct TabBarView : View {
    var tabItems = TabItem.allCases
    
    @State var selected: TabItem = .scan
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View{
        
        VStack(spacing: 0){
            TabView(selection: $selected){
                TextRecognitionView()
                    .tag(tabItems[0])
                    .ignoresSafeArea(.all)
                
                EmojiGameView()
                    .tag(tabItems[1])
                    .ignoresSafeArea(.all)
                
                RecordAudioView()
                    .tag(tabItems[2])
                    .ignoresSafeArea(.all)
                
                 ARVoiceControlView()
                    .tag(tabItems[3])
                    .ignoresSafeArea(.all)
            }
            Spacer(minLength: 0)
            CustomTabBarView(tabItems: tabItems, selected: $selected)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
