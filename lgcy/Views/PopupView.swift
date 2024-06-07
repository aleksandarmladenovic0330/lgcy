import SwiftUI

struct PopupView: View {
    @Binding var showPopover: Bool

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
                ZoomableView()
            }
            .frame(width: UIScreen.main.bounds.width, height: 600)
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
