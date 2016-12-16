//
//  VideoProtocol.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 16.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
import UIKit

/////////////////////////////////////////////////////////////////////////////////////////////////

@objc
protocol VideoProtocol {
    var date        : NSDate?  { get set }
    var path        : String?  { get set }
    var thumbnail   : NSData?  { get set }
    var title       : String?  { get set }
}
