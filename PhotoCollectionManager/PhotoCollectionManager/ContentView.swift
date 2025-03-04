//
//  ContentView.swift
//  PhotoCollectionManager
//
//  Created by Elaine G on 2025-02-22.
//

import SwiftUI
import PhotosUI
import GoogleGenerativeAI


// MARK: - ContentView
struct ContentView: View {
    @StateObject private var viewModel = PhotoViewModel()

    var body: some View {
        TabView {
            PhotoGalleryView(photos: $viewModel.photos)
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }

            PhotoUploadView { uploadedPhoto in
                viewModel.addPhoto(uploadedPhoto)
            }
            .tabItem {
                Label("Upload", systemImage: "square.and.arrow.up")
            }
            
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
        }
    }
}


#Preview {
    ContentView()
}
