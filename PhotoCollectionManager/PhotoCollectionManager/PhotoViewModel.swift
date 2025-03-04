//
//  PhotoViewModel.swift
//  PhotoCollectionManager
//
//  Created by Elaine G on 2025-02-22.
//

import SwiftUI

class PhotoViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: Category = .all

    private let photosKey = "savedPhotos"

    init() {
        loadPhotos()
    }

    // MARK: - Add a New Photo
    func addPhoto(_ photo: Photo) {
        photos.append(photo)
        savePhotos()
    }

    // MARK: - Remove a Photo
    func removePhoto(at indexSet: IndexSet) {
        photos.remove(atOffsets: indexSet)
        savePhotos()
    }

    // MARK: - Filtered Photos
    var filteredPhotos: [Photo] {
        photos.filter { photo in
            (selectedCategory == .all || photo.category == selectedCategory) &&
            (searchText.isEmpty ||
             photo.name.localizedCaseInsensitiveContains(searchText) ||
             photo.location.localizedCaseInsensitiveContains(searchText) ||
             photo.category.rawValue.localizedCaseInsensitiveContains(searchText))
        }
    }

    // MARK: - Save Photos to UserDefaults
    private func savePhotos() {
        do {
            let data = try JSONEncoder().encode(photos)
            UserDefaults.standard.set(data, forKey: photosKey)
        } catch {
            print("Failed to save photos: \(error.localizedDescription)")
        }
    }

    // MARK: - Load Photos from UserDefaults
    private func loadPhotos() {
        guard let data = UserDefaults.standard.data(forKey: photosKey) else { return }
        do {
            photos = try JSONDecoder().decode([Photo].self, from: data)
        } catch {
            print("Failed to load photos: \(error.localizedDescription)")
        }
    }
}
