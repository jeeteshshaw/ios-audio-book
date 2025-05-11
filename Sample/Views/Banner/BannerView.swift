//
//  BannerView.swift
//  Sample
//
//  Created by Jeetesh Shaw on 10/05/25.
//
import SwiftUI

//struct BannerView: View {
//    let stories: [Story]
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 16) {
//                ForEach(stories) { story in
//                    BannerCard(story: story)
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}
struct BannerView: View {
    let seriesList: [Series]
    

    private var repeatedStories: [Series] {
        Array(repeating: seriesList, count: 10).flatMap { $0 }
    }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(repeatedStories) { series in
                    NavigationLink(destination: SeriesDetailView(series: series)) {
                        BannerCard(series: series)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
struct BannerCard: View {
    let series: Series
    var body: some View {
        ZStack(alignment: .bottomLeading) {
//            AsyncImage(url: URL(string: series.coverImageURL)) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            } placeholder: {
//                Color.gray.opacity(0.3)
//            }
//            .frame(width: 300, height: 180)
//            .clipped()
//            .cornerRadius(16)
            CachedImageView(urlString: series.coverImageURL, width: 300, height: 180)
                .cornerRadius(16)
                .clipped()
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.6), .clear]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(height: 60)
            .cornerRadius(16)

            Text(series.title)
                .foregroundColor(.white)
                .bold()
                .padding([.leading, .bottom], 12)
        }
        .frame(width: 300, height: 180)
        .cornerRadius(16)
        .shadow(radius: 4)
       
    }
        
}

#Preview {
    BannerView(seriesList: SampleData.series)
}
