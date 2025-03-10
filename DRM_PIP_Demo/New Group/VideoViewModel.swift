//
//  VideoViewModel.swift
//  DRM_PIP_Demo
//
//  Created by Ajay Kunte on 10/03/25.
//

import Foundation

class VideoViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var miniPlayerVideo: Video?
    
    func fetchVideos() {
        VideoService.shared.fetchVideos { [weak self] videos in
            if let videos = videos {
                self?.videos = videos
            }
        }
    }
}
