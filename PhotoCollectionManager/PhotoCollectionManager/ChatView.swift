//
//  ChatView.swift
//  PhotoCollectionManager
//
//  Created by Elaine G on 2025-02-22.
//

import SwiftUI
import GoogleGenerativeAI

 
struct ChatView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: "AIzaSyBagcrpbc69KMshfAJu7Aq53_YXQOOX8T4")
    @State var textInput = ""
    @State var aiResponse = "Hello, what can i help you"
    
    var body: some View {
        VStack {
            ScrollView{
                Text(aiResponse)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
            }
            HStack{
                TextField("Enter a message", text:$textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
                Button(action: sendMessage, label: {
                    Image(systemName: "paperplane.fill")
                })
            }
        }
        .foregroundStyle(.black)
        .padding()
        .background {
            ZStack {
                Color.white
            }
            
            .ignoresSafeArea()
        }
        
        
    }
    
    func sendMessage() {
         aiResponse = ""
            
         Task {
                do {
                    let response = try await model.generateContent(textInput)
                    
                    guard let text = response.text else  {
                        textInput = "Sorry, I could not process that.\nPlease try again."
                        return
                    }
                    
                    textInput = ""
                    aiResponse = text
                    
                } catch {
                    aiResponse = "Something went wrong!\n\(error.localizedDescription)"
                }
            }
        }
}
