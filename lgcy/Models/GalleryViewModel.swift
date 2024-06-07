//
//  GalleryViewModel.swift
//  lgcy
//
//  Created by Evan Boymel on 6/6/24.
//

import SwiftUI

class GalleryViewModel: ObservableObject {
    var count = 50;
    @Published var images: [ImageModel]
    init() {
        images = (0..<count).map { index in
            let formattedIndex = String(format: "%02d", index % 10 + 1)
            return ImageModel(imageName: "image\(formattedIndex)")
        }
    }
    @Published var selectedImageIDs: Set<UUID> = []
    @Published var currentSelectedImageId: UUID? = nil
    @Published var currentSelectedImageName: String? = nil
}
