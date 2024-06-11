import SwiftUI

struct PopupView: View {
    @Binding var showPopover: Bool
    @EnvironmentObject var galleryViewModel: GalleryViewModel

    var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.showPopover = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("New post")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: ImageDetailView()){
                        Text("Next")
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                .padding()
                if galleryViewModel.currentSelected?.type == 0 {
                    ZoomableView()
                } else {
                    if let videoAsset = galleryViewModel.currentSelected?.video {
                        VideoPlayerView(asset: videoAsset)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 400)
            .background(Color.black)
            .shadow(radius: 10)
        
    }
}

struct PopupView_preview: PreviewProvider {
    static var previews: some View {
        PopupViewWrapper()
    }
}

struct PopupViewWrapper: View {
    @StateObject private var galleryViewModel: GalleryViewModel = GalleryViewModel()
    @State private var showPopover: Bool = true;
    var body: some View {
        PopupView(showPopover: $showPopover).environmentObject(galleryViewModel)
    }
}
