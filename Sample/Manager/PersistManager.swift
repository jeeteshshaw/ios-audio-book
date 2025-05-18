//
//  PersistManager.swift
//  Sample
//
//  Created by Jeetesh Shaw on 18/05/25.
//

import Foundation

class PersistManager: ObservableObject {
    func save(_ currentSeries: Series, _ currentStoryIndex: Int, _ seriesKey: String, _ indexKey: String) {
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(currentSeries) {
            UserDefaults.standard.set(data, forKey: seriesKey)
        }
        UserDefaults.standard.set(currentStoryIndex, forKey: indexKey)
            

    }
}
