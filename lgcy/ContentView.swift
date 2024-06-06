//
//  ContentView.swift
//  lgcy
//
//  Created by Evan Boymel on 6/5/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GalleryViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView{
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(viewModel.images) { imageModel in
                       Image(imageModel.imageName)
                           .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 200, height: 200)
                           .frame(width: UIScreen.main.bounds.width / 3 - 4, height: UIScreen.main.bounds.width / 3 - 4)
                           .frame(width: UIScreen.main.bounds.width / 3 - 4, height: UIScreen.main.bounds.width / 3 - 4)
                           .frame(width: UIScreen.main.bounds.width / 3 - 4, height: UIScreen.main.bounds.width / 3 - 4)
                           .clipped()
                                       }
                }
                .padding(.horizontal, 2)
            }
            .navigationTitle("Recents")
            .navigationBarItems(trailing: Button(action: {
                
            }) {
                Image(systemName: "camera")
            })
        }
    }
}

#Preview {
    ContentView()
}
