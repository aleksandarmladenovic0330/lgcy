import SwiftUI

struct ContentView: View {
    @State private var showPopover = true
    @State private var popoverPosition: CGPoint = .zero
    @StateObject private var galleryViewModel: GalleryViewModel = GalleryViewModel()
    
    var body: some View {
        NavigationView(content: {
            VStack {
                Text("Recents")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if showPopover {
                        PopupView(showPopover: $showPopover)
                            
                    }
                
                    ImageCollectionView(action: {isSelected in
                        showPopover = isSelected;
                    })
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
