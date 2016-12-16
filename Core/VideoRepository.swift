//
//  VideoInformation.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 09.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
import UIKit
import CoreData

/////////////////////////////////////////////////////////////////////////////////////////////////

enum VideoValidationError : Error {
    case InvalidFilePath
}

/////////////////////////////////////////////////////////////////////////////////////////////////

private var singleton: VideoRepository?

/////////////////////////////////////////////////////////////////////////////////////////////////

class VideoRepository : VideoRepositoryProtocol {

    /////////////////////////////////////////////////////////////////////////////////////////////////

    class var shared: VideoRepository {
        if singleton == nil {
            singleton = VideoRepository()
        }
        return singleton!
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    private init() {}

    /////////////////////////////////////////////////////////////////////////////////////////////////

    func addVideo(information: YoutubeVideoInformationProtocol, localPath: URL) throws -> VideoProtocol {
        if !FileManager.default.fileExists(atPath: localPath.path) {
            throw VideoValidationError.InvalidFilePath
        }
        
        let context = Persistence.shared.container.viewContext
        let description = NSEntityDescription.entity(forEntityName: "Video", in: context)
        let video = Video(entity: description!, insertInto: nil)

        // Build video object
        video.path = localPath.path
        if information.thumbnail != nil {
            video.thumbnail = UIImagePNGRepresentation(information.thumbnail!)! as NSData?
        }
        video.title = information.title
        video.date = NSDate()
        return video
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    func fetchVideos() -> [VideoProtocol] {
        let request: NSFetchRequest<Video> = Video.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        if let videos = try? Persistence.shared.container.viewContext.fetch(request) {
            return videos
        }
        return []
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    func deleteVideo(video: VideoProtocol) {
        if video.path != nil {
            try? FileManager.default.removeItem(atPath: video.path!)
        }
        
        Persistence.shared.container.viewContext.delete(video as! Video)
    }
}
