import SwiftUI
import Photos
import AVKit

struct VideoPlayerView: View {
    var asset: PHAsset

    @State private var player: AVPlayer?
    @State private var playerItem: AVPlayerItem?
    @State private var isPlaying: Bool = false
    @State private var currentTime: Double = 0.0
    @State private var duration: Double = 0.0

    @State private var playerObserver: Any?

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                        isPlaying = true
                        addPeriodicTimeObserver()
                    }
            } else {
                Text("Loading video...")
                    .onAppear {
                        getVideoURL(from: asset) { url in
                            if let url = url {
                                player = createPlayer(from: url)
                                playerItem = AVPlayerItem(url: url)
                                duration = playerItem?.asset.duration.seconds ?? 0.0
                                duration = duration > 45.0 ? 45.00 : duration
                            }
                        }
                    }
            }

            Slider(value: $currentTime, in: 0...duration, onEditingChanged: sliderEditingChanged)

            HStack {
                Text(formatTime(time: currentTime))
                Spacer()
                Text(formatTime(time: duration))
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
                    currentTime = 0.0
                }) {
                    Image(systemName: "stop.fill")
                        .padding()
                }
            }
            .disabled(player == nil)
        }
    }

    private func addPeriodicTimeObserver() {
        guard let player = player else { return }
        let interval = CMTime(seconds: 1, preferredTimescale: 600)
        playerObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            currentTime = time.seconds
        }
    }

    private func sliderEditingChanged(editingStarted: Bool) {
        guard let player = player else { return }
        if editingStarted {
            player.pause()
        } else {
            let targetTime = CMTime(seconds: currentTime, preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                if isPlaying {
                    player.play()
                }
            }
        }
    }

    private func formatTime(time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// Helper functions to fetch video URL and create player
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
