import SwiftUI

struct ContentView: View {
    @State private var showPopover = true
    @State private var popoverPosition: CGPoint = .zero
    @StateObject private var galleryViewModel: GalleryViewModel = GalleryViewModel()
    
    var body: some View {
        NavigationView(content: {
            VStack {
                if showPopover {
                    PopupView(showPopover: $showPopover)
                }
                
                HStack{
                    Text("Recents")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "square.on.square")
                        .foregroundColor(galleryViewModel.limit == 1 ? .white : .blue)
                        .onTapGesture {
                            galleryViewModel.limit = 11 - galleryViewModel.limit
                            if galleryViewModel.limit == 1 {
                                galleryViewModel.selectedImageIDs.removeAll()
                            }
                    }
                    NavigationLink(destination: Camera()) {Image(systemName: "camera")
                    }
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
