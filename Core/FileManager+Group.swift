//
//  FileManager+Group.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 09.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//

import Foundation

extension FileManager {
    class var groupPath : URL! {
        return self.default.containerURL(forSecurityApplicationGroupIdentifier: kAppGroupName)
    }
}
