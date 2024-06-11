//
//  ImageModel.swift
//  lgcy
//
//  Created by Evan Boymel on 6/6/24.
//

import SwiftUI
import Photos

struct ImageModel: Identifiable
{
    var id = UUID()
    var image: UIImage?
    var video: PHAsset?
    var videoLength: Double?
    var type: Int
}
