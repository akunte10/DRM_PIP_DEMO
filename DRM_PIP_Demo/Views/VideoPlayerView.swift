//
//  VideoPlayerView.swift
//  DRM_PIP_Demo
//
//  Created by Ajay Kunte on 10/03/25.
//

import Foundation
import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: String
    @Binding var isMiniPlayerActive: Bool
    @Binding var isPipEnabled: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: URL(string: videoURL)!)
        playerViewController.player = player
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.canStartPictureInPictureAutomaticallyFromInline = isPipEnabled
        playerViewController.videoGravity = .resizeAspectFill
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        applyDRMProtection(playerViewController: playerViewController)
        
        player.play()
        
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
    
    private func applyDRMProtection(playerViewController: AVPlayerViewController) {
        NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main) { _ in
            if UIScreen.main.isCaptured {
                DispatchQueue.main.async {
                    playerViewController.view.backgroundColor = .black
                }
            } else {
                DispatchQueue.main.async {
                    playerViewController.view.backgroundColor = .clear
                }
            }
        }
    }
}

// MARK: - Video Detail View
struct VideoDetailView: View {
    let video: Video
    @State private var isPipEnabled = false
    @EnvironmentObject var viewModel: VideoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            VideoPlayerView(videoURL: video.url, isMiniPlayerActive: Binding(
                get: { viewModel.miniPlayerVideo != nil },
                set: { if !$0 { viewModel.miniPlayerVideo = nil } }
            ), isPipEnabled: $isPipEnabled)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            Button("Enable PIP") {
                isPipEnabled = true
                viewModel.miniPlayerVideo = video
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}

extension Optional {
    func isNotNil() -> Bool {
        return self != nil
    }
}
