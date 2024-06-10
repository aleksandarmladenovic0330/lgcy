import SwiftUI

struct ZoomableView: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var lineCount: Int = 3
    @EnvironmentObject var galleryViewModel: GalleryViewModel

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                
                if let image = galleryViewModel.currentSelected {
                    Image(uiImage: image.image)
                        .resizable()
                        .scaleEffect(scale)
                        .gesture(MagnificationGesture()
                            .onChanged { value in
                                self.scale = self.lastScale * value
                            }
                            .onEnded { value in
                                self.lastScale = self.scale
                            }
                        )
                        .overlay(
                            // Overlay the grid lines
                            GeometryReader { imageGeometry in
                                let imageWidth = imageGeometry.size.width
                                let imageHeight = imageGeometry.size.height
                                
                                Path { path in
                                    // Horizontal lines
                                    for i in 1..<lineCount {
                                        let y = imageHeight * CGFloat(i) / CGFloat(lineCount)
                                        path.move(to: CGPoint(x: 0, y: y))
                                        path.addLine(to: CGPoint(x: imageWidth, y: y))
                                    }
                                    
                                    // Vertical lines
                                    for i in 1..<lineCount {
                                        let x = imageWidth * CGFloat(i) / CGFloat(lineCount)
                                        path.move(to: CGPoint(x: x, y: 0))
                                        path.addLine(to: CGPoint(x: x, y: imageHeight))
                                    }
                                }
                                .stroke(Color.gray, lineWidth: 1)
                                .scaleEffect(scale, anchor: .center)
                            }
                        )
                } else {
                    
                }
                
            }
            .clipped()
        }
    }
}

struct ZoomableViewWrapper: View {
    @StateObject private var galleryViewModel: GalleryViewModel = GalleryViewModel()
    var body: some View {
        ZoomableView().environmentObject(galleryViewModel)
    }
}

struct ZoomableView_preview: PreviewProvider {
    
    static var previews: some View {
        ZoomableViewWrapper()
    }
}
