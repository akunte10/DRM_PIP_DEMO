//
//  VideoListView.swift
//  DRM_PIP_Demo
//
//  Created by Ajay Kunte on 10/03/25.
//

import Foundation
import SwiftUI

struct VideoListView: View {
    @StateObject var viewModel = VideoViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                List(viewModel.videos) { video in
                    NavigationLink(destination: VideoDetailView(video: video).environmentObject(viewModel)) {
                        Text(video.title.capitalized)
                            .font(.headline)
                    }
                }
                .onAppear {
                    viewModel.fetchVideos()
                }
                .navigationTitle("Videos")
            }
            
            if let miniPlayerVideo = viewModel.miniPlayerVideo {
                MiniPlayerView(videoURL: miniPlayerVideo.url, isMiniPlayerActive: Binding(
                    get: { viewModel.miniPlayerVideo != nil },
                    set: { if !$0 { viewModel.miniPlayerVideo = nil } }
                ))
                .transition(.move(edge: .bottom))
                .animation(.easeInOut)
            }
        }
    }
}

// MARK: - Mini Player View
struct MiniPlayerView: View {
    let videoURL: String
    @Binding var isMiniPlayerActive: Bool
    @State private var offset = CGSize.zero
    @State private var crossButtonOffset = CGPoint(x: -10, y: -10)
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayerView(videoURL: videoURL, isMiniPlayerActive: $isMiniPlayerActive, isPipEnabled: .constant(true))
                .frame(width: 200, height: 150)
                .cornerRadius(10)
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
                .padding()
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.offset = gesture.translation
                            self.crossButtonOffset = CGPoint(x: gesture.location.x + 10, y: gesture.location.x + 10)
                        }
                        .onEnded { _ in
                            //if self.offset.width > 100 { isMiniPlayerActive = false }
                        }
                )
            
            Button(action: { isMiniPlayerActive = false }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.black)
                    .padding(6)
                    //.background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .offset(x: offset.width - 5, y: offset.height - 10)
        }
    }
}
