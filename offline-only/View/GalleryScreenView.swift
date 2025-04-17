//
//  GalleryScreenView.swift
//  offline-only
//
//  Created by marc on 17.04.25.
//

import SwiftUI

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}


// Model
struct Media: Identifiable, Codable, Hashable {
    let imageName: String
    let title: String
    var id: String { imageName }
}

// Data store
@MainActor
final class MediaStore: ObservableObject {
    @Published var media: [Media] = []

    init() { load() }

    private func load() {
        guard let url = Bundle.main.url(forResource: "media", withExtension: "json") else {
            assertionFailure("▲ media.json missing from bundle")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            media = try JSONDecoder().decode([Media].self, from: data)
        } catch {
            assertionFailure("▲ Failed to parse media.json: \(error)")
        }
    }
}

// Image
struct ZoomableMediaView: View {
    let imageName: String
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .gesture(MagnificationGesture()
                        .onChanged { value in
                            scale = lastScale * value
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                scale = scale.clamped(to: 1...4)
                                lastScale = scale
                            }
                        })
            .onTapGesture(count: 2) {
                withAnimation(.spring()) {
                    scale = 1
                    lastScale = 1
                }
            }
    }
}

// Gallery
struct GalleryScreenView: View {
    @StateObject private var store = MediaStore()
    @State private var currentIndex = 0
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 0)

                // Image
                if store.media.indices.contains(currentIndex) {
                    Image(store.media[currentIndex].imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.85)
                        .clipped()
                        .padding(.top, 32)
                }

                Spacer(minLength: 0)

                // Title
                VStack(alignment: .leading, spacing: 4) {
                    if store.media.indices.contains(currentIndex) {
                        Text(store.media[currentIndex].title)
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                    // Page counter
                    Text("\(currentIndex + 1) / \(max(store.media.count, 1))")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        guard !store.media.isEmpty else { return }
                        if value.translation.height < -50 {
                            // Swipe up
                            withAnimation(.spring()) {
                                currentIndex = (currentIndex + 1) % store.media.count
                            }
                        } else if value.translation.height > 50 {
                            // Swipe down
                            withAnimation(.spring()) {
                                currentIndex = (currentIndex - 1 + store.media.count) % store.media.count
                            }
                        }
                    }
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}


// Preview
#Preview {
    GalleryScreenView()
}
