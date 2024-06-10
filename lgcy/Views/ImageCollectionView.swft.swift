import SwiftUI

struct ImageCollectionView: View {
    @EnvironmentObject private var galleryViewModel: GalleryViewModel
    @State private var number: Int = 1
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
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: imageModel.image)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                            .clipped()
                            .opacity(galleryViewModel.selectedImageIDs.contains(imageModel.id) ? 0.5 : 1.0)
                            .onTapGesture {
                                toggleSelection(for: imageModel)
                            }.zIndex(1)
                        if let index = galleryViewModel.selectedImageIDs.firstIndex(of: imageModel.id) {
                            NumberBadge(number: index + 1)
                                .zIndex(2)
                        }
                    }
                }
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
            if imageArray.isEmpty {
                action(false)
            } else {
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
            if galleryViewModel.selectedImageIDs.count == 3 {
                return
            }
            galleryViewModel.selectedImageIDs.insert(imageModel.id, at: galleryViewModel.selectedImageIDs.count)
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
