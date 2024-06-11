//
//  GalleryViewModel.swift
//  lgcy
//
//  Created by Evan Boymel on 6/6/24.
//

import Photos
import SwiftUI
import AVFoundation

class GalleryViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var selectedImageIDs: [UUID] = []
    @Published var currentSelected: ImageModel? = nil
    @Published var limit: Int = 10
    init() {
        self.requestAuthorization()
        self.requestVideos()
    }
    
    func requestVideos() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
                let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
                
                var videos: [PHAsset] = []
                fetchResult.enumerateObjects { (asset, _, _) in
                    videos.append(asset)
                }
                
                DispatchQueue.main.async {
                    for asset in videos {
                        self.generateThumbnail(asset: asset) { image in
                            if let image = image {
                                self.images.append(ImageModel(image: image, video: asset, type: 1))
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func generateThumbnail(asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let imageManager = PHImageManager.default()
        let options = PHVideoRequestOptions()
        options.version = .current
        
        imageManager.requestAVAsset(forVideo: asset, options: options) { (avAsset, _, _) in
            guard let avAsset = avAsset else { return }
            let assetGenerator = AVAssetImageGenerator(asset: avAsset)
            assetGenerator.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 0, preferredTimescale: 60)
            
            do {
                let imageRef = try assetGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: imageRef)
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                completion(nil)
            }
        }
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
                    let imageModel = ImageModel(image: image, video: nil, type: 0)
                    self.images.append(imageModel)
                    if (self.currentSelected == nil) {
                        self.currentSelected = imageModel
                        self.selectedImageIDs.insert(imageModel.id, at: 0)
                    }
                }
            }
        }
    }
}
