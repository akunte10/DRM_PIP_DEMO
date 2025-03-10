//
//  PexelsResponse.swift
//  DRM_PIP_Demo
//
//  Created by Ajay Kunte on 10/03/25.
//

import Foundation

struct Video: Identifiable, Codable {
    let id: String
    let title: String
    let url: String
}

struct PexelsResponse: Codable {
    let videos: [PexelsVideo]
}

struct PexelsVideo: Codable {
    let id: Int
    let user: PexelsUser
    let video_files: [PexelsVideoFile]
}

struct PexelsUser: Codable {
    let name: String
}

struct PexelsVideoFile: Codable {
    let link: String
}
