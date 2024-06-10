import SwiftUI

struct ImageCollectionView: View {
    @EnvironmentObject private var galleryViewModel: GalleryViewModel
    let action: (Bool) -> Void

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(galleryViewModel.images) { imageModel in
                    Image(uiImage: imageModel.image)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                        .clipped()
                        .opacity(galleryViewModel.selectedImageIDs.contains(imageModel.id) ? 0.5 : 1.0)
                        .onTapGesture {
                            toggleSelection(for: imageModel)
                        }
                }
            }
            .padding(.horizontal, 2)
        }
    }

    private func toggleSelection(for imageModel: ImageModel) {
        if galleryViewModel.selectedImageIDs.contains(imageModel.id) {
            galleryViewModel.selectedImageIDs.remove(imageModel.id)
            let imageArray = Array(galleryViewModel.selectedImageIDs)
            if imageArray.isEmpty {
                action(false)
            } else {
                if let foundImage = galleryViewModel.images.first(where: {
                    $0.id == imageArray[imageArray.count - 1]
                }) {
                    print(imageArray)
                    galleryViewModel.currentSelected = foundImage;
                    action(true)
                } else {
                    galleryViewModel.currentSelected = nil;
                    action(false)
                }
            }
        } else {
            galleryViewModel.selectedImageIDs.insert(imageModel.id)
            galleryViewModel.currentSelected = imageModel;
            action(true)
        }
        
    }
}

struct ImageCollectionViewWrapper: View {
    @StateObject private var galleryViewModel: GalleryViewModel = GalleryViewModel()
    var body: some View {
        ImageCollectionView(action:{_ in }).environmentObject(galleryViewModel)
    }
}

#Preview {
    ImageCollectionViewWrapper()
}
