//
//  AudioPlayerManager.swift
//  Sample
//
//  Created by Jeetesh Shaw on 11/05/25.
//

import Foundation

class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()

    @Published var currentSeries: Series?
    @Published var currentStoryIndex: Int = 0
    @Published var isPlaying: Bool = false
    @Published var showFullPlayer: Bool = false

    var audioPlayer = AudioPlayer()

    func setSeries(_ series: Series, startIndex: Int) {
        // Stop any current playback
        audioPlayer.stop()

        // Update current series and story
        currentSeries = series
        currentStoryIndex = startIndex

        let story = series.stories[startIndex]
        audioPlayer.load(url: story.audioURL)
        isPlaying = true
    }

    func togglePlayPause() {
        if isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
        isPlaying.toggle()
    }
    
}

