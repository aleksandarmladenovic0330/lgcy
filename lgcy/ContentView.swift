import SwiftUI

struct ContentView: View {
    @State private var showPopover = false
    @State private var popoverPosition: CGPoint = .zero
    @StateObject private var galleryViewModel: GalleryViewModel = GalleryViewModel()
    
    var body: some View {
        NavigationView(content: {
            VStack {
                Text("Recents")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ZStack {
                    ImageCollectionView(action: {
                        showPopover = true;
                    })
                    
                    if showPopover {
                        Color.black.opacity(0.2)
                            .edgesIgnoringSafeArea(.all)
                            .transition(.opacity)
                        PopupView(showPopover: $showPopover)
                            .position(x: UIScreen.main.bounds.width / 2, y: 250)
                            .transition(.move(edge: .top))
                            .zIndex(1)
                    }
                }
            }
        })
        .environmentObject(galleryViewModel).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
