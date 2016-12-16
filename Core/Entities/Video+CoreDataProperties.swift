//
//  Video+CoreDataProperties.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 16.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//  This file was automatically generated and should not be edited.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
import CoreData

/////////////////////////////////////////////////////////////////////////////////////////////////

extension Video {

    /////////////////////////////////////////////////////////////////////////////////////////////////

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video");
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    @NSManaged public var date: NSDate?
    @NSManaged public var path: String?
    @NSManaged public var thumbnail: NSData?
    @NSManaged public var title: String?

}
