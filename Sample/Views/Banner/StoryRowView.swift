//
//  StoryRowView.swift
//  Sample
//
//  Created by Jeetesh Shaw on 10/05/25.
//

import SwiftUI

struct StoryRowView: View {
    let series: Series
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            CachedImageView(urlString: series.coverImageURL, width: 80, height: 80)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)

            VStack(alignment: .center) {
                Text(series.title)
                    .font(.headline)
                    
                Text(series.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding(.leading, 8)
            .frame(alignment: .center)
        }
        
        .padding()
        .frame(maxWidth: .infinity)
//        .padding(.horizontal)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(10)
        .shadow(color: colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.1), radius: 6, x: 2, y: 4)
    }
    
}


#Preview {
    StoryRowView(series: SampleData.series[0])
}
