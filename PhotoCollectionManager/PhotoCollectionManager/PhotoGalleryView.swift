import SwiftUI
import PhotosUI
import GoogleGenerativeAI


// MARK: - PhotoGalleryView with Sidebar Navigation
struct PhotoGalleryView: View {
    @Binding var photos: [Photo]
    @State private var selectedCategory: Category? = nil
    @State private var searchText: String = ""

    init(photos: Binding<[Photo]>) {
        self._photos = photos
    }

    let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        NavigationSplitView(sidebar: {
            // Sidebar with categories
            List(Category.allCases, id: \.self, selection: $selectedCategory) { category in
                Text(category.rawValue)
            }
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search photos...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 300)
            }
            .padding(.horizontal)
            
            .navigationTitle("Categories")
        }, detail: {
            VStack(spacing: 16) {
                // Search Bar
              

                // Photo Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredPhotos) { photo in
                            VStack {
                                if let url = photo.imgUrl, FileManager.default.fileExists(atPath: url.path),
                                   let data = try? Data(contentsOf: url),
                                   let nsImage = NSImage(data: data) {
                                    Image(nsImage: nsImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                        .frame(height: 100)
                                        .overlay(Text("No Image").foregroundColor(.gray))
                                }

                                Text(photo.name)
                                    .font(.headline)
                                    .lineLimit(1)
                                Text(photo.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(selectedCategory?.rawValue ?? "All Photos")
        })
    }

    var filteredPhotos: [Photo] {
        photos.filter { photo in
            (selectedCategory == nil || photo.category == selectedCategory) &&
            (searchText.isEmpty ||
             photo.name.localizedCaseInsensitiveContains(searchText) ||
             photo.location.localizedCaseInsensitiveContains(searchText) ||
             photo.category.rawValue.localizedCaseInsensitiveContains(searchText))
        }
    }
}
