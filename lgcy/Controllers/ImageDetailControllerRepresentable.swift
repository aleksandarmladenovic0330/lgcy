import SwiftUI
import UIKit

struct ImageDetailControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ImageDetailController {
        return ImageDetailController()
    }

    func updateUIViewController(_ uiViewController: ImageDetailController, context: Context) {
        // Update code here
    }
}
