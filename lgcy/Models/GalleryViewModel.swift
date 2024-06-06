//
//  GalleryViewModel.swift
//  lgcy
//
//  Created by Evan Boymel on 6/6/24.
//

import SwiftUI

class GalleryViewModel: ObservableObject {
    @Published var images: [ImageModel] = [
        ImageModel(imageName: "image1"),
        ImageModel(imageName: "image2"),
        ImageModel(imageName: "image3"),
        ImageModel(imageName: "image4"),
        ImageModel(imageName: "image5"),
        ImageModel(imageName: "image6"),
        ImageModel(imageName: "image7"),
        ImageModel(imageName: "image8"),
        ImageModel(imageName: "image9"),
        ImageModel(imageName: "image10"),
        ImageModel(imageName: "image11"),
    ]
}
