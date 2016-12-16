//
//  VideoMock.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 16.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

/////////////////////////////////////////////////////////////////////////////////////////////////

class VideoMock : VideoProtocol, Hashable, Equatable {

    /////////////////////////////////////////////////////////////////////////////////////////////////

    var date        : NSDate?
    var path        : String?
    var thumbnail   : NSData?
    var title       : String?

    /////////////////////////////////////////////////////////////////////////////////////////////////

    convenience init(date: NSDate?, path: String?, thumbnail: NSData?, title: String?) {
        self.init()
        self.date = date
        self.path = path
        self.thumbnail = thumbnail
        self.title = title
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////

    var hashValue: Int {
        if title != nil {
            return title!.hash
        }
        return 0
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    static func ==(lhs: VideoMock, rhs: VideoMock) -> Bool {
        if lhs.title == nil || rhs.title == nil {
            return false
        }
        return lhs.title! == rhs.title!
    }
}
