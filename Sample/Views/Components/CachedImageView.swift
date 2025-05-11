//
//  CachedImageView.swift
//  Sample
//
//  Created by Jeetesh Shaw on 12/05/25.
//

import SwiftUI

struct CachedImageView: View {
    @StateObject private var loader = ImageLoader()
    let urlString: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: width, height: height)
            }
        }
        .onAppear {
            loader.loadImage(from: urlString)
        }
    }
}
