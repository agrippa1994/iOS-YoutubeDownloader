//
//  VideoRepositoryProtocol.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 16.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

/////////////////////////////////////////////////////////////////////////////////////////////////

protocol VideoRepositoryProtocol {
    func addVideo(information: YoutubeVideoInformationProtocol, localPath: URL) throws -> VideoProtocol
    func fetchVideos() -> [VideoProtocol]
    func deleteVideo(video: VideoProtocol)
}
