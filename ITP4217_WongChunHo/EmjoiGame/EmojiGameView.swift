//
//  EmojiGameView.swift
//  ITP4217_WongChunHo
//
//  Created by Croquettebb on 26/4/2023.
//

import SwiftUI

struct EmojiGameView: View {
    
    @ObservedObject var viewModel = VoiceOperationViewModel()
    @State var isRotate = false

    var body: some View {
        VStack {
            HStack{
                Image("emojiIcon")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("Say your Emoji")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                Spacer()
            }
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.lightBlue.gradient)
                    .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
                Text(setEmoji())
                    .font(.system(size: 190))
                    .foregroundColor(.white)
            }
            .frame(height: 250.0)
            .padding(.top, -10.0)
            Text("Click the button to speak ↓")
                .font(.headline)
                .bold()
                .padding()
            Text(viewModel.recognizedText)
                .font(.footnote)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .padding()
            
            Spacer()
            
            VStack{
                //hashtag
                VStack{
                    HStack {
                        ForEach(VoiceCommandType.allCases.prefix(4), id: \.self) { type in
                            Text("#" + type.name)
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10.0)
                                .padding(.vertical, 4.0)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(.black, lineWidth: 1))
                        }
                    }
                    HStack {
                        ForEach(VoiceCommandType.allCases[4..<8], id: \.self) { type in
                            Text("#" + type.name)
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10.0)
                                .padding(.vertical, 4.0)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(.black, lineWidth: 1))
                        }
                    }
                    HStack {
                        ForEach(VoiceCommandType.allCases.suffix(4), id: \.self) { type in
                            Text("#" + type.name)
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10.0)
                                .padding(.vertical, 4.0)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(.black, lineWidth: 1))
                        }
                    }
                }
                .padding(.bottom, 10)

                //Button
                Button {
                    viewModel.toggleRecognitionStatus()
                } label: {
                    Text(viewModel.isRecognized ? "End Recognition": "Start Recognition")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .frame(height: 44.0)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        .background(Capsule().fill(viewModel.isAuthorized ? (viewModel.isRecognized ? Color.red: Color.navy): Color.gray))
                        
                }
                .disabled(!viewModel.isAuthorized)
                .padding(.bottom, 16.0)
            }
            .padding(.bottom, 20)
        

        }
        .padding(.horizontal, 20.0)
        .onAppear {
            viewModel.checkStatus()
        }
        .padding(.top, 60)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
        .background(Image("gradientBackground4")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        .alert(isPresented: $viewModel.isShowAlert) {
            Alert(title: Text("Confirm"),
                  message: Text("Cannot detect your voice!"),
                  dismissButton: .default(Text("OK")))
        }
    }

    private func setEmoji() -> String {
        if viewModel.recognizedText.contains("Happy") {
            return "😋"
        } else if viewModel.recognizedText.contains("Unhappy") {
            return "😢"
        } else if viewModel.recognizedText.contains("Depressed") {
            return "☹️"
        } else if viewModel.recognizedText.contains("Angry") {
            return "😡"
        } else if viewModel.recognizedText.contains("Cry") {
            return "😭"
        } else if viewModel.recognizedText.contains("Confused") {
            return "🧐"
        } else if viewModel.recognizedText.contains("Nervous") {
            return "😖"
        } else if viewModel.recognizedText.contains("Alien") {
            return "👽"
        } else if viewModel.recognizedText.contains("Love") {
            return "🥰"
        } else if viewModel.recognizedText.contains("Moon face") {
            return "🌚"
        } else if viewModel.recognizedText.contains("Shy") {
            return "😳"
        } else if viewModel.recognizedText.contains("Kiss") {
            return "💋"
        } else {
            return "🌝"
        }
    }
}

struct EmojiGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiGameView()
    }
}
