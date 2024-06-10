//
//  GalleryViewModel.swift
//  lgcy
//
//  Created by Evan Boymel on 6/6/24.
//

import Photos
import SwiftUI

class GalleryViewModel: ObservableObject {
    var count = 50;
    @Published var images: [ImageModel] = []
    @Published var selectedImageIDs: Set<UUID> = []
    @Published var currentSelected: ImageModel? = nil
    init() {
//        images = (0..<count).map { index in
//            let formattedIndex = String(format: "%02d", index % 10 + 1)
//            return ImageModel(imageName: "image\(formattedIndex)")
//        }
        self.requestAuthorization()
    }
    
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization{status in if status == .authorized {
                self.fetchPhotos()
            } else {
                print("Permission denied")
            }
        }
    }
    
    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        fetchResult.enumerateObjects { (asset, _, _) in
            self.requestImage(for: asset)
        }
    }
    
    private func requestImage(for asset: PHAsset) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .current
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat

        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options) { image, _ in
            if let image = image {
                DispatchQueue.main.async {
                    let imageModel = ImageModel(image: image)
                    self.images.append(imageModel)
                    self.currentSelected = imageModel
                }
            }
        }
    }
}
