//
//  RemoteStoryService.swift
//  Sample
//
//  Created by Jeetesh Shaw on 10/05/25.
//

import Foundation
class RemoteSeriesService: ObservableObject {
    @Published var series: [Series] = []

    func fetchSeries(from urlString: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(false) }
                return
            }

            guard let data = data else {
                print("❌ No data received from: \(urlString)")
                DispatchQueue.main.async { completion(false) }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(SeriesList.self, from: data)
                DispatchQueue.main.async {
                    self.series = decoded.series
                    print("✅ Successfully decoded series: \(decoded.series.count) items")
                    completion(true)
                }
            } catch {
                print("❌ JSON Decoding failed: \(error)")
                DispatchQueue.main.async { completion(false) }
            }
        }.resume()
    }
}
