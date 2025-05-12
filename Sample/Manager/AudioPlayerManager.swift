import Foundation
import MediaPlayer

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
    
    var audioPlayer = AudioPlayer()
    
    private var nowPlayingInfoCenter: MPNowPlayingInfoCenter {
        return MPNowPlayingInfoCenter.default()
    }
    
    private var remoteCommandCenter: MPRemoteCommandCenter {
        return MPRemoteCommandCenter.shared()
    }
    
    init() {
        setupMediaControls()
        
        // Set up static data (mock series and story)
//        setSeries(MockData.mockSeries, startIndex: 0)
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
        audioPlayer.load(url: story?.audioURL)
        isPlaying = true // Update state
        updateNowPlayingInfo(for: story)
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
}
