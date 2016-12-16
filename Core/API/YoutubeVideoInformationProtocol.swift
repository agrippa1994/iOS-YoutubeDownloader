//
//  YoutubeVideoInformationProtocol.swift
//  YoutubeDownloader
//
//  Created by Manuel Leitold on 16.12.16.
//  Copyright © 2016 leitold. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
import UIKit

/////////////////////////////////////////////////////////////////////////////////////////////////

protocol YoutubeVideoInformationProtocol {
    var url       : URL      { get set }
    var thumbnail : UIImage? { get set }
    var title     : String   { get set }
}
