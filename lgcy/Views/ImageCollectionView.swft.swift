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
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(galleryViewModel.images) { imageModel in
                ImagePreview(imageModel: imageModel, toggleSelection: {imageModel in
                    self.toggleSelection(for: imageModel)
                })
            }
            .padding(.horizontal, 2)
        }
    }

    private func toggleSelection(for imageModel: ImageModel) {
        if galleryViewModel.selectedImageIDs.contains(imageModel.id) {
            if let imageIndex = galleryViewModel.selectedImageIDs.firstIndex(of: imageModel.id) {
                
                galleryViewModel.selectedImageIDs.remove(at: imageIndex)
            }
            let imageArray = Array(galleryViewModel.selectedImageIDs)
            if !imageArray.isEmpty {
                if let foundImage = galleryViewModel.images.first(where: {
                    $0.id == imageArray[imageArray.count - 1]
                }) {
                    galleryViewModel.currentSelected = foundImage;
                    action(true)
                } else {
                    galleryViewModel.currentSelected = nil;
                    action(false)
                }
            }
        } else {
            if galleryViewModel.selectedImageIDs.count == galleryViewModel.limit {
                if galleryViewModel.limit == 1 {
                    galleryViewModel.selectedImageIDs.removeAll()
                    galleryViewModel.selectedImageIDs.insert(imageModel.id, at: 0)
                    
                    galleryViewModel.currentSelected = imageModel
                }
                
                return
            }
            galleryViewModel.selectedImageIDs.insert(imageModel.id, at: galleryViewModel.selectedImageIDs.count)
            galleryViewModel.currentSelected = imageModel
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
