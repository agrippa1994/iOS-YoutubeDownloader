//
//  YoutubeAPI.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 09.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//

import Foundation
import UIKit

import MMYoutubeMP4Extractor
import HCYoutubeParser

struct YoutubeVideoInformation {
    var url         : URL
    var thumbnail   : UIImage?
    var title       : String
}

enum YoutubeAPIError : Error {
    case VideoInformationFailed
    case NoTitle
}

class YoutubeAPI {
    class func retrieveVideoInformation(url: URL, completion: @escaping (YoutubeVideoInformation?, Error?) -> Void) {
        HCYoutubeParser.h264videos(withYoutubeURL: url) { details, error in
            if error != nil {
                return completion(nil, error!)
            }

            guard let moreInfo = details?["moreInfo"] as? NSDictionary else {
                return completion(nil, YoutubeAPIError.VideoInformationFailed)
            }

            guard let title = moreInfo["title"] as? String else {
                return completion(nil, YoutubeAPIError.NoTitle)
            }
            
            MMYoutubeMP4Extractor.sharedInstance().mp4(fromYoutubeURL: url.absoluteString) { mp4Url, error in
                if error != nil {
                    return completion(nil, error!)
                }
                
                HCYoutubeParser.thumbnail(forYoutubeURL: url, thumbnailSize: YouTubeThumbnailDefaultMaxQuality) { image, error in
                    let information = YoutubeVideoInformation(url: mp4Url!, thumbnail: image, title: title)
                    completion(information, nil)
                }
            }
        }
    }
}
