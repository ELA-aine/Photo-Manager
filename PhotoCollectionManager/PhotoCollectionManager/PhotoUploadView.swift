import SwiftUI
import PhotosUI

// MARK: - PhotoUploadView

struct PhotoUploadView: View {
    var onPhotoUpload: (Photo) -> Void  // Callback for photo upload

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedFileURL: URL? = nil
    @State private var selectedImage: Image? = nil
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var category: Category = .other
    @State private var showingSuccessAlert = false
    @State private var isFileImporterPresented = false

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    labelView(text: "Photo Library")
                }

                Button(action: {
                    isFileImporterPresented = true
                }) {
                    labelView(text: "Local Files")
                }
                .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.image]) { result in
                    handleFileImport(result)
                }
            }

            if let image = selectedImage {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                    .frame(height: 200)
                    .overlay(Text("No image selected").foregroundColor(.gray))
            }

            TextField("Photo Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Category", selection: $category) {
                ForEach(Category.allCases.filter { $0 != .all }, id: \.self) { category in
                    Text(category.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            Button("Upload Photo") {
                uploadPhoto()
            }
            .disabled(selectedImage == nil || name.isEmpty || location.isEmpty)
            .buttonStyle(.borderedProminent)
            .alert("Photo Uploaded!", isPresented: $showingSuccessAlert) {
                Button("OK", role: .cancel) { }
            }

            Spacer()
        }
        .padding()
        .onChange(of: selectedItem) { newItem in
            loadSelectedImage(newItem)
        }
    }

    private func labelView(text: String) -> some View {
        Text(text)
            .padding(10)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
    }

    private func loadSelectedImage(_ item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    saveImageToLocalDirectory(data: data)
                }
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }

    private func handleFileImport(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            do {
                let data = try Data(contentsOf: url)
                saveImageToLocalDirectory(data: data)
            } catch {
                print("Error reading file: \(error.localizedDescription)")
            }
        case .failure(let error):
            print("Failed to import file: \(error.localizedDescription)")
        }
    }

    private func saveImageToLocalDirectory(data: Data) {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let uniqueFileName = UUID().uuidString + ".png"
        let fileURL = directory.appendingPathComponent(uniqueFileName)

        do {
            try data.write(to: fileURL)
            selectedFileURL = fileURL
            if let nsImage = NSImage(data: data) {
                selectedImage = Image(nsImage: nsImage)
            }
        } catch {
            print("Failed to save image: \(error.localizedDescription)")
        }
    }

    private func uploadPhoto() {
        guard let imageURL = selectedFileURL else {
            print("No file URL available.")
            return
        }

        let photo = Photo(
            id: UUID(),
            name: name,
            location: location,
            category: category,
            imgUrl: imageURL,
            date: Date()
        )

        onPhotoUpload(photo)
        showingSuccessAlert = true
        resetForm()
    }

    private func resetForm() {
        selectedItem = nil
        selectedFileURL = nil
        selectedImage = nil
        name = ""
        location = ""
        category = .other
    }
}


