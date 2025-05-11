//
//  SampleApp.swift
//  Sample
//
//  Created by Jeetesh Shaw on 06/05/25.
//

import SwiftUI

@main
struct SampleApp: App {
    @StateObject private var playerManager = AudioPlayerManager()

    var body: some Scene {
        WindowGroup {
            HomeView(isLongStory: true)
                .environmentObject(playerManager)
        }
    }
}
