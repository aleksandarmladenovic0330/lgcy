//
//  GalleryViewModel.swift
//  lgcy
//
//  Created by Evan Boymel on 6/6/24.
//

import SwiftUI

class GalleryViewModel: ObservableObject {
    @Published var images: [ImageModel] = [
        ImageModel(imageName: "image01"),
        ImageModel(imageName: "image02"),
        ImageModel(imageName: "image03"),
        ImageModel(imageName: "image04"),
        ImageModel(imageName: "image05"),
        ImageModel(imageName: "image06"),
        ImageModel(imageName: "image07"),
        ImageModel(imageName: "image08"),
        ImageModel(imageName: "image09"),
        ImageModel(imageName: "image10"),
        ImageModel(imageName: "image11"),
    ]
}
