import Foundation
import Combine
import MediaPlayer
import FirebaseAnalytics

struct MockData {
    static let mockStory = Story(id: 1, title: "Sample Story", audioURL: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", coverImageURL: "", seriesId: "sample-series")
    
    static let mockSeries = Series(id: 1, title: "Sample Series", description: "A simple sample series.", coverImageURL: "", stories: [mockStory])
}

class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()
    
    @Published var currentSeries: Series?
    @Published var currentStoryIndex: Int = 0
    @Published var isPlaying: Bool = false
    @Published var showFullPlayer: Bool = false
    
    private let seriesKey = "currentSeries"
    private let indexKey = "currentStoryIndex"
    
    private var cancellables = Set<AnyCancellable>()

  
    
    var audioPlayer = AudioPlayer()
    
    private var nowPlayingInfoCenter: MPNowPlayingInfoCenter {
        return MPNowPlayingInfoCenter.default()
    }
    
    private var remoteCommandCenter: MPRemoteCommandCenter {
        return MPRemoteCommandCenter.shared()
    }

    

    init() {
        setupMediaControls()
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
                   .sink { [weak self] _ in
                       self?.playNextStory()
                   }
                   .store(in: &cancellables)
        self.loadPersistedData()
        self.loadUrl()
        // Set up static data (mock series and story)
//        setSeries(MockData.mockSeries, startIndex: 0)
    }
    
    func playPreviousStory() {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
            let story = currentSeries?.stories[currentStoryIndex]
            audioPlayer.loadAudio(url: story?.audioURL)
            isPlaying = true
        }
    }
    
    func playNextStory() {
        if currentStoryIndex < (currentSeries?.stories.count ?? 0) - 1 {
            currentStoryIndex += 1
            let story = currentSeries?.stories[currentStoryIndex]
            audioPlayer.loadAudio(url: story?.audioURL)
            isPlaying = true
        }
    }
    
    
    
    func setSeries(_ series: Series, startIndex: Int) {
        // Stop any current playback
        audioPlayer.stop()
        
        // Update current series and story
        currentSeries = series
        currentStoryIndex = startIndex
        
        // Fetch the story and ensure the audio URL is valid
        let story = currentSeries?.getStory(at: startIndex)
        
        // Load the audio URL and start playback
        audioPlayer.loadAudio(url: story?.audioURL)
        isPlaying = true // Update state
        updateNowPlayingInfo(for: story)
        self.persistData()
        Analytics.logEvent("series", parameters: [
            "title": series.title as NSObject,
            "episode": story?.title ?? "" as NSObject
        ])
    }
    
    func loadUrl () {
        audioPlayer.stop()
        
        // Update current series and story

        
        // Fetch the story and ensure the audio URL is valid
        let story = currentSeries?.getStory(at: self.currentStoryIndex)
        
        // Load the audio URL and start playback
        audioPlayer.loadAudio(url: story?.audioURL)
        self.audioPlayer.pause()
        updateNowPlayingInfo(for: story)
        self.persistData()
        
    }
    
    func togglePlayPause() {
        if isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
        isPlaying.toggle()
        
        // Update now playing info after toggling play/pause
        if let story = currentSeries?.getStory(at: currentStoryIndex) {
            updateNowPlayingInfo(for: story)
        }
    }
    
    private func updateNowPlayingInfo(for story: Story?) {
        guard let story = story else { return }
        
        var nowPlayingInfo = [String: Any]()
        
        // Set up the title and artist info
        nowPlayingInfo[MPMediaItemPropertyTitle] = story.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = story.seriesId
        
        // Track the playback state (0 for pause, 1 for play)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        // Set the current position of playback
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.progress
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    private func setupMediaControls() {
        remoteCommandCenter.playCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }
        
        remoteCommandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }
        
        // Handle skip next/previous commands
        remoteCommandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.skipToNextStory()
            return .success
        }
        
        remoteCommandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.skipToPreviousStory()
            return .success
        }
    }
    
    private func skipToNextStory() {
        guard let currentSeries = currentSeries else { return }
        currentStoryIndex = (currentStoryIndex + 1) % currentSeries.stories.count
        setSeries(currentSeries, startIndex: currentStoryIndex)
    }
    
    private func skipToPreviousStory() {
        guard let currentSeries = currentSeries else { return }
        currentStoryIndex = (currentStoryIndex - 1 + currentSeries.stories.count) % currentSeries.stories.count
        setSeries(currentSeries, startIndex: currentStoryIndex)
    }
    private func onComplete() {
        skipToNextStory()
    }
    private func persistData() {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(currentSeries) {
                UserDefaults.standard.set(data, forKey: seriesKey)
            }
            UserDefaults.standard.set(currentStoryIndex, forKey: indexKey)
        }

        private func loadPersistedData() {
            let decoder = JSONDecoder()
            if let data = UserDefaults.standard.data(forKey: seriesKey),
               let series = try? decoder.decode(Series.self, from: data) {
                self.currentSeries = series
            }
            self.currentStoryIndex = UserDefaults.standard.integer(forKey: indexKey)
        }

}
