import SwiftUI
import CoreImage

struct ImageDetailView: View {
    @EnvironmentObject var galleryViewModel: GalleryViewModel
    @State private var showImageIndex: Int = -1
    private let context = CIContext()

    func generateFilteredImages(to image: UIImage) -> [UIImage] {
        let context = CIContext()
        let ciImage = CIImage(image: image)
        
        let filters: [CIFilter] = [
            CIFilter(name: "CIPhotoEffectMono")!,
            CIFilter(name: "CIPhotoEffectProcess")!,
            CIFilter(name: "CIPhotoEffectTransfer")!,
            CIFilter(name: "CIPhotoEffectInstant")!,
            CIFilter(name: "CIPhotoEffectNoir")!,
            CIFilter(name: "CIPhotoEffectFade")!
        ]
        
        var filteredImages: [UIImage] = []
        
        for filter in filters {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let filteredUIImage = UIImage(cgImage: cgImage)
                filteredImages.append(filteredUIImage)
            }
        }
        
        return filteredImages
    }

    var body: some View {
        VStack {
            if let originalImage = UIImage(named: galleryViewModel.currentSelectedImageName ?? "image01") {
                let filteredImages = generateFilteredImages(to: originalImage)
                let showImage = showImageIndex == -1 ? originalImage : filteredImages[showImageIndex]
                Image(uiImage: showImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 600)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Image(uiImage: originalImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .onTapGesture {
                                showImageIndex = -1
                            }
                        ForEach(Array(filteredImages.enumerated()), id: \.element) {index, filteredImage in
                            Image(uiImage: filteredImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .onTapGesture {
                                    showImageIndex = index;
                                }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ImageDetailViewWrapper()
}

struct ImageDetailViewWrapper: View {
    @StateObject private var galleryViewModel: GalleryViewModel = GalleryViewModel()
    var body: some View {
        ImageDetailView().environmentObject(galleryViewModel)
    }
}
