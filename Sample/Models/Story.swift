//
//  Story.swift
//  Sample
//
//  Created by Jeetesh Shaw on 10/05/25.
//

import Foundation

struct Story: Identifiable, Codable {
    let id: Int
    let title: String
    let audioURL: String
    let coverImageURL: String
    let seriesId: String
}




