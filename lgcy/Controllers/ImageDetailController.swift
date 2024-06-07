//
//  ImageDetailController.swift
//  lgcy
//
//  Created by Evan Boymel on 6/6/24.
//

import UIKit
import CoreImage

class ImageDetailController: UIViewController {
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var filteredImageView: UIImageView!
    
    let context = CIContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the original image
        originalImageView.image =  UIImage(named: "image01")
    }
    
    @IBAction func applyParisFilter(_ sender: UIButton) {
        if let image = originalImageView.image {
            filteredImageView.image = applyFilter(to: image, filterName: "CIPhotoEffectMono")
        }
    }
    
    @IBAction func applyLosAngelesFilter(_ sender: UIButton) {
        if let image = originalImageView.image {
            filteredImageView.image = applyFilter(to: image, filterName: "CIPhotoEffectProcess")
        }
    }
    
    @IBAction func applyOsloFilter(_ sender: UIButton) {
        if let image = originalImageView.image {
            filteredImageView.image = applyFilter(to: image, filterName: "CIPhotoEffectTransfer")
        }
    }
    
    @IBAction func applyMelbourneFilter(_ sender: UIButton) {
        if let image = originalImageView.image {
            filteredImageView.image = applyFilter(to: image, filterName: "CIPhotoEffectInstant")
        }
    }
    
    func applyFilter(to image: UIImage, filterName: String) -> UIImage? {
        let ciImage = CIImage(image: image)
        if let filter = CIFilter(name: filterName) {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
