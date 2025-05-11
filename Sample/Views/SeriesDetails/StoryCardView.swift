//
//  StoryCardView.swift
//  Sample
//
//  Created by Jeetesh Shaw on 11/05/25.
//

import SwiftUI

struct StoryCardView: View {
    let story: Story
    var onPlay: (Story) -> Void
    func _onPlay() {
        onPlay(story)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(story.title)
                .font(.headline)

            HStack {
                Image(systemName: "headphones")
                Button(action: _onPlay){
                    Text("Listen Now")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
               
            }
        }
        .padding()
        .frame(width: .infinity)
//        .background(Color(.systemBackground)) // Adapts to light/dark mode
        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    StoryCardView(story: SampleData.stories[0], onPlay: {
        story in
        
    })
}
