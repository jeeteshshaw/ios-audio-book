import Foundation
import AVFoundation
import Combine
import SwiftUI

class AudioPlayer: ObservableObject {
    private var player: AVPlayer?
    private var timeObserverToken: Any?

    @Published var isPlaying = false
    @Published var isBuffering = false
    @Published var progress: Double = 0.0 // 0.0 to 1.0
    @Published var duration: Double = 0.0
    @Published var playedTime: Double = 0.0
    

    private var currentURL: URL?

    // MARK: - Load New Audio
    func load(url: String?) {
        guard let urlString = url, let audioURL = URL(string: urlString) else {
            print("Invalid or nil audio URL")
            return
        }

       
        // Stop and remove previous observer
        stop()

        currentURL = audioURL
        player = AVPlayer(url: audioURL)
        duration = player?.currentItem?.duration.seconds ?? 0.0
        playedTime = 0.0
        observeProgress() // <- make sure this is called
        play()
    }

    // MARK: - Play / Pause
    func playPause() {
        guard let player = player else { return }

        if isPlaying {
            player.pause()
        } else {
            player.play()
        }

        isPlaying.toggle()
    }

    func play() {
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        pause()
        removeObserver()
        player = nil
        progress = 0.0
        currentURL = nil
    }
    func seek(to progress: Double) {
        guard let duration = player?.currentItem?.duration.seconds,
              duration.isFinite else { return }
        
        self.duration = duration

        let time = CMTime(seconds: duration * progress, preferredTimescale: 600)
        player?.seek(to: time)
    }



    // MARK: - Observe Progress
    private func observeProgress() {
        guard let player = player else { return }

        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self = self,
                  let duration = player.currentItem?.duration.seconds,
                  duration > 0 else { return }
            self.progress = time.seconds / duration
            self.playedTime = time.seconds
            self.duration = duration
        }
    }

    private func removeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }

    // Optional: release observer on deinit
    deinit {
        removeObserver()
    }
}
