//
//  ContentView.swift
//  offline-only
//
//  Created by marc on 17.04.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        if networkMonitor.isConnected {
            OfflineScreenView()
        } else {
            // Offline content goes here
            GalleryScreenView()
        }
    }
}

#Preview {
    ContentView()
}
