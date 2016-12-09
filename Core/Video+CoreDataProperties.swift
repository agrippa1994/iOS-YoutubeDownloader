//
//  Video+CoreDataProperties.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 09.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video");
    }

    @NSManaged public var title: String?
    @NSManaged public var thumbnail: NSData?
    @NSManaged public var path: String?
    @NSManaged public var date: NSDate?

}
