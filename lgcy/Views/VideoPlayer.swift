import SwiftUI
import Photos
import AVKit

struct VideoPlayerView: View {
    var asset: PHAsset

    @State private var player: AVPlayer?
    @State private var playerObserver: Any?

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

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                        addPlaybackObserver()
                    }
                    .onDisappear {
                        removePlaybackObserver()
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
        }
    }

    func addPlaybackObserver() {
        guard let player = player else { return }
        
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        playerObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak player] time in
            if time.seconds >= 45 {
                player?.pause()
                player?.seek(to: .zero)
            }
        }
    }

    func removePlaybackObserver() {
        if let playerObserver = playerObserver, let player = player {
            player.removeTimeObserver(playerObserver)
            self.playerObserver = nil
        }
    }
}
