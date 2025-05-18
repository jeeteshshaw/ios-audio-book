import SwiftUI
import AVFoundation

struct FullscreenPlayerView: View {
    @EnvironmentObject var playerManager: AudioPlayerManager
    @State private var isSeeking = false
    @State private var seekProgress: Double = 0.0
    
    
    
    var body: some View {
        VStack {
            if let series = playerManager.currentSeries {
//                // Header
                Text(series.title)
                    .font(.title)
                    .padding(.top)
//
//                // Episode List
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(series.stories.indices, id: \.self) { index in
                            EpisodeRowView(
                                story: series.stories[index],
                                isCurrent: index == playerManager.currentStoryIndex
                            )
                            .onTapGesture {
                                playerManager.currentStoryIndex = index
                                playerManager.audioPlayer.load(url: series.stories[index].audioURL)
                                playerManager.isPlaying = true
                            }
                        }
                    }
                    .padding()
                }
//
                HStack{
                    Text(String(formatTime(playerManager.audioPlayer.playedTime)))
                    Spacer()
                    Text(String(formatTime(playerManager.audioPlayer.duration)))
                }.padding()
               
                Slider(
                       value: $seekProgress,
                       in: 0...1,
                       onEditingChanged: { editing in
                           isSeeking = editing
                           if !editing {
                               playerManager.audioPlayer.seek(to: seekProgress)
                           }
                       }
                   )
                   .padding(.horizontal)
                   .onReceive(playerManager.audioPlayer.$progress) { newProgress in
                       if !isSeeking {
                           seekProgress = newProgress
                       }
                   }
//                // Player Controls
                HStack(spacing: 40) {
                    // Previous Button
                    Button(action: {
                        playerManager.playPreviousStory()
                    }) {
                        Image(systemName: "backward.fill")
                            .font(.title)
                    }

                    // Play/Pause Button
                    Button(action: {
                        playerManager.audioPlayer.playPause()
                        playerManager.isPlaying.toggle()
                    }) {
                        Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title)
                    }

                    // Next Button
                    Button(action: {
                        playerManager.playNextStory()
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.title)
                    }
                }
                .padding()

                .padding()
            } else {
                Text("No series selected")
                    .foregroundColor(.gray)
            }
        }
    }
    func formatTime(_ time: Double) -> String {
          guard !time.isNaN && !time.isInfinite else { return "00:00" }
          let totalSeconds = Int(time)
          let minutes = totalSeconds / 60
          let seconds = totalSeconds % 60
          return String(format: "%02d:%02d", minutes, seconds)
      }
}

struct EpisodeRowView: View {
    let story: Story
    let isCurrent: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(story.title)
                    .font(.headline)
                    .foregroundColor(isCurrent ? .accentColor : .primary)
            }
            Spacer()
            if isCurrent {
                Text("Playing")
                    .font(.caption)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .background(isCurrent ? Color.accentColor.opacity(0.1) : Color.clear)
        .cornerRadius(10)
    }
}
#Preview {
    FullscreenPlayerView()
        .environmentObject(AudioPlayerManager())
}
