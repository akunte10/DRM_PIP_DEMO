//
//  VideoService.swift
//  DRM_PIP_Demo
//
//  Created by Ajay Kunte on 10/03/25.
//

import Foundation

class VideoService {
    static let shared = VideoService()
    private let apiKey = "" // Add your api key here
    private let apiURL = "https://api.pexels.com/videos/popular?per_page=5"
    
    func fetchVideos(completion: @escaping ([Video]?) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(PexelsResponse.self, from: data)
                    let videos = decodedResponse.videos.map { Video(id: "\($0.id)", title: $0.user.name, url: $0.video_files.first?.link ?? "") }
                    DispatchQueue.main.async {
                        completion(videos)
                    }
                } catch {
                    print("Error decoding: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
