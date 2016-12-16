//
//  TmpCleaner.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 11.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

/////////////////////////////////////////////////////////////////////////////////////////////////

class TmpCleaner {

    /////////////////////////////////////////////////////////////////////////////////////////////////

    class func cleanTemporaryPath() throws {
        let fileMgr = FileManager.default
        let content = try fileMgr.contentsOfDirectory(atPath: NSTemporaryDirectory())
        for file in content {
            try fileMgr.removeItem(atPath: file)
        }
    }

}
