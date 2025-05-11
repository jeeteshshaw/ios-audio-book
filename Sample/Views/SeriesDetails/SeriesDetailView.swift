import SwiftUI

struct SeriesDetailView: View {
    let series: Series
    @EnvironmentObject var playerManager: AudioPlayerManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Series Cover Image
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = width * 2 / 3

                    CachedImageView(urlString: series.coverImageURL, width: width, height: height)
                }
                .frame(height: UIScreen.main.bounds.width * 2 / 3)


                // Title & Description
                VStack(alignment: .leading, spacing: 8) {
                    Text(series.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(series.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // List of Stories
                VStack(alignment: .leading, spacing: 12) {
                    Text("Episodes")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(series.stories.indices, id: \.self) { index in
                        let story = series.stories[index]
                        StoryCardView(story: story, onPlay: { _ in
                            playerManager.setSeries(series, startIndex: index)
                        })
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle(series.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SeriesDetailView(series: SampleData.series[0])
}
