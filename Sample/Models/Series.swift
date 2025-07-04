//
//  Series.swift
//  Sample
//
//  Created by Jeetesh Shaw on 11/05/25.
//

import Foundation

struct SeriesList: Codable {
    let series: [Series]
}


struct Series: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let coverImageURL: String
    let stories: [Story]
    
    
    func getStory(at index: Int) -> Story? {
            guard index >= 0 && index < stories.count else { return nil }
            return stories[index]
        }
}
