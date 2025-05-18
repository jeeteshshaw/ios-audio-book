//
//  RemoteStoryService.swift
//  Sample
//
//  Created by Jeetesh Shaw on 10/05/25.
//

import Foundation

let urlString = "https://raw.githubusercontent.com/jeeteshshaw/audio-book-data/refs/heads/main/home.json"
let version = "1.0.0"

class RemoteAppVersionService: ObservableObject {
    @Published var appVersion: AppVersion = AppVersion(androidVersion: "1.0.0", iosVersion: "1.0.0", text: "Initial Build")
    @Published var showUpdateSheet: Bool = false
    
    func fetchAppVersion(completion: @escaping (Bool) -> Void) {
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
                let decoded = try JSONDecoder().decode(AppVersion.self, from: data)
                DispatchQueue.main.async {
                    self.appVersion = decoded
                    if(decoded.iosVersion != version){
                        self.showUpdateSheet = true
                    }
                    print("✅ Successfully decoded version: \(decoded.iosVersion) items")
                    completion(true)
                }
            } catch {
                print("❌ JSON Decoding failed: \(error)")
                DispatchQueue.main.async { completion(false) }
            }
        }.resume()
    }
}
