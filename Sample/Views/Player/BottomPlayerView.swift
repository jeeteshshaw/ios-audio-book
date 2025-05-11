//
//  BottomPlayerView.swift
//  Sample
//
//  Created by Jeetesh Shaw on 10/05/25.
//

import SwiftUI
struct BottomPlayerView: View {
    @Binding var isPlaying: Bool
    var series: Series
    @ObservedObject var audioPlayer: AudioPlayer // Use the shared AudioPlayer
    var onPrevious: () -> Void
    var onNext: () -> Void
    var onExpand: () -> Void
   

    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text(series.title)
                    .font(.subheadline)
                    .lineLimit(1)

                Spacer()

                Button(action: onPrevious) {
                    Image(systemName: "backward.fill")
                }

                Button(action: {
//                    audioPlayer.play(audioURL: series.audioURL )
//                    isPlaying.toggle()
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                }

                Button(action: onNext) {
                    Image(systemName: "forward.fill")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .onTapGesture {
                onExpand()
            }
        }
    }
}



