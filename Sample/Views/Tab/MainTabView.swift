//
//  MainTabView.swift
//  Sample
//
//  Created by Jeetesh Shaw on 10/05/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView(isLongStory: false)
                .tabItem {
                    Image(systemName: "book")
                    Text("One-Shots")
                }

            HomeView(isLongStory: true)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Long Stories")
                }
        }
    }
}

#Preview {
    MainTabView()
}

