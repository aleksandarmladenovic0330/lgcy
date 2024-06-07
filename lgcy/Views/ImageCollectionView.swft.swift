import SwiftUI

struct ImageCollectionView: View {
    @EnvironmentObject private var galleryViewModel: GalleryViewModel
    let action: () -> Void

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
                        Image(imageModel.imageName)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                        .clipped()
                        .opacity(galleryViewModel.currentSelectedImageId == imageModel.id ? 0.5 : 1.0)
                        .onTapGesture {
                            toggleSelection(for: imageModel)
                        }
                }
            }
            .padding(.horizontal, 2)
        }
    }

    private func toggleSelection(for imageModel: ImageModel) {
        if (galleryViewModel.currentSelectedImageId == imageModel.id) {
            galleryViewModel.currentSelectedImageId = nil;
        } else {
            galleryViewModel.currentSelectedImageId = imageModel.id;
            galleryViewModel.currentSelectedImageName = imageModel.imageName;
        }
        action()
        if galleryViewModel.selectedImageIDs.contains(imageModel.id) {
            galleryViewModel.selectedImageIDs.remove(imageModel.id)
        } else {
            galleryViewModel.selectedImageIDs.insert(imageModel.id)
        }
    }
}

#Preview {
    ImageCollectionView(action: {})
}
