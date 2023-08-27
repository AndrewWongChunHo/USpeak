//
//  TextRecognitionView.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 31/3/2023.
//

import SwiftUI
import AVFoundation

struct TextRecognitionView: View {
    
    @State private var recognizedText = "Tap button to start scanning."
    
    @State private var isVisualizing = false
    
    @State private var showingScanningView = false
    
    var body: some View {
        ZStack{
            
            VStack {
                HStack{
                    Image("scanIcon")
                        .resizable()
                        .frame(width: 60, height: 60)
                    Text("Text To Speech")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                    Spacer()
                }
                .padding(.horizontal, 15)
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.lightBlue.gradient)
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        Text(recognizedText)
                            .padding()
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .frame(height: 400)
                    .padding()
                    
                    RoundedRectangle(cornerRadius: 44)
                        .fill(Color.mediumBlue)
                        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        .frame(width: 380, height: 202)
                        .padding(.top, 14.43)
                        .overlay(
                            VStack {
                                HStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.gradient)
                                        .frame(width:68, height: 68)
                                        .overlay(Text("TEXT")
                                            .font(.headline)
                                            .foregroundColor(.mediumBlue)
                                            .fontWeight(.bold)
                                                 )
                                    
                                    VStack(alignment: .leading) {
                                        Text("Your Text to Speech")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("You")
                                            .foregroundColor(Color(.systemGray2))
                                    }
                                    Spacer()
                                    
                                    //Add the visualizer
                                    HStack{
                                        ForEach(0 ..< 6) { item in
                                            RoundedRectangle(cornerRadius: 2)
                                                .frame(width: 3, height: .random(in: isVisualizing ? 8...16 : 4...45))
                                            .foregroundColor(.white)
                                            }
                                        .animation(.easeInOut(duration: 0.25).repeatForever(autoreverses: true), value: isVisualizing)
                                        .onAppear{
                                            isVisualizing.toggle()
                                        }
                                    }

                                }
                                .padding(.leading, -10)
                                .padding(EdgeInsets(top:-32, leading: 24, bottom: 0, trailing: 24))
                                
                                HStack {
                                    //Scan button
                                    Button(action: {
                                        self.showingScanningView = true
                                    }) {
                                        Text("Start Scanning")
                                    }
                                    .padding()
                                    .padding(.horizontal, 9)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .background(Capsule().fill(Color.lightBlue))
                                    
                                    //Read button
                                    Button {
                                        let speechSynthesizer = AVSpeechSynthesizer()

                                        let utterance = AVSpeechUtterance(string: recognizedText)
                                        utterance.pitchMultiplier = 1.0
                                        utterance.rate = 0.5
                                        utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")

                                        do {
                                            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                                            try AVAudioSession.sharedInstance().setActive(true)
                                            speechSynthesizer.speak(utterance)
                                        } catch {
                                            print("Error: \\\\(error.localizedDescription)")
                                        }

                                        let voices = AVSpeechSynthesisVoice.speechVoices()

                                        for voice in voices {
                                            print(voice.language)
                                        }

                                    } label: {
                                        Text("Read")
                                            .padding()
                                            .foregroundColor(Color.mediumBlue)
                                            .padding(.horizontal, 45)
                                            .background(Capsule().fill(Color.white))
                                         .fontWeight(.bold)
                                    }
                                }
                                
                                .padding(.top, 10)
                                .padding(.bottom, -40)
                            }
                        )
                        .padding(.top, -10)
                }
                .padding(.top, -25)
                .navigationBarTitle("Text Recognition")
                .sheet(isPresented: $showingScanningView) {
                    ScanDocumentView(recognizedText: self.$recognizedText)
                }
            }
            .padding(.top, 60)
        }
        .background(Image("gradientBackground4")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
          
        }
    
    }


struct TextRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        TextRecognitionView()
    }
}
