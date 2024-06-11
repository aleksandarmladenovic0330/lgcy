import SwiftUI
import Photos
import AVKit

struct VideoPlayerView: View {
    var asset: PHAsset

    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = false

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                        isPlaying = true
                    }
            } else {
                Text("Loading video...")
                    .onAppear {
                        getVideoURL(from: asset) { url in
                            if let url = url {
                                player = createPlayer(from: url)
                            }
                        }
                    }
            }

            HStack {
                Button(action: {
                    player?.play()
                    isPlaying = true
                }) {
                    Image(systemName: "play.fill")
                        .padding()
                }

                Button(action: {
                    player?.pause()
                    isPlaying = false
                }) {
                    Image(systemName: "pause.fill")
                        .padding()
                }

                Button(action: {
                    player?.pause()
                    player?.seek(to: CMTime.zero)
                    isPlaying = false
                }) {
                    Image(systemName: "stop.fill")
                        .padding()
                }
            }
            .disabled(player == nil)
        }
    }
    
    func getVideoURL(from asset: PHAsset, completion: @escaping (URL?) -> Void) {
        let options = PHVideoRequestOptions()
        options.version = .original
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, _, _) in
            if let urlAsset = avAsset as? AVURLAsset {
                completion(urlAsset.url)
            } else {
                completion(nil)
            }
        }
    }
    
    func createPlayer(from url: URL) -> AVPlayer {
        return AVPlayer(url: url)
    }
}
