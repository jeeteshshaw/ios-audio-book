//
//  ImageLoader.swift
//  Sample
//
//  Created by Jeetesh Shaw on 12/05/25.
//

import SwiftUI
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private static let cache = NSCache<NSString, UIImage>()

    func loadImage(from urlString: String) {
        if let cachedImage = ImageLoader.cache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageLoader.cache.setObject(uiImage, forKey: urlString as NSString)
                    self.image = uiImage
                }
            }
        }.resume()
    }
}
