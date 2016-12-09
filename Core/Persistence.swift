//
//  Persistence.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 09.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//

import Foundation
import CoreData

private var singleton: Persistence?

class Persistence {
    public let container : NSPersistentContainer
    
    // singleton
    class var shared: Persistence {
        if singleton == nil {
            singleton = Persistence()
        }
        return singleton!
    }
    
    private init() {
        container = NSPersistentContainer(name: "YoutubeDownloader")
        
        let path = FileManager.groupPath.appendingPathComponent("Data.sqlite")
        let description = NSPersistentStoreDescription(url: path)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if error != nil {
                fatalError("Error while loading persistent file \(error)")
            }
        }
    }
    
    public func save() throws {
        if self.container.viewContext.hasChanges {
            try self.container.viewContext.save()
        }
    }
    
    public func fetchVideos() -> [Video] {
        let request: NSFetchRequest<Video> = Video.fetchRequest()
        if let videos = try? self.container.viewContext.fetch(request) {
            return videos
        }
        return []
    }
}
