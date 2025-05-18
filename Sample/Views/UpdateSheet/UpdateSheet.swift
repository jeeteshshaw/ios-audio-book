//
//  UpdateSheet.swift
//  Sample
//
//  Created by Jeetesh Shaw on 13/05/25.
//

import Foundation

import SwiftUI

struct UpdateSheet: View {
//    var onUpdate: () -> Void
    var onDismiss: () -> Void
    
    func onUpdate() {
        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
            UIApplication.shared.open(url)
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Update Available")
                .font(.title2)
                .bold()

            Text("A new version of the app is available. Please update to continue enjoying the latest features.")
                .font(.body)
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Button("Later") {
                    onDismiss()
                }
                .foregroundColor(.gray)
                Spacer()
                Button("Update Now") {
                    onUpdate()
                }
                .bold()
            }.padding()
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}
