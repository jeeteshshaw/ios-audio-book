import SwiftUI
import SwiftUI

struct HomeView: View {
    let isLongStory: Bool // <- Use to filter stories

   
    @State private var currentIndex = 0
    @State private var isLoading = true // <- Add loading state
    @StateObject private var seriesService = RemoteSeriesService()
    @StateObject private var appVersionCheck = RemoteAppVersionService()


    @EnvironmentObject var playerManager: AudioPlayerManager

    var filteredStories: [Series] {
        seriesService.series
//        SampleData.series
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        BannerView(seriesList: filteredStories)

                        ForEach(filteredStories) { series in
                            NavigationLink(destination: SeriesDetailView(series: series)) {
                                StoryRowView(series: series)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                }
//
                VStack {
                    Spacer()
                    
                    if !filteredStories.isEmpty {
                            FloatingPlayerButton(
                                progress: playerManager.audioPlayer.progress,
                                    isPlaying: playerManager.isPlaying,
                                onTap: {
                                    playerManager.togglePlayPause()
                                },
                                onLongPress: { playerManager.showFullPlayer = true }
                            )
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        

                    } else {
                        // Placeholder message when no stories are available
                        Text("No stories available")
                            .foregroundColor(.gray)
                    }
                }
                
//
//                // Loading Indicator
                if isLoading {
                    ProgressView("Loading Stories...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
            }
            .navigationTitle(isLongStory ? "Story Stream" : "One-Shots")
            .sheet(isPresented: $playerManager.showFullPlayer) {
                FullscreenPlayerView()
                    .environmentObject(playerManager)
                    .edgesIgnoringSafeArea(.top)
            }
            .sheet(isPresented: $appVersionCheck.showUpdateSheet){
                UpdateSheet(onDismiss: {appVersionCheck.showUpdateSheet = false})
            }

            .onAppear {
                // Fetch the stories and update the loading state
                seriesService.fetchSeries(from: "https://raw.githubusercontent.com/jeeteshshaw/audio-book-data/refs/heads/main/SeriesList.json", completion:{_ in
                    print(seriesService.series)
                    isLoading = false
                } )
                appVersionCheck.fetchAppVersion(completion: {_ in })
            }
        }
    }
}



#Preview {
    HomeView(isLongStory: true )
        .environmentObject(AudioPlayerManager())
}
