//
//  SampleData.swift
//  Sample
//
//  Created by Jeetesh Shaw on 10/05/25.
//

import Foundation

struct SampleData {
    static let stories = [
        Story(
            id: 1,
            title: "The Lost Kingdom",
            audioURL: "https://example.com/audio/lost_kingdom.mp3",
            coverImageURL: "https://picsum.photos/id/1011/400/250",
            seriesId: "1"
        ),
        Story(
            id: 2,
            title: "The Lost Kingdom",
            audioURL: "https://example.com/audio/lost_kingdom.mp3",
            coverImageURL: "https://picsum.photos/id/1011/400/250",
            seriesId: "1"
        )
    ]
    
    static let series: [Series] = [
        Series(id: 1, title: "The Lost Kingdom Series", description: "A collection of tales from the ancient world.", coverImageURL: "https://picsum.photos/id/1011/400/250", stories: stories),
        Series(id: 2, title: "The Lost Kingdom Series 2", description: "A collection of tales from the ancient world.", coverImageURL: "https://picsum.photos/id/1011/400/250", stories: stories)
    ]
}
