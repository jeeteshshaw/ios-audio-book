//
//  FloatingPlayerButton.swift
//  Sample
//
//  Created by Jeetesh Shaw on 11/05/25.
//
import SwiftUI

struct FloatingPlayerButton: View {
    var progress: Double // 0.0 to 1.0
    var isPlaying: Bool
    var onTap: () -> Void
    var onLongPress: () -> Void

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 64, height: 64)
                .shadow(radius: 4)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.white, lineWidth: 4)
                .frame(width: 64, height: 64)
                .rotationEffect(.degrees(-90))

            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .foregroundColor(.white)
                .font(.title2)
        }
        .contentShape(Circle()) // Make the whole circle tappable
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
}

#Preview {
    FloatingPlayerButton(progress: 12, isPlaying: true, onTap: {}, onLongPress:  {}
    )
}
