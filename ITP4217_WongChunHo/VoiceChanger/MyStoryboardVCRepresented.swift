//
//  MyStoryboardVCRepresented.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 25/4/2023.
//

import SwiftUI

struct RecordAudioView: View {
    var body: some View {
        ZStack{
            VStack{
                MyStoryboardVCRepresented()
            }
        }
        
    }
}

struct MyStoryboardVCRepresented_Previews: PreviewProvider {
    static var previews: some View {
        RecordAudioView()
    }
}
